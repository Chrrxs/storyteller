type Props = {
	container: Instance,
}

return {
	story = function(props: Props)
		local label = Instance.new("TextButton")
		label.Text = "Hello World"
		label.Parent = props.container

		return function()
			label:Destroy()
		end
	end,
}
