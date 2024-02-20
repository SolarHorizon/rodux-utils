# Deriving data from State

Ideally, your Rodux store should contain the least amount of data it possibly
can while still being useful as the single source of truth. Any additional data
can be derived from that state when you need it. Rodux stores contain global
state. They shouldn't be concerned with filtering or sorting data for your UI.
Your UI should be doing that!

## Selectors

Selectors are functions that encapsulate the logic for deriving data from
state. They allow you to keep your state minimal by shifting the burden of
calculating more complicated data to the consumer of the state.

We'll use this pattern in the following example to filter some data. Our state
contains a list of all of the players ingame right now. We're going to create
a filter that only returns players who are on the blue team.

Here's what our state looks like:

```lua
local state = {
    players = {
        { username = "Alex", team = "green" },
        { username = "Ben", team = "red" },
        { username = "Matt", team = "blue" },
    }
}
```

And here's how we'll filter it with a selector:

```lua
local function selectBlueTeam(state)
    local blueTeam = {}

    for _, player in state.players do
        if player.team == "blue" then
            table.insert(blueTeam, player)
        end
    end

    return blueTeam
end
```

Now we can get all of the Blue team's players from our state when it changes.

```lua
-- A Roact component somewhere...
local function blueTeamList(props)
    local blueTeam = useSelector(selectBlueTeam)

    ...
end
```

As you can see, this made it pretty easy to get exactly what we were looking
for without having to split our state up to accomodate the team feature of our
game. We don't need a reducer for teams, we can just derive team data from our
existing players reducer.

There is a problem with this implementation, though. Every time the store
updates, we're going to call that `selectBlueTeam` selector. It might not be
that bad with only four players, but as the size of the server expands, that
filter is going to become slower. It would be nice if we could only run the
selector when we needed to.

## Memoization & createSelector

### The basics

Memoization is a technique that prevents calling a pure function when the
result would be the same as the last time it was called. It does this by
caching the result of the function and the arguments passed to it. Since a
selector is a pure function, we can memoize it! RoduxUtils includes a helper
for creating memoized selectors named `createSelector`.

Let's rewrite our `selectBlueTeam` selector using `createSelector`.

```lua
local function selectPlayers(state)
    return state.players
end

local selectBlueTeam = createSelector({ selectPlayers }, function(players)
    local blueTeam = {}

    for _, player in players do
        if player.team == "blue" then
            table.insert(blueTeam, player)
        end
    end

    return blueTeam
end)
```

There's a lot to unpack here! Let's start with the `selectPlayers` function.
It's another selector, but it's very simple. Even simpler than our original
`selectBlueTeam` selector.

So, what's its purpose here? `selectPlayers` is an input selector. Under the
hood, `createSelector` is passing the result of `selectPlayers` to our result
function, which, in this case, is the function responsible for actually
filtering the players. Since our state is immutable, that means if nothing in
`state.players` has changed, it's going to be the same value that was passed to
our result function before.

That's where memoization kicks in! Since `createSelector` memoizes the result
function for us, it won't run it again unless `state.players` has changed.

### Passing arguments

The usefulness of `createSelector` doesn't end there, though. You can also use
it to create selectors that are capable of taking more arguments than just
`state`. Our `selectBlueTeam` selector would be a lot more useful if it could
select any team we wanted, wouldn't it? Let's rewrite it again with that in
mind.

```lua
local function selectPlayers(state)
    return state.players
end

local function selectTeamName(state, teamName)
    return teamName
end

local selectTeam = createSelector({
    selectPlayers,
    selectTeamName,
}, function(players, teamName)
    local team = {}

    for _, player in players do
        if player.team == teamName then
            table.insert(team, player)
        end
    end

    return team
end)
```

That'll work, but how do we use it? Where is the `teamName` argument coming
from? When you call a selector created with `createSelector`, it can take as
many arguments as you'd like. The first argument should always be your state.
To use this selector, we'd call it like so:

```lua
    selectTeam(state, "red")
```

## Custom memoization settings

### Increasing the cache size

By default, `createSelector` will only cache the last result. You can tweak this
to your liking by passing in an additional configuration argument.

```lua
local selectTeam = createSelector({ selectPlayers }, function(players)
    ...
end, {
    -- set the cache size to 3
    maxSize = 3,
})
```

Now we'll cache the last 3 results of our result function. The included
memoization function uses an LRU cache when the size is greater than 1.

### Reducing recomputations with custom equality checks

You can change the function used to check for equality between old and new
arguments that are passed to your selector. This might be useful when the
result of one of your input selectors has some nested values that you want
to pay extra attention to.

For our example, let's take our selectors for the red and blue team and use
them as our inputs. With them, we'll create a new purple team. Since our
red and blue team selectors return a new table every time we run them, we will
have to check the contents of each table to be sure that they're actually
different. Otherwise, our result function will run every time the players in
our state change, even if they aren't relevant to the purple team!

```lua
local inputSelectors = { selectRedTeam, selectBlueTeam }

local selectPurpleTeam = createSelector(inputSelectors, function(red, blue)
    local purpleTeam = {}

    for _, player in red do
        table.insert(purpleTeam, player)
    end

    for _, player in blue do
        table.insert(purpleTeam, player)
    end

    return purpleTeam
end, {
    -- returns true if red & blue team's players are the same as they were
    -- the last time the function was called
    equalityCheck = shallowEquals,
})
```

Nice! We've created a new team just by deriving data from what's available in
our state.

It doesn't end there! There's actually another way to solve this problem. We
can use `resultEqualityCheck` to check the equality of a result. Remember how we
had to use a custom `equalityCheck` because our selectors were returning a new
table every time? We can avoid that problem entirely this way.

We'll only refactor `selectBlueTeam` for now.

```lua
local function selectPlayers(state)
    return state.players
end

local selectBlueTeam = createSelector({ selectPlayers }, function(players)
    local blueTeam = {}

    for _, player in players do
        if player.team == "blue" then
            table.insert(blueTeam, player)
        end
    end

    return blueTeam
end, {
    resultEqualityCheck = shallowEquals,
})
```

That's all it needed! Now, when all of the players on the blue team are the
same as they were before, the selector will return the old table instead of a
new one. This can help with avoiding unnecessary reconciliation in a Roact
component, or prevent another selector that uses this one as an input from
running again. Like our `selectPurpleTeam` selector!

If you made this change to the `selectRedTeam` selector as well, you'll have
solved the problem that required us to use a shallow comparison for the
arguments passed to the `selectPurpleTeam` selector. Neat!
