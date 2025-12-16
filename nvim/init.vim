" =================================
" Basic Options
" =================================

set number				" Show line numbers


" Indentation / tabs

set autoindent				" Auto-indent new lines to the same level as the previous line
set tabstop=4				" Number of visual spaces per tab
set shiftwidth=4			" Number of spaces to use for eacj step of indent
set softtabstop=4			" Number of spaces a <Tab> counts for editing operations
set smarttab				" Use smart tabbing (based on syntax and indent)

" Mouse & UI behavior

set mouse=a					" Enable mouse support in all modes
set mousemoveevent			" Mouse event for bufferline hover 
set termguicolors			" Enable true color support in terminal
set signcolumn=yes			" Always show the sign column (useful for LSP, Git, etc.)

" Clipboard 

set clipboard=unnamedplus	" Use system clipboard for copy/paste


" Scroll

set scrolloff=5				" Keep 5 lines visible above and below the cursor
set sidescrolloff=5			" Keep 5 columns visible to the left/right of the cursor

" Completion & popup

set completeopt=menuone,noinsert,noselect " Configure ocotions for popup menu behavior


" =============================
" Autocommands 
" =============================


" Open file explorer if no file is passed on startup
" autocmd VimEnter * if argc() == 0 | execute 'NvimTreeOpen' | endif

" Enable omnifunc autocomplete for TypeScript and JSON
autocmd FileType typescript,json setlocal omnifunc=v:lua.vim.lsp.omnifunc


" =============================
" Plugin Manager (vim-plug)
" =============================

call plug#begin('~/.config/nvim/plugged')

" --- AI ----

Plug 'Aaronik/GPTModels.nvim'

" --- Visual ---

Plug 'eandrju/cellular-automaton.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'folke/noice.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'EdenEast/nightfox.nvim'
Plug 'projekt0n/github-nvim-theme'
Plug 'terryma/vim-smooth-scroll'
Plug 'jiangmiao/auto-pairs'							" Auto close brackets
Plug 'andymass/vim-matchup'							" Better % matching for HTML/JSX/etc.


" --- File tree & UI ---
Plug 'nvimdev/dashboard-nvim'
Plug 'mikavilpas/yazi.nvim'
" Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }		" Better buffer tabline
Plug 'MunifTanjim/nui.nvim'							" UI library for floating windows
Plug 'VonHeikemen/searchbox.nvim'					" Better search UI
Plug 'yuriescl/minimal-bookmarks.nvim'				" Minimal bookmark system

" --- Statusline / UI extras ---

Plug 'https://github.com/vim-airline/vim-airline'	" Statusline plugin
Plug 'vim-airline/vim-airline-themes'				" Themes for vim-airline


" --- Fuzzy finder / Telescope ---

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'						" Lua utility functions for plugins


" --- Syntax & highlighting & Treesitter ---

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}	" Treesitter for better syntax highlighting
Plug 'mxw/vim-jsx'									" JSX support for JavaScript
Plug 'https://github.com/ap/vim-css-color'			" Show CSS colors in code



" --- Lsp / Completion / tools ---

Plug 'neoclide/coc.nvim', { 'branch': 'release'}	" Autocompletion and intellisense
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" --- Terminal / Navigation / Misc ---

Plug 'https://github.com/tc50cal/vim-terminal'		" Better terminal integration
Plug 'https://github.com/preservim/tagbar'			" Symbol tag viewer
Plug 'nicwest/vim-http'								" HTTP request plugin
Plug 'azratul/expose-localhost.nvim'				" Expose localhost servers in terminal

" --- TailwindCSS developer tools ---

Plug 'luckasRanarison/tailwind-tools.nvim'
Plug 'roobert/tailwindcss-colorizer-cmp.nvim'


call plug#end()


colorscheme nightfox	" Set color scheme


" =================================
" Lua plugin config
" =================================



lua << EOF
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- dashboard 
-----------------------------------------------------------------------------------------


