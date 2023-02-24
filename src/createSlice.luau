--!strict
local ReducerBuilder = require(script.Parent.ReducerBuilder)
local createAction = require(script.Parent.createAction)
local createReducer = require(script.Parent.createReducer)
local types = require(script.Parent.types)

type ActionCreator = types.ActionCreator
type Reducer = types.Reducer
type PrepareFn = createAction.PrepareFn
type ReducerBuilder = ReducerBuilder.ReducerBuilder
type ExtraReducerMap = ReducerBuilder.Cases

type ExtraReducers = (builder: ReducerBuilder) -> () | ExtraReducerMap
type ReducerAndPrepareFn = { reducer: Reducer, prepare: PrepareFn }
type ReducerMap = { [string]: Reducer | ReducerAndPrepareFn }

local function makeActionsAndReducerMap(map: ReducerMap)
	local actions = {}
	local reducers = {}

	for type, reducer in map do
		if typeof(reducer) == "function" then
			actions[type] = createAction(type)
			reducers[type] = reducer
		else
			assert(
				typeof(reducer) == "table",
				"reducers passed to createSlice must either be a function or a table with a reducer & a prepare function"
			)

			actions[type] = createAction(type, reducer.prepare)
			reducers[type] = reducer.reducer
		end
	end

	return actions, reducers
end

local function createSlice<T>(
	name: string,
	initialState: T?,
	reducers: ReducerMap,
	extraReducers: ExtraReducers?
)
	local actions, reducerMap = makeActionsAndReducerMap(reducers)

	if typeof(extraReducers) == "table" then
		for type, handler in reducerMap do
			reducerMap[type] = handler
		end
	end

	local reducer = createReducer(initialState, function(builder)
		builder._cases = reducerMap

		if typeof(extraReducers) == "function" then
			extraReducers(builder)
		end
	end)

	return {
		name = name,
		reducer = reducer,
		actions = actions,
		initialState = initialState,
	}
end

return createSlice
