local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

local function union(a, b)
	local result = {}
	for _, v in pairs(a) do
		table.insert(result, v)
	end
	for _, v in pairs(b) do
		table.insert(result, v)
	end
	return result
end

local servers = {
	"bashls",
	--[[ "cssls", ]]
	"stylelint_lsp",
	"dockerls",
	"eslint",
	"gopls",
	"graphql",
	"html",
	--[[ "jsonls", ]]
	"pyright",
	"rust_analyzer",
	"lua_ls",
	"tailwindcss",
	"terraformls",
	"tsserver",
	"yamlls",
}

--[[ local ensure_installed = union(servers, formatters) ]]
local ensure_installed = servers

mason_lspconfig.setup({
	ensure_installed = ensure_installed,
})

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	if server == "lua_ls" then
		local lua_ls_opts = require("user.lsp.settings.lua_ls")
		opts = vim.tbl_deep_extend("force", lua_ls_opts, opts)
	end

	if server == "rust_analyzer" then
		local rust_analyzer_opts = require("user.lsp.settings.rust_analyzer")
		opts = vim.tbl_deep_extend("force", rust_analyzer_opts, opts)
	end

	if server == "gopls" then
		local gopls_opts = require("user.lsp.settings.gopls")
		opts = vim.tbl_deep_extend("force", gopls_opts, opts)
	end

	if server == "pyright" then
		local pyright_opts = require("user.lsp.settings.pyright")
		opts = vim.tbl_deep_extend("force", pyright_opts, opts)
	end

	lspconfig[server].setup(opts)
end
