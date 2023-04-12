return function()
	local createSlice = require(script.Parent.createSlice)

	local initialState = table.freeze({ enabled = false })

	local slice = createSlice({
		name = "debug",
		initialState = initialState,
		reducers = {
			debugStateSet = function(_state: any, action: any)
				return { enabled = action.payload }
			end,
			debugDisabled = function(_state: any, _action: any)
				return { enabled = false }
			end,
			debugEnabled = function(_state: any, _actio: any)
				return { enabled = true }
			end,
		},
	})

	it("should return a table", function()
		expect(slice).to.be.a("table")
	end)

	describe("actions", function()
		it("should be a dictionary of ActionCreators", function()
			expect(slice.actions).to.be.a("table")

			for key, value in slice.actions do
				expect(key).to.be.a("string")
				expect(value).to.be.a("table")
				expect(value.name).to.be.a("string")
				expect(getmetatable(value)).to.be.ok()
				expect(getmetatable(value).__call).to.be.a("function")
			end
		end)

		it("should contain valid action creators", function()
			for type, creator in slice.actions do
				expect(creator).to.never.throw()

				local action = creator(true)
				expect(action).to.be.a("table")
				expect(action.type).to.equal(type)
				expect(action.payload).to.equal(true)
			end
		end)
	end)

	describe("reducer", function()
		it("should be a function", function()
			expect(slice.reducer).to.be.a("function")
		end)

		it("should handle actions", function()
			local trueState =
				slice.reducer({ enabled = false }, slice.actions.debugEnabled())

			expect(trueState).to.be.a("table")
			expect(trueState.enabled).to.equal(true)

			local falseState =
				slice.reducer(trueState, slice.actions.debugDisabled())

			expect(falseState).to.be.a("table")
			expect(falseState.enabled).to.equal(false)
		end)

		it("should return initial state if state is nil", function()
			local state = slice.reducer(nil, {})
			expect(state).to.equal(initialState)
		end)

		it("should still run handlers when state is nil", function()
			local count = 0

			local counter = createSlice({
				name = "counter",
				initialState = { counted = false },
				reducers = {
					increment = function()
						count += 1
						return { counted = true }
					end,
				},
			})

			expect(count).to.equal(0)

			-- good name
			local state1 = counter.reducer(nil, counter.actions.increment())

			expect(state1).to.be.ok()
			expect(state1.counted).to.equal(true)
			expect(count).to.equal(1)

			-- great name
			local state2 = counter.reducer(nil, counter.actions.increment())

			expect(state2).to.be.ok()
			expect(state2.counted).to.equal(true)
			expect(count).to.equal(2)
		end)
	end)

	it(
		"should return the given state when there are no handlers for an action",
		function()
			local state = { foo = true }

			local newState = slice.reducer(state, { type = "bar" })

			expect(state).to.equal(newState)
		end
	)
end
