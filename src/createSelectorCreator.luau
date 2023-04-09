local defaultMemoize = require(script.Parent.defaultMemoize)

type Selector<State = any> = (state: State, ...any) -> any?
type ResultFn = (...any) -> any?
type MemoizeOptions = defaultMemoize.MemoizeOptions

--[=[
	@within RoduxUtils
	@type MemoizeFn (fn: function, ...any?) -> function
]=]
type MemoizeFn<F = (...any?) -> any?> = (fn: F, ...any?) -> F

--[=[
	@within RoduxUtils
	@param memoizeFn -- your custom memoization function
	@param ... any? -- any additional arguments to pass to `memoizeFn`
	@return createSelector

	Used to create a custom version of `createSelector`.

	```lua
	local customSelectorCreator = createSelectorCreator(
		customMemoize, -- function to be used to memoize `fn`
		option1, -- option1 will be passed as the second argument to `customMemoize`
		option2 -- option2 will be passed as the third argument to `customMemoize`
	)

	local customSelector = customSelectorCreator(
		{
			selectFoo,
			selectBar,
		},
		resultFunc -- resultFunc will be passed as the first argument to `customMemoize`
	)
	```

	You can find more examples of this in action [here](https://github.com/reduxjs/reselect#createselectorcreatormemoize-memoizeoptions).
]=]
local function createSelectorCreator(memoizeFn: MemoizeFn, ...: any?)
	local defaultMemoizeOptions = { ... }

	--[=[
		@within RoduxUtils
		@param inputSelectors
		@param resultFn
		@param memoizeOptions -- options for `defaultMemoize`, or the first argument to a custom memoization function
		@param ... -- additional arguments for a custom memoize function

		Create a memoized selector.

		```lua
		local selectTotal = createSelector({
			function(state)
				return state.values.value1
			end,
			function(state)
				return state.values.value2
			end,
		}, function(value1, value2)
			return value1 + value2
		end)
		```
	]=]
	local function createSelector(
		inputSelectors: { Selector },
		resultFn: ResultFn,
		memoizeOptions: MemoizeOptions? | any?,
		...: any?
	)
		local finalOptions = if memoizeOptions
			then { memoizeOptions, ... }
			else defaultMemoizeOptions

		local memoizedResultFn = memoizeFn(function(...)
			return resultFn(...)
		end, table.unpack(finalOptions))

		local selector = memoizeFn(function(...)
			local params = {}

			for i, input in inputSelectors do
				params[i] = input(...)
			end

			return memoizedResultFn(table.unpack(params))
		end)

		return selector
	end

	return createSelector
end

return createSelectorCreator
