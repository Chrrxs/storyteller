local Roact = require("@pkg/Roact")

type Props = {
	container: Instance,
}

return {
	story = function(props: Props)
		local root = Roact.createElement("TextLabel", {
			Text = "Hoarcekat Story",
			TextScaled = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.fromOffset(300, 100),
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 8),
			}),
		})

		local tree = Roact.mount(root, props.container)

		return function()
			Roact.unmount(tree)
		end
	end,
}
