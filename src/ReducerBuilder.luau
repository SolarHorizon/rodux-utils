--!strict
local types = require(script.Parent.types)

type Action = types.Action
type ActionCreator = types.ActionCreator
type Reducer = types.Reducer

--[=[
	@within ReducerBuilder
	@type Cases { [string]: Reducer }
]=]
export type Cases = {
	[string]: Reducer,
}

--[=[
	@within ReducerBuilder
	@type Matchers { { matcher: (Action) -> boolean, reducer: Reducer } }
]=]
export type Matchers = {
	{
		matcher: (Action) -> boolean,
		reducer: Reducer,
	}
}

-- make it stop
type ReducerBuilderImpl = {
	__index: ReducerBuilderImpl,
	new: <T>(initialState: T?) -> ReducerBuilder,
	fromMap: <T>(
		initialState: T?,
		cases: Cases?,
		matchers: Matchers?,
		defaultCase: Reducer?
	) -> ReducerBuilder,
	addCase: (
		self: ReducerBuilder,
		action: string | ActionCreator,
		handler: Reducer
	) -> ReducerBuilder,
	addMatcher: (
		self: ReducerBuilder,
		matcher: (Action) -> boolean,
		handler: Reducer
	) -> ReducerBuilder,
	addDefaultCase: (
		self: ReducerBuilder,
		handler: Reducer
	) -> ReducerBuilder,
	_finish: (self: ReducerBuilder) -> Reducer,
}

export type ReducerBuilder = typeof(setmetatable(
	{} :: {
		_cases: Cases,
		_matchers: Matchers,
		_initialState: any?,
		_defaultCase: Reducer,
	},
	{} :: ReducerBuilderImpl
))

--[=[
	@class ReducerBuilder
]=]
local ReducerBuilder = {} :: ReducerBuilderImpl
ReducerBuilder.__index = ReducerBuilder

local function freeze(t: {})
	if not table.isfrozen(t) then
		table.freeze(t)
	end
end

local function defaultReducer(state: any?, _action: any)
	return state
end

function ReducerBuilder.new(initialState)
	if typeof(initialState) == "table" then
		freeze(initialState)
	end

	local self = {
		_cases = {},
		_matchers = {},
		_initialState = initialState,
		_defaultCase = defaultReducer,
	}

	return setmetatable(self, ReducerBuilder)
end

function ReducerBuilder.fromMap(initialState, cases, matchers, defaultCase)
	local self = ReducerBuilder.new(initialState :: any)
	self._cases = cases or self._cases :: any
	self._matchers = matchers or self._matchers :: any
	self._defaultCase = defaultCase or defaultReducer :: any

	return self
end

function ReducerBuilder:_finish()
	return function(state, action)
		state = state or self._initialState

		local case = self._cases[action.type]
		local newState

		if case then
			newState = case(state, action)
		end

		for _, match in self._matchers do
			if match.matcher(action) then
				newState = match.reducer(newState or state, action)
			end
		end

		if newState == nil then
			newState = self._defaultCase(state, action)
		end

		return newState
	end
end

--[=[
	@param action ActionCreator | string -- The action creator or type name
	@param reducer Reducer

	Adds a case reducer. Can only be called before `addMatcher` and
	`addDefaultCase`.

	Case reducers are reducers that handle one type of action. They are the
	standard way of writing reducers in Rodux.
]=]
function ReducerBuilder:addCase(action, reducer)
	assert(
		table.isfrozen(self._cases) == false,
		"addCase cannot be called after addMatcher or addDefaultCase"
	)

	local type = if typeof(action) == "table" then action.name else action
	self._cases[type] = reducer
	return self
end

--[=[
	@param matcher (action: Action) -> boolean
	@param reducer Reducer

	Adds a matcher. Cannot be called after `addDefaultCase`.

	Matchers can be used to handle actions based on your own custom logic
	rather than only matching the type.
]=]
function ReducerBuilder:addMatcher(matcher, reducer)
	assert(
		table.isfrozen(self._matchers) == false,
		"addMatcher cannot be called after addDefaultCase"
	)

	freeze(self._cases)

	self._matchers[#self._matchers + 1] = {
		matcher = matcher,
		reducer = reducer,
	}

	return self
end

--[=[
	@param reducer Reducer

	Adds a fallback reducer. This will be invoked if no case reducers or
	matchers were executed for an action.

	After adding a default case you cannot modify the reducer anymore, so this
	should be reserved for the very last part of the chain.
]=]
function ReducerBuilder:addDefaultCase(reducer)
	assert(
		self._defaultCase == defaultReducer,
		"addDefaultCase cannot be called more than once"
	)

	self._defaultCase = reducer

	freeze(self._cases)
	freeze(self._matchers)
	freeze(self :: any)

	return self
end

return ReducerBuilder
