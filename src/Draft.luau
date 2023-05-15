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
	@param t { V }
	@param pos number
	@param value V

	Draft-safe replacement for `table.insert`.

	https://create.roblox.com/docs/reference/engine/libraries/table#insert
]=]

--[=[
	@within Draft
	@function remove
	@param t { V }
	@param pos number?
	@return V?

	Draft-safe replacement for `table.remove`.

	https://create.roblox.com/docs/reference/engine/libraries/table#remove
]=]

--[=[
	@within Draft
	@function sort
	@param t { V }
	@param comp function

	Draft-safe replacement for `table.sort`.

	https://create.roblox.com/docs/reference/engine/libraries/table#sort
]=]

--[=[
	@within Draft
	@function clear
	@param t { [K]: V }

	Draft-safe replacement for `table.clear`.

	https://create.roblox.com/docs/reference/engine/libraries/table#clear
]=]

--[=[
	@within Draft
	@function find
	@param haystack { [K]: V }
	@param needle V
	@param init number
	@return number?

	Draft-safe replacement for `table.find`.

	https://create.roblox.com/docs/reference/engine/libraries/table#find
]=]

--[=[
	@within Draft
	@function concat
	@param t { V }
	@param sep string?
	@param i number?
	@param j number?
	@return string

	Draft-safe replacement for `table.find`.

	https://create.roblox.com/docs/reference/engine/libraries/table#concat
]=]

--[=[
	@within Draft
	@prop None None

	When returned from a recipe, the next value will be nil.

	```lua
	local new = produce(state, function(draft)
		return None
	end)

	print(new) -- nil
	```
]=]

--[=[
	@within Draft
	@prop nothing None

	Alias for [`None`](/api/Draft#None)
]=]

return {
	current = Immut.current,
	original = Immut.original,
	nothing = Immut.nothing,
	None = Immut.None,

	clear = Immut.table.clear,
	concat = Immut.table.concat,
	find = Immut.table.find,
	insert = Immut.table.insert,
	remove = Immut.table.remove,
	sort = Immut.table.sort,
}
