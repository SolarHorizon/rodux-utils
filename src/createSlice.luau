--!strict
local types = require(script.Parent.types)
local makeActionCreator = require(script.Parent.makeActionCreator)

local function makeActionCreators(reducers)
	local actions = {}

	for type in reducers do
		actions[type] = makeActionCreator(type, function(payload)
			return payload
		end)
	end

	return actions
end

local function createSlice(
	name: string,
	initialState: any?,
	reducers: { [string]: types.Reducer },
	extraReducers: { [types.ActionCreator]: types.Reducer }?
)
	local actions = makeActionCreators(reducers)

	if extraReducers then
		for actionCreator, handler in extraReducers do
			reducers[actionCreator.name] = handler
		end
	end

	local function reducer(state, action)
		if state == nil then
			state = initialState
		end

		local handler = reducers[action.type]

		if handler then
			return handler(state, action)
		end

		return state
	end

	local function getInitialState()
		return initialState
	end

	return {
		name = name,
		reducer = reducer,
		actions = actions,
		getInitialState = getInitialState,
	}
end

return createSlice
