local ReducerBuilder = require(script.Parent.ReducerBuilder)
local createAction = require(script.Parent.createAction)
local createReducer = require(script.Parent.createReducer)
local types = require(script.Parent.types)

type ActionCreator = types.ActionCreator
type Reducer = types.Reducer
type PrepareFn = createAction.PrepareFn
type ReducerBuilder = ReducerBuilder.ReducerBuilder
type Cases = ReducerBuilder.Cases
type ExtraReducers = (builder: ReducerBuilder) -> () | Cases

--[=[
	@within RoduxUtils
	@type ReducerMap { [string]: Reducer | ReducerAndPrepareFn }
]=]
type ReducerMap = { [string]: Reducer | ReducerAndPrepareFn }

--[=[
	@within RoduxUtils
	@interface ReducerAndPrepareFn
	.reducer Reducer
	.prepare PrepareFn
]=]
type ReducerAndPrepareFn = { reducer: Reducer, prepare: PrepareFn }

--[=[
	@within RoduxUtils
	@interface SliceOptions
	.name string
	.initialState State?
	.reducers ReducerMap
	.extraReducers ((builder: ReducerBuilder) -> () | Cases)?
]=]
type SliceOptions<State> = {
	name: string,
	initialState: State?,
	reducers: ReducerMap,
	extraReducers: ExtraReducers?,
}

--[=[
	@within RoduxUtils
	@interface Slice
	.name string
	.reducer Reducer
	.actions { [string]: ActionCreator },
	.initialState State?
]=]
export type Slice<State> = {
	name: string,
	reducer: Reducer,
	actions: { [string]: ActionCreator },
	initialState: State?,
}

local function makeActionsAndReducerMap(map: ReducerMap, sliceName: string)
	local actions = {}
	local reducers = {}

	for type, reducer in map do
		if typeof(reducer) == "function" then
			actions[type] = createAction(sliceName .. "/" .. type)
			reducers[actions[type].name] = reducer
		else
			assert(
				typeof(reducer) == "table",
				"reducers passed to createSlice must either be a function or a table with a reducer & a prepare function"
			)

			actions[type] = createAction(sliceName .. "/" .. type, reducer.prepare)
			reducers[actions[type].name] = reducer.reducer
		end
	end

	return actions, reducers
end

--[=[
	@within RoduxUtils

	Automatically generates a reducer and action creators for you. Uses
	`createAction` and `createReducer` internally, so you're able to customize
	each generated action creator and use drafts in the reducers.

	### Example

	Let's create a slice for a todo list. We'll make actions for adding &
	removing todos from the list, but not for marking a todo as complete.
	We'll assume our project already has an action for completing tasks, and
	reuse it in our todo slice.

	```lua
	local todoSlice = createSlice({
		name = "todo", 
		initialState = {},
		reducers = {
			-- uses createReducer, so you can mutate state because it's a draft
			todoRemoved = function(state, action)
				state[action.payload] = nil
			end,
			todoAdded = {
				reducer = function(state, action)
					state[action.payload.name] = { done = action.payload.done }
				end,
				-- customize the generated action creator
				prepare = function(name, done)
					return {
						payload = {
							name = name,
							done = done,
						}
					}
				end,
			},
		},
		-- add additional cases that might be relevant to this slice, but have
		-- an action creator generated elsewhere (like in another slice)
		extraReducers = function(builder)
			builder:addCase("taskCompleted", function(state, action)
				local todo = state[action.payload.name]

				if todo then
					todo.done = true
				end
			end)
		end,
	)
	```

	Now, let's set up the store and use our slice.

	```lua
	local todosSlice = require(ReplicatedStorage.Todos.slice)
	local tasksSlice = require(ReplicatedStorage.Tasks.slice)

	local todos = todosSlice.actions
	local tasks = tasksSlice.actions

	local reducer = Rodux.combineReducers({
		todos = todosSlice.reducer,
		tasks = tasksSlice.reducer,
	})

	local store = Store.new(reducer)

	-- add a new todo, mark it as not done
	store:dispatch(todos.todoAdded("Buy groceries", false))

	-- complete a task, and mark the todo as done
	store:dispatch(tasks.taskCompleted("Buy groceries")

	-- remove the todo entirely
	store:dispatch(todos.todoRemoved("Buy groceries"))
	```
]=]
local function createSlice<State>(options: SliceOptions<State>): Slice<State>
	local actions, reducerMap = makeActionsAndReducerMap(options.reducers, options.name)

	if typeof(options.extraReducers) == "table" then
		for type, handler in reducerMap do
			reducerMap[type] = handler
		end
	end

	local reducer = createReducer(options.initialState, function(builder)
		builder._cases = reducerMap

		if typeof(options.extraReducers) == "function" then
			options.extraReducers(builder)
		end
	end)

	return {
		name = options.name,
		reducer = reducer,
		actions = actions,
		initialState = options.initialState,
	}
end

return createSlice
