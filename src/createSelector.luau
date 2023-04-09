local defaultMemoize = require(script.Parent.defaultMemoize)
local createSelectorCreator = require(script.Parent.createSelectorCreator)

local createSelector = createSelectorCreator(defaultMemoize)

return createSelector
