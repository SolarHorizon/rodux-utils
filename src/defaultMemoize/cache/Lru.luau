local None = require(script.Parent.None)
local types = require(script.Parent.types)

type Comparator = types.Comparator

-- could not get this to work properly
--type LruCacheImpl =
--	types.CacheImpl<LruCache>
--	& { new: (size: number, equals: Comparator) -> LruCache }

type LruCacheImpl = {
	__index: LruCacheImpl,
	new: (size: number, equals: Comparator) -> LruCache,
	get: (self: LruCache, key: any) -> any?,
	put: (self: LruCache, key: any, value: any?) -> (),
	getEntries: (self: LruCache) -> { [any]: any },
	clear: (self: LruCache) -> (),
}

type LruCache = typeof(setmetatable(
	{} :: {
		_entries: { { key: any, value: any } },
		_comparator: Comparator,
		_maxSize: number,
	},
	{} :: LruCacheImpl
))

local lru = {} :: LruCacheImpl
lru.__index = lru

function lru.new(size, comparator)
	local self = {
		_entries = table.create(size),
		_comparator = comparator,
		_maxSize = size,
	}

	return setmetatable(self, lru)
end

function lru:get(key)
	local index

	for i, entry in self._entries do
		if self._comparator(entry.key, key) then
			index = i
			break
		end
	end

	if index == nil then
		return None
	end

	local entry = self._entries[index]

	if index > 1 then
		table.remove(self._entries, index)
		table.insert(self._entries, 1, entry)
	end

	return entry.value
end

function lru:put(key, value)
	if self:get(key) == None then
		if #self._entries == self._maxSize then
			table.remove(self._entries, self._maxSize)
		end

		table.insert(self._entries, 1, {
			key = key,
			value = value,
		})
	end
end

function lru:getEntries()
	return self._entries
end

function lru:clear()
	self._entries = table.create(self._maxSize)
end

return lru
