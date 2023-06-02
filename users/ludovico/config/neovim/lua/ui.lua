-- Telescope
require("telescope").setup()

-- Gitsigns
require('gitsigns').setup()

-- Neogit
require('neogit').setup()

-- Bufferline
require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    mode = "buffers",
    separator_style = "thin",
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
})

-- Indent Blankline
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
require("indent_blankline").setup({
  use_treesitter = true,
  show_current_context = true,
  show_current_context_start = true,
  space_char_blankline = " ",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },
})

-- Dashboard
local db = require("dashboard")
db.custom_header = {
  "",
  "⣽⣿⢣⣿⡟⣽⣿⣿⠃⣲⣿⣿⣸⣷⡻⡇⣿⣿⢇⣿⣿⣿⣏⣎⣸⣦⣠⡞⣾⢧⣿⣿",
  "⣿⡏⣿⡿⢰⣿⣿⡏⣼⣿⣿⡏⠙⣿⣿⣤⡿⣿⢸⣿⣿⢟⡞⣰⣿⣿⡟⣹⢯⣿⣿⣿",
  "⡿⢹⣿⠇⣿⣿⣿⣸⣿⣿⣿⣿⣦⡈⠻⣿⣿⣮⣿⣿⣯⣏⣼⣿⠿⠏⣰⡅⢸⣿⣿⣿",
  "⡀⣼⣿⢰⣿⣿⣇⣿⣿⡿⠛⠛⠛⠛⠄⣘⣿⣿⣿⣿⣿⣿⣶⣿⠿⠛⢾⡇⢸⣿⣿⣿",
  "⠄⣿⡟⢸⣿⣿⢻⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡋⠉⣠⣴⣾⣿⡇⣸⣿⣿⡏",
  "⠄⣿⡇⢸⣿⣿⢸⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠘⢿⣿⠏⠄⣿⣿⣿⣹",
  "⠄⢻⡇⢸⣿⣿⠸⣿⣿⣿⣿⣿⣿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣦⣼⠃⠄⢰⣿⣿⢯⣿",
  "⠄⢸⣿⢸⣿⣿⡄⠙⢿⣿⣿⡿⠁⠄⠄⠄⠄⠉⣿⣿⣿⣿⣿⣿⡏⠄⢀⣾⣿⢯⣿⣿",
  "⣾⣸⣿⠄⣿⣿⡇⠄⠄⠙⢿⣀⠄⠄⠄⠄⠄⣰⣿⣿⣿⣿⣿⠟⠄⠄⣼⡿⢫⣻⣿⣿",
  "⣿⣿⣿⠄⢸⣿⣿⠄⠄⠄⠄⠙⠿⣷⣶⣤⣴⣿⠿⠿⠛⠉⠄⠄⢸⣿⣿⣿⣿⠃⠄⣴ ",
  "",
}
db.custom_center = {
  {
    icon = "  ",
    desc = "Recently latest session                  ",
    shortcut = "SPC s l",
    action = "SessionLoad",
  },
  {
    icon = "  ",
    desc = "Recently opened files                   ",
    action = "DashboardFindHistory",
    shortcut = "SPC f h",
  },
  {
    icon = "  ",
    desc = "Find  File                              ",
    action = "Telescope find_files find_command=rg,--hidden,--files",
    shortcut = "SPC f f",
  },
  {
    icon = "  ",
    desc = "File Browser                            ",
    action = "Telescope file_browser",
    shortcut = "SPC f b",
  },
  {
    icon = "  ",
    desc = "Find  word                              ",
    action = "Telescope live_grep",
    shortcut = "SPC f w",
  },
}
db.custom_footer = {
  "Ludovico Sforza 🚀",
  "SFORZA FAMIGLIA",
}

-- Lualine
local lualine = require("lualine")
lualine.setup({
  options = {
    icons_enabled = true,
    theme = "palenight",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { 'nvim-tree' },
})

-- Nvim-Treesitter
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
  },
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
})

require("nvim-tree").setup({})

-- Presence ( Discord Rich Presence )
-- require("presence"):setup(
-- 	{
-- 		-- General options
-- 		auto_update = true,
-- 		neovim_image_text = "The One True Text Editor",
-- 		main_image = "neovim",
-- 		client_id = "793271441293967371",
-- 		log_level = nil,
-- 		debounce_timeout = 10,
-- 		enable_line_number = false,
-- 		blacklist = {},
-- 		buttons = true,
-- 		file_assets = {},
-- 		show_time = true,
-- 		-- Rich Presence text options
-- 		editing_text = "Editing %s",
-- 		file_explorer_text = "Browsing %s",
-- 		git_commit_text = "Committing changes",
-- 		plugin_manager_text = "Managing plugins",
-- 		reading_text = "Reading %s",
-- 		workspace_text = "Working on %s",
-- 		line_number_text = "Line %s out of %s"
-- 	}
-- )

-- Nvim-Web-DevIcons
require("nvim-web-devicons").setup({
  color_icons = true,
  default = true,
})
