return function()
	local createSelector = require(script.Parent.createSelector)

	it("should pass the result of each input selector to resultFn", function()
		local results = {}

		local selector = createSelector({
			function(state)
				return state.a
			end,
			function(state)
				return state.b
			end,
		}, function(a, b)
			results.a = a
			results.b = b
			return
		end)

		selector({
			a = "foo",
			b = "bar",
		})

		expect(results.a).to.equal("foo")
		expect(results.b).to.equal("bar")
	end)

	it("should return the result of resultFn", function()
		local selector = createSelector({
			function(state)
				return state.a
			end,
			function(state)
				return state.b
			end,
		}, function(a, b)
			return { a = a, b = b }
		end)

		local results = selector({
			a = "foo",
			b = "bar",
		})

		expect(results.a).to.equal("foo")
		expect(results.b).to.equal("bar")
	end)

	it("should pass any additional arguments to the input selectors", function()
		local fooCount = 0
		local barCount = 0

		local function count(_state: {}, foo: string, bar: string)
			if foo == "foo" then
				fooCount += 1
			end

			if bar == "bar" then
				barCount += 1
			end

			return nil
		end

		local selector = createSelector({ count, count }, function()
			return
		end)

		selector({}, "foo", "bar")

		expect(fooCount).to.equal(2)
		expect(barCount).to.equal(2)
	end)

	it("should memoize the resultFn", function()
		local count = 0

		local selector = createSelector({
			function(state)
				return state.foo
			end,
			function(state)
				return state.bar
			end,
		}, function(foo, bar)
			count += 1

			return {
				foo = foo,
				bar = bar,
			}
		end)

		selector({ foo = true, bar = true })
		expect(count).to.equal(1)

		selector({ foo = true, bar = true })
		expect(count).to.equal(1)

		selector({ foo = true, bar = false })
		expect(count).to.equal(2)

		selector({ foo = true, bar = false })
		expect(count).to.equal(2)

		-- make sure it can handle nil values
		selector({ foo = nil, bar = true })
		expect(count).to.equal(3)

		selector({ foo = nil, bar = true })
		expect(count).to.equal(3)

		selector({ foo = true, bar = nil })
		expect(count).to.equal(4)

		selector({ foo = true, bar = nil })
		expect(count).to.equal(4)
	end)

	it("should use the given cache size", function()
		local count = 0

		local selector = createSelector({
			function(state)
				return state.value
			end,
		}, function(value)
			count += 1
			return value
		end, {
			maxSize = 3,
		})

		selector({ value = 1 })
		selector({ value = 2 })
		selector({ value = 3 })

		expect(count).to.equal(3)

		selector({ value = 1 })
		selector({ value = 2 })
		selector({ value = 3 })

		expect(count).to.equal(3)

		selector({ value = 4 })
		expect(count).to.equal(4)
	end)

	it("should use the given equalityCheck function", function()
		local count = 0

		local selector = createSelector({
			function(state)
				return state
			end,
		}, function(value)
			count += 1
			return value
		end, {
			equalityCheck = function(a, b)
				return typeof(a) == typeof(b)
			end,
		})

		expect(selector(1)).to.equal(1)
		expect(selector(2)).to.equal(1)
		expect(count).to.equal(1)

		expect(selector("a")).to.equal("a")
		expect(count).to.equal(2)
	end)

	it("should use the given resultEqualityCheck function", function()
		local selector = createSelector({
			function(state)
				return state
			end,
		}, function(value)
			return value
		end, {
			resultEqualityCheck = function(a, b)
				return typeof(a) == typeof(b)
			end,
		})

		expect(selector(1)).to.equal(1)
		expect(selector(2)).to.equal(1)
		expect(selector("a")).to.equal("a")
	end)
end
