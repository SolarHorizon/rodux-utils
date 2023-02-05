local createSlice = require(script.createSlice)
local makeActionCreator = require(script.makeActionCreator)
local types = require(script.types)

export type ActionCreator = types.ActionCreator
export type Payload = types.Payload
export type Reducer = types.Reducer

return {
	createSlice = createSlice,
	makeActionCreator = makeActionCreator,
}
