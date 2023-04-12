--[=[
	@class RoduxUtils

	A collection of useful functions for projects that use Rodux.
]=]

local createAction = require(script.createAction)
local createReducer = require(script.createReducer)
local createSelector = require(script.createSelector)
local createSelectorCreator = require(script.createSelectorCreator)
local createSlice = require(script.createSlice)
local Draft = require(script.Draft)
local types = require(script.types)

export type Action = types.Action
export type ActionCreator = types.ActionCreator
export type Reducer = types.Reducer

return {
	createAction = createAction,
	createReducer = createReducer,
	createSelector = createSelector,
	createSelectorCreator = createSelectorCreator,
	createSlice = createSlice,
	Draft = Draft,
}
