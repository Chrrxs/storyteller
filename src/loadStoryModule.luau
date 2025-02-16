local Sift = require("@pkg/Sift")

local constants = require("@root/constants")
local migrateLegacyPackages = require("@root/migrateLegacyPackages")
local types = require("@root/types")

type StoryPackages = types.StoryPackages
type LoadedStorybook = types.LoadedStorybook
type LoadedStory<T> = types.LoadedStory<T>

--[=[
	Loads the source of a Story module.

	A [ModuleLoader](https://github.com/flipbook-labs/module-loader) instance
	is required for handling the requiring of the module.

	This function will throw if the return value of `storyModule` does not
	conform to the [Story format](/docs/story-format#story), or if the source
	has a syntax error that `require` would normally fail for.

	For legacy compatibility this function also loads [Hoarcekat](https://github.com/Kampfkarren/hoarcekat)
	stories. Instead of a usual table-based Story definition, it takes the
	returned function and  wraps it in a Story, making the `story` field the
	function body.

	@tag Story
	@tag Module Loading
	@within Storyteller
]=]
local function loadStoryModule<T>(storyModule: ModuleScript, storybook: LoadedStorybook): LoadedStory<T>
	local success, result = pcall(function()
		return storybook.loader:require(storyModule)
	end)

	if not success then
		error(`Failed to load story {storyModule:GetFullName()}. Error: {result})`)
	end

	local isLegacyStory = typeof(result) == "function"

	-- Support for Hoarcekat stories
	if isLegacyStory then
		local callback = result
		result = {
			story = function(props)
				return callback(props.container, props)
			end,
		}
	end

	local isValid, message = types.IStory(result)

	if not isValid then
		error(
			`Story is malformed. Check the source of {storyModule:GetFullName()} and make sure its properties are `
				.. `correct. Error: {message}`
		)
	end

	local story: types.Story<T> = result

	local packages = migrateLegacyPackages(story)
	if not packages then
		packages = storybook.packages
	end

	local loadedStory: types.LoadedStory<T> = {
		name = storyModule.Name:gsub(constants.STORY_NAME_PATTERN, ""),
		storybook = storybook,
		source = storyModule,
		story = story.story,
		packages = if isLegacyStory then {} else packages,
	}

	return Sift.Dictionary.merge(loadedStory, story)
end

return loadStoryModule
