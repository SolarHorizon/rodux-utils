--!strict
local types = require(script.Parent.types)

local function makeActionCreator(name: string, fn: types.Payload): types.ActionCreator
	return setmetatable({
		name = name,
	}, {
		__call = function(_self: any, ...)
			return {
				type = name,
				payload = fn(...),
			}
		end,
	})
end

return makeActionCreator
