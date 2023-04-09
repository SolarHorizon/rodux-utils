local types = require(script.Parent.Parent.types)

export type ArgsList = typeof(table.pack({} :: any))
export type Comparator = (old: ArgsList, new: ArgsList) -> boolean
export type EqualityFn = types.EqualityFn

-- doesn't work
--export type CacheImpl<Cache> = {
--	__index: CacheImpl<Cache>,
--	get: (self: Cache, key: any) -> any?,
--	put: (self: Cache, key: any, value: any?) -> (),
--	getEntries: (self: Cache) -> { [any]: any },
--	clear: (self: Cache) -> (),
--}

return nil
