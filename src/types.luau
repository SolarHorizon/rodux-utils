--!strict
export type Payload = (...any?) -> any?

export type ActionCreator<Type = string, Callback = Payload> = typeof(setmetatable(
	{} :: { name: Type },
	{} :: {
		__call: (any, ...any?) -> {
			type: string,
			payload: any?,
		},
	}
))

export type Reducer = (state: any?, action: any) -> any

return nil
