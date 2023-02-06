local createAction = require(script.createAction)
local createSlice = require(script.createSlice)
local types = require(script.types)

export type Action = types.Action
export type ActionCreator = types.ActionCreator
export type Payload = types.Payload
export type Reducer = types.Reducer

return {
	createAction = createAction,
	createSlice = createSlice,
}
