return function()
	local createCacheKeyComparator =
		require(script.Parent.createCacheKeyComparator)

	local function equal(a: any?, b: any?)
		return a == b
	end

	it("should return a function", function()
		expect(createCacheKeyComparator(equal)).to.be.a("function")
	end)

	it("should use the given equalityFn to determine equality", function()
		local equalComparator = createCacheKeyComparator(equal)

		local shallowEqualComparator = createCacheKeyComparator(
			function(a: any, b: any)
				if a == b then
					return true
				end

				for key, value in a do
					if b[key] ~= value then
						return false
					end
				end

				for key, value in a do
					if b[key] ~= value then
						return false
					end
				end

				return true
			end
		)

		local foobar = table.pack("foo", { "bar" })
		local foobar2 = table.pack("foo", { "bar" })
		local foobaz = table.pack("foo", { "baz" })

		expect(equalComparator(foobar, foobar)).to.equal(true)
		expect(equalComparator(foobar, foobar2)).to.equal(false)
		expect(equalComparator(foobar, foobaz)).to.equal(false)

		expect(shallowEqualComparator(foobar, foobar)).to.equal(true)
		expect(shallowEqualComparator(foobar, foobar2)).to.equal(true)
		expect(shallowEqualComparator(foobar, foobaz)).to.equal(false)
	end)
end
