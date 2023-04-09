return function()
	local singleton = require(script.Parent.Singleton)

	local function get(cache: any, key: any): any?
		if cache._entry ~= nil and cache._entry.key == key then
			return cache._entry.value
		end

		return nil
	end

	local function equals(a, b)
		return a == b
	end

	describe("put", function()
		it("should store any type of value with any type of key", function()
			local cache = singleton.new(equals)

			local t = {}

			cache:put(t, "bar")
			expect(get(cache, t)).to.equal("bar")

			cache:put(1, t)
			expect(get(cache, 1)).to.equal(t)

			cache:put("string", true)
			expect(get(cache, "string")).to.equal(true)
		end)
	end)

	describe("get", function()
		it("should return the value for the given key if it exists", function()
			local cache = singleton.new(equals)

			cache._entry = {
				key = "foo",
				value = "bar",
			}

			expect(cache:get("foo")).to.equal("bar")
		end)
	end)

	describe("getEntries", function()
		it("should return all entries", function()
			local cache = singleton.new(equals)

			cache._entry = {
				key = "foo",
				value = "bar",
			}

			local entry = cache:getEntries()

			expect(entry[1].key).to.equal("foo")
			expect(entry[1].value).to.equal("bar")
		end)
	end)

	describe("clear", function()
		it("should clear all entries", function()
			local cache = singleton.new(equals)

			cache._entry = {
				key = "foo",
				value = "bar",
			}

			cache:clear()

			expect(get(cache, "foo")).to.never.be.ok()
		end)
	end)
end
