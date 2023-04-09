local caches = require(script.cache)
local defaultEquals = require(script.Parent.defaultEquals)
local getOptions = require(script.getOptions)
local types = require(script.types)

export type MemoizeOptions = getOptions.MemoizeOptions
type EqualityFn = types.EqualityFn

--[=[
	@within RoduxUtils

	Memoizes a function. This is the default memoization function for
	`createSelector`.

	@param fn -- The function you want to memoize
	@param equalityFnOrOptions
]=]
local function defaultMemoize<Args...>(
	fn: (Args...) -> any?,
	equalityFnOrOptions: (EqualityFn | MemoizeOptions)?
)
	local options = getOptions(equalityFnOrOptions)

	local comparator =
		caches.createCacheKeyComparator(options.equalityCheck or defaultEquals)

	local cache = caches.getCache(options.maxSize or 1, comparator)

	return function(...: Args...)
		local arguments = table.pack(...)

		local value = cache:get(arguments)

		if value == caches.None then
			value = fn(...)

			if options.resultEqualityCheck then
				local entries = cache:getEntries()

				for _, entry in entries do
					if options.resultEqualityCheck(entry.value, value) then
						value = entry.value
					end
				end
			end

			cache:put(arguments, value)
		end

		return value
	end
end

return defaultMemoize
