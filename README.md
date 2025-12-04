# nvim-verilog-mode
Neovim plugin to invoke Emacs's verilog-mode for Verilog/SystemVerilog

```lua
return {
  "Junknown99/nvim-verilog-mode",
  ft = { "verilog", "systemverilog" },
  config = function ()
    require("nvim-verilog-mode").setup() 
  end
}
```
