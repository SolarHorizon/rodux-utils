--!strict
local types = require(script.Parent.types)

type PrepareFn = (...any?) -> any?

local function default(payload: any?): any?
	return payload
end

local function createAction(name: string, prepareFn: PrepareFn?): types.ActionCreator
	return setmetatable({
		name = name,
	}, {
		__call = function(_self: any, ...)
			return {
				type = name,
				payload = (prepareFn or default :: PrepareFn)(...),
			}
		end,
	})
end

return createAction
