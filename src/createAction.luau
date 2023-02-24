--!strict
local types = require(script.Parent.types)

type PrepareFn = (...any?) -> { [any]: any }

local function default(payload: any?)
	return {
		payload = payload,
	}
end

local function createAction<T>(
	name: T,
	prepareFn: PrepareFn?
): types.ActionCreator<T>
	return setmetatable({
		name = name,
	}, {
		__call = function(_self: any, ...)
			local body = (prepareFn or default :: PrepareFn)(...)
			assert(typeof(body) == "table", "prepareFn should return a table")

			body.type = name

			return body
		end,
	})
end

return createAction
