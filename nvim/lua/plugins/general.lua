return {
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	{ "folke/which-key.nvim", opts = {} },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			vim.keymap.set("n", "<leader>h", function()
				harpoon:list():append()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-t>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-n>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-s>", function()
				harpoon:list():select(4)
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end)

			-- basic telescope configuration
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			vim.keymap.set("n", "<C-e>", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Open harpoon window" })
		end,
	},
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"meuter/lualine-so-fancy.nvim",
		},
		config = function()
			local function diff_source()
				--@ignore
				local gitsigns = vim.b.gitsigns_status_dict
				if gitsigns then
					return {
						added = gitsigns.added,
						modified = gitsigns.changed,
						removed = gitsigns.removed,
					}
				end
			end

			local custom_catppuccin = require("lualine.themes.catppuccin")

			custom_catppuccin.inactive.c.bg = "#1e1e2e"
			custom_catppuccin.normal.c.bg = "#1e1e2e"

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = custom_catppuccin,
					component_separators = { left = "", right = "" }, -- Box-like separators for inner sections
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" }, -- Displays Neovim's mode
					lualine_b = { "fancy_lsp_servers" }, -- Current file name
					lualine_c = { { "b:gitsigns_head", icon = "" }, { "diff", source = diff_source } }, -- , 'diff' }, -- Shows git branch and diff
					lualine_x = { "diagnostics" }, -- Diagnostics (e.g., LSP)
					lualine_y = { "progress" }, -- Progress through the current file
					lualine_z = { "filename" },
				},
				inactive_sections = {},
				tabline = {},
				extensions = { "quickfix", "fugitive" },
			})
		end,
	},
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"NvChad/nvterm",
		config = function()
			require("nvterm").setup()
			vim.keymap.set({ "n", "t" }, "<C-i>", function()
				require("nvterm.terminal").toggle("float")
			end)
		end,
	},
}
