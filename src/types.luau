export type Action<T = any> = {
	type: T,
	[string]: any,
}

export type ActionCreator<T = string> = typeof(setmetatable(
	{} :: { name: T },
	{} :: {
		__call: (any, ...any?) -> Action<T>,
	}
))

export type Reducer<T = any> =
	((state: T, action: Action) -> T?)
	& ((state: T, action: Action) -> ())

return nil
