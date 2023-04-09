local None = require(script.Parent.None)
local types = require(script.Parent.types)

type Comparator = types.Comparator

type SingletonCacheImpl = {
	__index: SingletonCacheImpl,
	new: (equals: Comparator) -> SingletonCache,
	get: (self: SingletonCache, key: any) -> any?,
	put: (self: SingletonCache, key: any, value: any?) -> (),
	getEntries: (self: SingletonCache) -> { [any]: any },
	clear: (self: SingletonCache) -> (),
}

type SingletonCache = typeof(setmetatable(
	{} :: {
		_entry: { key: any, value: any }?,
		_comparator: Comparator,
	},
	{} :: SingletonCacheImpl
))

local singleton = {} :: SingletonCacheImpl
singleton.__index = singleton

function singleton.new(comparator)
	local self = {
		_entry = nil,
		_comparator = comparator,
	}

	return setmetatable(self, singleton)
end

function singleton:get(key)
	if self._entry and self._comparator(self._entry.key, key) then
		return self._entry.value
	end

	return None
end

function singleton:put(key, value)
	self._entry = {
		key = key,
		value = value,
	}
end

function singleton:getEntries()
	return { self._entry }
end

function singleton:clear()
	self._entry = nil
end

return singleton
