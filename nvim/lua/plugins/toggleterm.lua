return
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      direction = "float",
      open_mapping = [[<c-\>]],
    },
    config = function ()
      require("toggleterm").setup{
        open_mapping = [[<c-\>]],
        shade_filetypes = {},
        start_in_insert = true,
        auto_scroll = true,
      }
    end
}
