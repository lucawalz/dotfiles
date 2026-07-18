return {
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = { terminal_colors = true },
			})
			vim.opt.background = "dark"
			vim.cmd.colorscheme("carbonfox")

			vim.keymap.set("n", "<leader>ut", function()
				vim.o.background = vim.o.background == "dark" and "light" or "dark"
				vim.cmd.colorscheme(vim.o.background == "dark" and "carbonfox" or "dayfox")
			end, { desc = "Toggle light/dark theme" })
		end,
	},
}
