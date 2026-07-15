return {
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.background = "dark"
			vim.cmd.colorscheme("oxocarbon")

			vim.keymap.set("n", "<leader>ut", function()
				vim.o.background = vim.o.background == "dark" and "light" or "dark"
				vim.cmd.colorscheme("oxocarbon")
			end, { desc = "Toggle light/dark theme" })
		end,
	},
}
