local Lru = require(script.Parent.Lru)
local Singleton = require(script.Parent.Singleton)

type Cache = {
	get: (self: any, key: any) -> any?,
	put: (self: any, key: any, value: any?) -> (),
	getEntries: (self: any) -> { [any]: any },
	clear: (self: any) -> (),
}

local function getCache(maxSize, comparator): Cache
	assert(
		maxSize > 0,
		"The maximum size for a cache must be a number greater than 0"
	)

	if maxSize > 1 then
		return Lru.new(maxSize, comparator) :: any
	end

	return Singleton.new(comparator) :: any
end

return getCache
