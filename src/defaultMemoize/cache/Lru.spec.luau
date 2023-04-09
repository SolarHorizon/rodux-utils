return function()
	local lru = require(script.Parent.Lru)

	local function get(cache: any, key: any): any?
		for _, cacheEntry in cache._entries do
			if cacheEntry.key == key then
				return cacheEntry.value
			end
		end

		return
	end

	local function equals(a, b)
		return a == b
	end

	describe("put", function()
		it("should store any type of value with any type of key", function()
			local cache = lru.new(3, equals)

			local t = {}

			cache:put(t, "bar")
			expect(get(cache, t)).to.equal("bar")

			cache:put(1, t)
			expect(get(cache, 1)).to.equal(t)

			cache:put("string", true)
			expect(get(cache, "string")).to.equal(true)
		end)

		it("should clear the least recently used value", function()
			local cache = lru.new(3, equals)

			cache:put(1, "A")
			cache:put(2, "B")
			cache:put(3, "C")

			expect(get(cache, 1)).to.equal("A")
			expect(get(cache, 2)).to.equal("B")
			expect(get(cache, 3)).to.equal("C")

			cache:put(4, "D")

			expect(get(cache, 4)).to.equal("D")
			expect(get(cache, 1)).to.never.be.ok()
		end)
	end)

	describe("get", function()
		it("should return the value for the given key if it exists", function()
			local cache = lru.new(3, equals)

			cache._entries = {
				{ key = "foo", value = "bar" },
				{ key = "bar", value = "baz" },
				{ key = "baz", value = "qux" },
			}

			expect(cache:get("foo")).to.equal("bar")
			expect(cache:get("bar")).to.equal("baz")
			expect(cache:get("baz")).to.equal("qux")
		end)
	end)

	describe("getEntries", function()
		it("should return all entries", function()
			local cache = lru.new(3, equals)

			cache._entries = {
				{ key = "foo", value = "bar" },
				{ key = "bar", value = "baz" },
				{ key = "baz", value = "qux" },
			}

			local entry = cache:getEntries()

			expect(entry[1].key).to.equal("foo")
			expect(entry[1].value).to.equal("bar")
			expect(entry[2].key).to.equal("bar")
			expect(entry[2].value).to.equal("baz")
			expect(entry[3].key).to.equal("baz")
			expect(entry[3].value).to.equal("qux")
		end)
	end)

	describe("clear", function()
		it("should clear all entries", function()
			local cache = lru.new(3, equals)

			cache._entries = {
				{ key = "foo", value = "bar" },
				{ key = "bar", value = "baz" },
				{ key = "baz", value = "qux" },
			}

			cache:clear()

			expect(get(cache, "foo")).to.never.be.ok()
			expect(get(cache, "bar")).to.never.be.ok()
			expect(get(cache, "baz")).to.never.be.ok()
		end)
	end)
end
