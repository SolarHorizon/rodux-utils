local types = require(script.Parent.types)

local function createKeyComparator(equalityFn: types.EqualityFn)
	return function(old: types.ArgsList, new: types.ArgsList)
		--if #old ~= #new then
		--	return false
		--end

		for key, value in old do
			if not equalityFn(new[key], value) then
				return false
			end
		end

		for key, value in new do
			if not equalityFn(old[key], value) then
				return false
			end
		end

		return true
	end
end

return createKeyComparator