local dashboard_config = {
	theme = 'hyper',				-- theme is doom and hyper default is hyper
    disable_move = false,       -- default is false disable move keymap for hyper
	shortcut_type = 'number',   -- shortcut type 'letter' or 'number'
	shuffle_letter = false,		-- default is false, shortcut 'letter' will be randomize, set to false to have ordered letter
	-- letter_list				-- default is a-z, excluding j and k
	-- change_to_vcs_root		-- default is false,for open file in hyper mru. it will change to the root of vcs
	config = {},				-- config used for theme
	hide = {
		statusline = false,     -- hide statusline default is true
		tabline = false,        -- hide the tabline
		winbar = false,         -- hide winbar
			},
	-- preview = {
		--  command				-- preview command
		--  file_path			-- preview file path
		--  file_height			-- preview file height
		--  file_width			-- preview file width
			--},
	} 

require("dashboard").setup(dashboard_config) 




-----------------------------------------------------------------------------------------
-- to-do comments
-----------------------------------------------------------------------------------------

require("todo-comments").setup() 

-----------------------------------------------------------------------------------------
-- yazi 
-----------------------------------------------------------------------------------------


local yazi_config = {} 

require("yazi").setup(yazi_config) 



-----------------------------------------------------------------------------------------
-- notify & noice 
-----------------------------------------------------------------------------------------


local notify_config =  { background_colour = "#000000",}

local noice_config =  {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
}

require("notify").setup(notify_config)

require("noice").setup(noice_config)



-----------------------------------------------------------------------------------------
-- Tailwind color boxes in autocompletion 
-----------------------------------------------------------------------------------------

local tailwind_colorizer_conf = { color_square_width = 2, } 

require("tailwindcss-colorizer-cmp").setup(tailwind_colorizer_conf)


-----------------------------------------------------------------------------------------
-- Mason ( Lsp / installer ) 
-----------------------------------------------------------------------------------------

local mason_lspconfig = {
  ensure_installed = { "tailwindcss","pyright", "vimls", "cssls", "ts_ls", "html", "jsonls", "lua_ls", "shopify_theme_ls"},
  automatic_installation = true,
}

require("mason").setup()

require("mason-lspconfig").setup()



-----------------------------------------------------------------------------------------
-- Telescope 
-----------------------------------------------------------------------------------------

local telescope_config = {
  defaults = {
    path_display = { "smart" },
    prompt_prefix = "🔍 ",
    selection_caret = "→ ",
    layout_config = {
      horizontal = { width = 0.8 },
      vertical = { height = 0.9 },
    },
  },
  pickers = {
    lsp_definitions = { path_display = { "relative" } },
    lsp_references = { path_display = { "relative" } },
    lsp_implementations = { path_display = { "relative" } },
    lsp_type_definitions = { path_display = { "relative" } },
  },
}


require('telescope').setup(telescop_config)

-----------------------------------------------------------------------------------------
-- Bufferline (tabs/buffers) 
-----------------------------------------------------------------------------------------

local bufferline_config =  {
  options = {
	  hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
        },

    mode = "buffers", -- or "tabs" 
    diagnostics = "coc", -- enable coc.nvim diagnostics
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = (e == "error" and " ")
          or (e == "warning" and " " or " " )
        s = s .. n .. sym
      end
      return s
    end,
    show_buffer_close_icons = true,
    show_close_icon = true,
    separator_style = "slope", -- same as style_preset, redundant here
  },
}

require("bufferline").setup(bufferline_config)


-----------------------------------------------------------------------------------------
-- Nvim-tree (file explorer) 
-----------------------------------------------------------------------------------------

local nvimtree_config = {
  sort_by = "case_sensitive",
  view = {
    width = 40,
    side = "left",
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
	icons = {
      webdev_colors = true,
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
	  },
  },
  filters = {
    dotfiles = true,
	custom = { 'node_modules' }, 
	exclude = {'.env', '.gitignore'}
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = true,
    },
  },
  modified = {
    enable = true,
    show_on_dirs = true,
  },
}

