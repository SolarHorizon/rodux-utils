return function()
	local memoize = require(script.Parent)

	it("should return the result of the function", function()
		local foo = memoize(function(a: string, b: string)
			return a .. b
		end)

		expect(foo("bar", "baz")).to.equal("barbaz")
		expect(foo("baz", "qux")).to.equal("bazqux")
		expect(foo("bar", "foo")).to.equal("barfoo")
	end)

	it("should only call the function when the arguments change", function()
		local count = 0

		local foo = memoize(function(a: string, b: string)
			count += 1
			return a .. b
		end)

		expect(foo("bar", "baz")).to.equal("barbaz")
		expect(count).to.equal(1)

		expect(foo("bar", "baz")).to.equal("barbaz")
		expect(count).to.equal(1)

		expect(foo("bar", "foo")).to.equal("barfoo")
		expect(count).to.equal(2)
	end)

	it("should use the given equalityCheck function", function()
		local count = 0

		local memoized = memoize(function(a)
			count += 1
			return a
		end, function(a, b)
			return typeof(a) == typeof(b)
		end)

		expect(memoized(1)).to.equal(1)
		expect(memoized(2)).to.equal(1)
		expect(count).to.equal(1)

		expect(memoized("a")).to.equal("a")
		expect(count).to.equal(2)
	end)

	it(
		"should return an existing cache entry when resultEqualityCheck returns true",
		function()
			local todos = {
				{ id = 1 },
				{ id = 2 },
				{ id = 3 },
			}

			local clonedTodos = {}

			for i, v in todos do
				clonedTodos[i] = table.clone(v)
			end

			local getTodoIds = memoize(function(todoState)
				local ids = {}

				for _, todo in todoState do
					table.insert(ids, todo.idstate)
				end

				return ids
			end, {
				resultEqualityCheck = function(old, new)
					return old.id == new.id
				end,
			})

			local resultA = getTodoIds(todos)
			local resultB = getTodoIds(clonedTodos)

			expect(resultA).to.equal(resultB)
		end
	)
end
