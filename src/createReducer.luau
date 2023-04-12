local Immut = require(script.Parent.Parent.Immut)

local types = require(script.Parent.types)
local ReducerBuilder = require(script.Parent.ReducerBuilder)

type Reducer = types.Reducer
type BuilderCallback = (builder: typeof(ReducerBuilder.new({} :: any))) -> ()

type Cases = ReducerBuilder.Cases
type Matchers = ReducerBuilder.Matchers

--[=[
	@within RoduxUtils
	@param initialState any?
	@param callbackOrHandlers BuilderCallback | Cases?
	@param matchers Matchers? -- not used with BuilderCallback
	@param defaultHandler Reducer? -- not used with BuilderCallback
	@return Reducer

	A simpler way to write a reducer function. Each reducer made with
	`createReducer` is wrapped in an Immut producer, meaning that you can mutate
	the `state` value passed into your handlers. You can add cases for specific
	action types just like you can with Rodux's `createReducer`, but you can
	also add Matcher handlers that will run when a condition that you define is
	met. 

	Multiple matchers can run for the same action. They are run sequentially in 
	the order you defined them.

	### Examples

	#### Callback notation

	The recommended way to use `createReducer` is by using a ReducerBuilder with
	the callback notation. It is more readable than using the map notation.

	```lua
	local reducer = createReducer(initialState, function(builder)
		builder
			:addCase("itemAdded", function(state, action)
				-- you can mutate `state` here, it's fine!
				state.items[action.itemId] = action.item
			end)
			:addCase("itemRemoved", function(state, action)
				state.items[action.itemId] = nil
			end)
			-- run this handler if the action contains a `shouldLog` property
			:addMatcher(function(action)
				return action.shouldLog == true
			end, function(state, action)
				-- remember: we can't use table.insert on a draft
				Draft.insert(state.loggedActions, action)
			end)
			-- set a fallback for any time an action is dispatched that isn't
			-- handled by a matcher or case reducer
			:addDefaultCase(function(state, action)
				state.unhandledActions += 1
			end)
	end)
	```

	#### Map notation

	You can also use the map notation if you prefer. It should feel similar to 
	the `createReducer` function that comes with Rodux. You cannot add a default
	case when using the map notation.

	This is primarily meant for internal use.

	```lua
	local reducer = createReducer(initialState, {
		-- case reducers
		itemAdded = function(state, action)
			state.items[action.itemId] = action.item
		end,
		itemRemoved = function(state, action)
			state.items[action.itemId] = nil
		end,
	}, {
		-- matchers
		{
			matcher = function(action)
				return action.shouldLog == true
			end,
			reducer = function(state, action)
				Draft.insert(state.loggedActions, action)
			end,
		}
	})
	-- we can't add a default case with the map notation
	```
]=]
local function createReducer<T>(
	initialState: T?,
	callbackOrHandlers: BuilderCallback | Cases?,
	matchers: Matchers?,
	defaultHandler: Reducer?
): Reducer
	local reducer

	if typeof(callbackOrHandlers) == "function" then
		local builder = ReducerBuilder.new(initialState)
		callbackOrHandlers(builder :: any)
		reducer = builder:_finish()
	end

	if typeof(callbackOrHandlers) == "table" then
		local builder = ReducerBuilder.fromMap(
			initialState,
			callbackOrHandlers,
			matchers,
			defaultHandler
		)

		reducer = builder:_finish()
	end

	assert(
		reducer ~= nil,
		`callbackOrHandlers should be a table or function. Got a {typeof(
			callbackOrHandlers
		)}`
	)

	return function(state, action)
		if Immut.isDraft(state) or not Immut.isDraftable(state) then
			return reducer(state, action)
		end

		return Immut.produce(state, function(draft)
			return reducer(draft, action)
		end)
	end
end

return createReducer
