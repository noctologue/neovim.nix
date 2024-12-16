{
  lib,
  wrapNeovim,
  neovim-unwrapped,
  vimPlugins,
  lua-language-server,
  nixd,
  gopls,
  clang-tools
}:

let
  dependencies = [
    lua-language-server
    nixd

    gopls

    clang-tools
  ];

  treesitterGrammars = with vimPlugins.nvim-treesitter.builtGrammars; [
    bash
    c
    cpp
    css
    dockerfile
    go
    html
    javascript
    json
    lua
    markdown
    nix
    python
    query
    regex
    rust
    toml
    tsx
    typescript
    vim
    yaml
  ];
in
wrapNeovim neovim-unwrapped {
  viAlias = true;
  vimAlias = true;
  configure = {
    customRC = ''
      lua << EOF
      vim.opt.runtimepath:append(os.getenv("HOME") .. "/.config/nvim")

      -- Chargement de init.lua s'il existe
      local initlua = os.getenv("HOME") .. "/.config/nvim/init.lua"
      if vim.fn.filereadable(initlua) == 1 then
        dofile(initlua)
      end
      EOF
    '';
    packages.myVimPackage = {
      start =
        with vimPlugins;
        [
          nvim-treesitter
          nvim-treesitter-textobjects
          nvim-treesitter-refactor
          nvim-treesitter-context

          telescope-nvim

          nvim-lspconfig
          cmp-nvim-lsp
          nvim-cmp
          cmp-buffer
          cmp-path
          luasnip
          cmp_luasnip
        ]
        ++ treesitterGrammars;
    };
  };
  extraMakeWrapperArgs = ''--prefix PATH : "${lib.makeBinPath dependencies}"'';
}
