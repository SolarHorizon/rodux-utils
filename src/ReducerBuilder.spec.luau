--!strict
return function()
	local ReducerBuilder = require(script.Parent.ReducerBuilder)

	describe("_finish", function()
		it(
			"should return a reducer which returns the initial state by default",
			function()
				local reducer = ReducerBuilder.new({ foo = "bar" }):_finish()
				expect(reducer).to.be.a("function")

				local newState = reducer(nil, { type = "baz" })
				expect(newState.foo).to.equal("bar")
			end
		)
	end)

	describe("addDefaultCase", function()
		it("should change the default handler", function()
			local reducer = ReducerBuilder.new({ foo = "bar" })
				:addDefaultCase(function()
					return { foo = "baz" }
				end)
				:_finish()

			local newState = reducer(nil, { type = "qux" })
			expect(newState.foo).to.equal("baz")
		end)
	end)

	describe("addCase", function()
		it("should add a new handler to the reducer", function()
			local add = false
			local sub = false

			local reducer = ReducerBuilder.new({ value = 0 })
				:addCase("add", function(state: { value: number }, _action)
					local newState = table.clone(state)
					newState.value += 1
					add = true
				end)
				:addCase("sub", function(state: { value: number }, _action)
					local newState = table.clone(state)
					newState.value -= 1
					sub = true
				end)
				:_finish()

			local addState = reducer(nil, { type = "add" })
			expect(addState.value).to.equal(1)
			expect(add).to.equal(true)

			local subState = reducer(nil, { type = "sub" })
			expect(subState.value).to.equal(-1)
			expect(sub).to.equal(true)
		end)
	end)

	describe("addMatcher", function()
		it("should run the handler when the matcher returns true", function()
			local add = false
			local sub = false

			local reducer = ReducerBuilder.new({ value = 0 })
				:addMatcher(function(action)
					return action.shouldAdd
				end, function(state: { value: number })
					local newState = table.clone(state)
					newState.value += 1
					add = true
					return newState
				end)
				:addMatcher(function(action)
					return action.shouldSub
				end, function(state: { value: number })
					local newState = table.clone(state)
					newState.value -= 1
					sub = true
					return newState
				end)
				:_finish()

			local addState = reducer(nil, { type = "foo", shouldAdd = true })
			expect(addState.value).to.equal(1)
			expect(add).to.equal(true)

			local subState = reducer(nil, { type = "foo", shouldSub = true })
			expect(subState.value).to.equal(-1)
			expect(sub).to.equal(true)
		end)
	end)
end
