local types = require(script.Parent.types)

type ActionCreator<T> = types.ActionCreator<T>
export type PrepareFn = (...any?) -> { [any]: any }

local function default(payload: any?)
	return {
		payload = payload,
	}
end

--[=[
	@within RoduxUtils

	Similar to Rodux's `makeActionCreator`, except any additional data is put
	inside of a `payload` property by default. This can be overriden with a
	custom prepareFn.

	## Examples

	#### Using the default structure

	```lua
	local todoAdded = createAction("todoAdded")

	
	print(todoAdded("Buy groceries")) -- { type = "todoAdded", payload = "Buy groceries" }
	```

	#### Using a custom structure

	```lua
	local playerJoined = createAction("playerJoined", function(userId)
		return {
			payload = userId,
			isRoblox = userId == 1,
		}
	end)

	print(playerJoined(1)) -- { type = "playerJoined", payload = 1, isRoblox = true }
	```
]=]
local function createAction<Type>(
	name: Type,
	prepareFn: PrepareFn?
): ActionCreator<Type>
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
