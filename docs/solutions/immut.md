# Dealing with Immutable data

One major pain point a lot of Rodux developers have to deal with is that
working with immutable state can be cumbersome. Handling it yourself becomes
increasingly complicated as the complexity of your state increases. There are
some great libraries that help with this, but with them comes a lot of
boilerplate.

## Introducing Immut

[Immut](https://github.com/solarhorizon/immut) can address this problem. With
Immut, you can write code that _looks_ like it is mutating your immutable data,
but actually isn't. Immut uses a proxy that allows you to alter it directly,
and only applies your changes to a copy of the original table.

Rodux Utils uses Immut in its [`createReducer`](/api/RoduxUtils#createReducer)
function to allow you to write reducers in this way. Let's take a look at an
example to illustrate the differences between Immut and a more common Immutable
data library.

In this example, we're using Rodux on the server to keep track of multiple
players' inventories. We're going to write a handler for an `itemAdded` action.
It'll add the item, stored in `action.payload`, to the player's inventory. We'll
get the UserId of the player from `action.meta.userId`.

Using an Immut "producer":

```lua
local inventoryReducer = Rodux.createReducer({
    itemAdded = function(state, action)
        return Immut.produce(state, function(draft)
            local inventory = draft.players[action.meta.userId]
            inventory[action.payload.itemId] = action.payload
        end)
    end,
})
```

Using an existing Immutable data library:

```lua
local inventoryReducer = Rodux.createReducer({
    itemAdded = function(state, action)
        return Dictionary.merge(state, {
            players = Dictionary.merge(state, {
                [action.meta.userId] = Dictionary.merge(state[action.meta.userId], {
                    [action.payload.itemId] = action.payload
                })
            })
        })
    end,
})
```

As you can see, the Immut-powered reducer is a lot more readable, and was a lot
simpler to write. Ultimately, both of these reducers are doing the same thing.
They're shallow copying any table you intend to modify, and adding new data to
those tables.

With the RoduxUtils version of `createReducer`, your handlers are automatically
wrapped with `Immut.produce`, so you don't need to worry about including it
yourself. The rest of the examples on this page will be using the RoduxUtils
version. We'll refer to this version as an "Immut reducer" to keep it simple.

:::tip
From this point onwards, this article will use the callback notation of
`RoduxUtils.createReducer` when creating a reducer. Read the
[API section](/api/RoduxUtils#createReducer) on `createReducer` for more info.
:::

## Returning

### A value

When returning a value from an Immut reducer, the returned value will be used
as the result rather than the draft. This is useful when we're doing something
like discarding the whole state and replacing it with a new one.

```lua
local reducer = RoduxUtils.createReducer(function(builder)
    builder:addCase("stateReset", function(state, action)
        return {} -- sets state to {}
    end)
end)
```

### nil

Returning nil from an Immut reducer is the same as returning state.

All three of the following handlers will have the same result.

```lua
local reducer = RoduxUtils.createReducer(function(builder)
    builder
        :addCase("returnState", function(state, action)
            state.value += 1
            return state
        end)
        :addCase("returnNil", function(state, action)
            state.value += 1
            return nil
        end)
        :addCase("noReturn", function(state, action)
            state.value += 1
        end)
end)
```

## Using the table library

Unfortunately, Lua's (and by extension, Luau's) builtin table library does not
work as expected with drafts. To get around this, Immut comes with replacements
for `table.remove` and `table.insert`. They are exposed from RoduxUtils as
[`Draft.remove`](/api/Draft#remove) and [`Draft.insert`](/api/Draft#insert).

## Opting out

None of this is to say that Immut is always better. There may be cases where you
find that being explicit is better. In that case, you may opt to write your
reducer manually. You should always try to use the best tool for the job!

Opting out of Immut for certain handlers is easy. Just call `Draft.original` on
the draft state passed into your handler to get the original table. You can
then proceeed as you would normally.

```lua
local inventoryReducer = RoduxUtils.createReducer(function(builder)
    builder:addCase("itemRemoved", function(draft, action)
        local state = Draft.original(draft)
        local newState = table.clone(state)

        -- we can now write our reducer without Immut

        return newState
    end)
end)
})
```

You can do this at any point in your handler. It doesn't need to be from the
start.
