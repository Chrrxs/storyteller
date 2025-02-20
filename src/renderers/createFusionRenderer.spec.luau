local Fusion2 = require("@pkg/Fusion")
local Fusion3 = require("@pkg/Fusion3")
local JestGlobals = require("@pkg/JestGlobals")

local createStory = require("@root/test-utils/createStory")
local render = require("@root/render")

local beforeEach = JestGlobals.beforeEach
local expect = JestGlobals.expect
local test = JestGlobals.test
local describe = JestGlobals.describe

local container

beforeEach(function()
	container = Instance.new("Folder")
end)

describe("Fusion 0.3.0", function()
	local scope = Fusion3:scoped()

	type StateObject<T> = Fusion3.StateObject<T>

	local function TextStory()
		return scope:New("TextLabel")({
			Text = "Hello World",
		})
	end

	local function ButtonStory(props: {
		controls: {
			isDisabled: Fusion3.StateObject<boolean>,
		},
	})
		local text = scope:Computed(function(use)
			return if use(props.controls.isDisabled) then "Disabled" else "Enabled"
		end)

		return scope:New("TextButton")({
			Text = text,
		})
	end

	local function createFusionStory(element)
		return createStory(element, {
			Fusion = Fusion3,
		})
	end

	test("render a Fusion component", function()
		local story = createFusionStory(TextStory)

		render(container, story)

		expect(#container:GetChildren()).toBe(1)
		expect(container:FindFirstChildWhichIsA("TextLabel")).toBeDefined()
	end)

	test("unmount a Fusion component", function()
		local story = createStory(TextStory)
		local lifecycle = render(container, story)

		expect(#container:GetChildren()).toBe(1)

		lifecycle.unmount()

		expect(#container:GetChildren()).toBe(0)
	end)

	test("controls are transformed into Values", function()
		local story = createFusionStory(ButtonStory)
		story.controls = {
			isDisabled = true,
		}

		render(container, story)

		local element = container:FindFirstChildWhichIsA("TextButton")
		assert(element, "no element found")
		expect(element.Text).toBe("Disabled")
	end)

	test("update the component on arg changes", function()
		expect(#container:GetChildren()).toBe(0)

		local story = createFusionStory(ButtonStory)
		story.controls = {
			isDisabled = true,
		}

		local lifecycle = render(container, story)

		expect(#container:GetChildren()).toBe(1)

		local element = container:FindFirstChildWhichIsA("TextButton")
		assert(element, "no element found")
		expect(element.Text).toBe("Disabled")

		lifecycle.update({
			isDisabled = false,
		})

		expect(#container:GetChildren()).toBe(1)

		local prevElement = element
		element = container:FindFirstChildWhichIsA("TextButton")
		expect(element).toBe(prevElement)

		task.wait()

		expect(element.Text).toBe("Enabled")
	end)
end)

describe("Fusion 0.2.0", function()
	local New = Fusion2.New
	local Computed = Fusion2.Computed
	type StateObject<T> = Fusion2.StateObject<T>

	local function TextStory()
		return New("TextLabel")({
			Text = "Hello World",
		})
	end

	local function ButtonStory(props: {
		controls: {
			isDisabled: StateObject<boolean>,
		},
	})
		return New("TextButton")({
			Text = Computed(function()
				return if props.controls.isDisabled:get() then "Disabled" else "Enabled"
			end),
		})
	end

	local function createFusionStory(element)
		return createStory(element, {
			Fusion = Fusion2,
		})
	end

	test("render a Fusion component", function()
		local story = createFusionStory(TextStory)

		render(container, story)

		expect(#container:GetChildren()).toBe(1)
		expect(container:FindFirstChildWhichIsA("TextLabel")).toBeDefined()
	end)

	test("unmount a Fusion component", function()
		local story = createStory(TextStory)
		local lifecycle = render(container, story)

		expect(#container:GetChildren()).toBe(1)

		lifecycle.unmount()

		expect(#container:GetChildren()).toBe(0)
	end)

	test("controls are transformed into Values", function()
		local story = createFusionStory(ButtonStory)
		story.controls = {
			isDisabled = true,
		}

		render(container, story)

		local element = container:FindFirstChildWhichIsA("TextButton")
		assert(element, "no element found")
		expect(element.Text).toBe("Disabled")
	end)

	test("update the component on arg changes", function()
		expect(#container:GetChildren()).toBe(0)

		local story = createFusionStory(ButtonStory)
		story.controls = {
			isDisabled = true,
		}

		local lifecycle = render(container, story)

		expect(#container:GetChildren()).toBe(1)

		local element = container:FindFirstChildWhichIsA("TextButton")
		assert(element, "no element found")
		expect(element.Text).toBe("Disabled")

		lifecycle.update({
			isDisabled = false,
		})

		expect(#container:GetChildren()).toBe(1)

		local prevElement = element
		element = container:FindFirstChildWhichIsA("TextButton")
		expect(element).toBe(prevElement)

		task.wait()

		expect(element.Text).toBe("Enabled")
	end)
end)
