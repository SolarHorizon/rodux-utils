local Immut = require(script.Parent.Parent.Immut)

--[=[
	@class Draft

	Helper functions for use with Drafts. These are reexported from
	[Immut](https://github.com/solarhorizon/immut).
]=]

--[=[
	@within Draft
	@function current
	@param draft Draft<State>
	@return State

	Returns a snapshot of the current state of a draft. This can be expensive!
	Use it sparingly.
]=]

--[=[
	@within Draft
	@function original
	@param draft Draft<State>
	@return State

	Get the original table from a draft.
]=]

--[=[
	@within Draft
	@function insert
	@param draft Draft<State>
	@param pos number | V,
	@param value V?
	@return V?

	Draft-safe replacement for `table.insert`
]=]

--[=[
	@within Draft
	@function remove
	@param draft Draft<{V}>
	@param pos number?
	@return V?

	Draft-safe replacement for `table.remove`
]=]

return {
	current = Immut.current,
	original = Immut.original,
	insert = Immut.insert,
	remove = Immut.remove,
}
