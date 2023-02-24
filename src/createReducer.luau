--!strict
local Immut = require(script.Parent.Parent.Immut)

local types = require(script.Parent.types)
local ReducerBuilder = require(script.Parent.ReducerBuilder)

type Reducer = types.Reducer
type BuilderCallback = (builder: typeof(ReducerBuilder.new({} :: any))) -> ()

type Cases = ReducerBuilder.Cases
type Matchers = ReducerBuilder.Matchers

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