-- require("nvim-tree").setup(nvimtree_config)

-----------------------------------------------------------------------------------------
-- Treesitter 
-----------------------------------------------------------------------------------------

local treesitter_config = {
  ensure_installed = { "javascript", "typescript", "vim" },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  additional_vim_regex_highlighting = false,
}

require'nvim-treesitter.configs'.setup(treesitter_config) 

-----------------------------------------------------------------------------------------
-- LSP server setup (new) 
-----------------------------------------------------------------------------------------

vim.lsp.enable('tailwindcss')
vim.lsp.enable('shopify_theme_ls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('vimls')
vim.lsp.enable('cssls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('html')
vim.lsp.enable('jsonls')

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('jsonls', {
    capabilities = capabilities,
  })




-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------


EOF


" =================================
" Keybindings 
" =================================



" Rename word under cursor 
" =================================

nnoremap <silent> rn ciw


" Rename same words in buffer 
" =================================

nnoremap <silent> ra :%s/\<<C-r><C-w>\>//g<Left><Left>


" GPT Models
" =================================

nnoremap <silent>gm :GPTModelsChat<CR>
vnoremap <silent>gm :GPTModelsChat<CR>


" Bufferline mappings
" =================================

nnoremap <silent> <S-Tab> :BufferLineCyclePrev<CR>
nnoremap <silent> <Tab> :BufferLineCycleNext<CR>
nnoremap <silent> bd :bd<CR>

" Terminal: Escape to normal mode
" =================================

tnoremap <silent><Esc> <C-\><C-n>

" Open file in new tab from tree
" =================================

nnoremap t :lua require'nvim-tree.api'.node.open.tab()<CR>

" MinimalBookmarks plugin mappings
" =================================

nnoremap <silent>bb :MinimalBookmarksToggle<CR>
nnoremap <silent>ba :MinimalBookmarksAdd<CR>
nnoremap <silent>br :MinimalBookmarksEdit<CR>

" Move between windows
" =================================

nnoremap <silent><C-a> <C-w>h
nnoremap <silent><C-d> <C-w>l

" Faster vertical movement
" =================================

nnoremap <silent><S-Up> 5k
nnoremap <silent><S-Down> 5j

" Quickfix list navigation
" =================================

nnoremap <silent> g<Left> :cp<CR>
nnoremap <silent> g<Right> :cn<CR>

" Telescope mappings
" =================================

nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap <silent>gr <cmd>Telescope lsp_references<cr>
nnoremap <silent>gD <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Yazi 
" =================================

nnoremap <C-n> :Yazi<CR>

" NvimTree toggles
" =================================

" nnoremap <C-n> :NvimTreeToggle<CR>
" nnoremap <silent><C-e> :NvimTreeFocus<CR>

" SearchBox
" =================================

nnoremap <silent> / :SearchBoxMatchAll clear_matches=false<CR>

" COC plugin mappings
" =================================

nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> Ra <Plug>(coc-rename)
nmap <silent> re <Plug>(coc-codeaction-refactor)

" =================================
" Coc configuration 
" =================================


" COC Tab completion
" =================================

inoremap <silent><expr> <TAB>
			\ coc#pum#visible() ? coc#pum#next(1) :
			\ CheckBackspace() ? "\<Tab>" :
			\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


" Enter to confirm completion or insert newline
" =================================

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use Ctrl+Space to trigger completion
" =================================

if has('nvim')
	inoremap <silent><expr> <c-space> coc#refresh()
else
	inoremap <silent><expr> <c-@> coc#refresh()
endif



" =================================
" Misc Settings / Globals 
" =================================



" Use Python 3 host
" =================================

let g:python3_host_prog = '/usr/bin/python3'

let g:airline_theme= 'dark'

let g:matchup_matchparen_nomode = 'i'

let g:matchup_matchparen_deferred = 1


" Helper function for Tab handling in COC
" =================================

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction



