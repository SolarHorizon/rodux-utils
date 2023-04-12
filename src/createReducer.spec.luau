return function()
	local createReducer = require(script.Parent.createReducer)

	local actions = {
		enabled = { type = "enabled" },
		disabled = { type = "disabled" },
		shouldMatch = { type = "shouldMatch", shouldMatch = true },
		shouldNotMatch = { type = "shouldNotMatch", shouldMatch = false },
	}

	local initialState = { debug = false }

	local reducers = {
		Builder = createReducer(initialState, function(builder)
			builder
				:addCase("enabled", function(state, _action)
					state.debug = true
				end)
				:addCase("disabled", function(state, _action)
					state.debug = false
				end)
				:addMatcher(function(action)
					return action.shouldMatch
				end, function(state, _action)
					state.matched = true
				end)
				:addDefaultCase(function(state, _action)
					state.default = true
				end)
		end),
		Map = createReducer(initialState, {
			enabled = function(state: any, _action)
				state.debug = true
			end,
			disabled = function(state: any, _action)
				state.debug = false
			end,
		}, {
			{
				matcher = function(action)
					return action.shouldMatch
				end,
				reducer = function(state: any, _action)
					state.matched = true
				end,
			},
		}, function(state: any, _action)
			state.default = true
		end),
	}

	for name, reducer in reducers :: any do
		describe(`{name} reducer`, function()
			it("should be a function", function()
				expect(reducer).to.be.a("function")
			end)

			it("should not mutate the old state", function()
				local oldState = { debug = false }
				local newState = reducer(oldState, actions.enabled)

				expect(oldState).to.never.equal(newState)
			end)

			it("should create a new state", function()
				local newState = reducer({ debug = false }, actions.enabled)

				expect(newState).to.be.a("table")
				expect(newState.debug).to.equal(true)
			end)
		end)
	end
end
