--[=[
	@within RoduxUtils
	@interface MemoizeOptions
	.equalityCheck EqualityFn?
	.resultEqualityCheck EqualityFn?
	.maxSize number?

	MemoizeOptions can be used to customize the Memoize instance
	returned from `defaultMemoize`.
]=]
export type MemoizeOptions = {
	equalityCheck: EqualityFn?,
	resultEqualityCheck: EqualityFn?,
	maxSize: number?,
}

type EqualityFn = (a: any?, b: any?) -> boolean

local function getOptions(
	equalityFnOrOptions: (MemoizeOptions | EqualityFn)?
): MemoizeOptions
	if typeof(equalityFnOrOptions) == "table" then
		return equalityFnOrOptions
	end

	return {
		equalityCheck = equalityFnOrOptions,
		maxSize = 1,
	}
end

return getOptions
