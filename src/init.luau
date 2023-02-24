local createAction = require(script.createAction)
local createReducer = require(script.createReducer)
local createSlice = require(script.createSlice)

local types = require(script.types)

export type Action = types.Action
export type ActionCreator = types.ActionCreator
export type Reducer = types.Reducer

return {
	createAction = createAction,
	createReducer = createReducer,
	createSlice = createSlice,
}
