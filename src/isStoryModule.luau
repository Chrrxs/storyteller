local canAccess = require("@root/roblox-internal/canAccess")
local constants = require("@root/constants")

--[=[
	Validates a given [Instance] is a Story.

	No validation is performed on the internals of the module. Only name and class are checked.

	See [Storyteller.loadStoryModule] for validation of the module source.

	@tag Validation
	@tag Story
	@within Storyteller
	@since 0.1.0
]=]
local function isStoryModule(instance: Instance): boolean
	return canAccess(instance)
		and instance:IsA("ModuleScript")
		and instance.Name:match(constants.STORY_NAME_PATTERN) ~= nil
end

return isStoryModule
