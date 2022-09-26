local keybindings = require("keybindings")
local go_nvim = require("go")
local path = require("nvim-lsp-installer.core.path")
local install_root_dir = path.concat({ vim.fn.stdpath("data"), "lsp_servers" })
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local opts = {
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),

	on_attach = function(client, bufnr)
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		-- 绑定快捷键
		keybindings.mapLSP(buf_set_keymap)
		go_nvim.setup({
			gopls_cmd = { install_root_dir .. "/go/gopls" },
			fillstruct = "gopls",
			dap_debug = true,
			dap_debug_gui = true,
			lsp_cfg = {
				capabilities = capabilities,
				-- other setups
			},
		})
	end,
}

return {
	on_setup = function(server)
		server.setup(opts)
	end,
}
