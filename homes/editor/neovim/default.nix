{
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;

    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Git Related
      vim-fugitive
      vim-rhubarb
      gitsigns-nvim

      # Detect tabstop and shiftwidth
      vim-sleuth

      # Lsp
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      fidget-nvim
      neodev-nvim

      # Autocomplete
      nvim-cmp
      luasnip
      cmp_luasnip
      cmp-nvim-lsp
      friendly-snippets

      # Theme
      catppuccin-nvim
      onedark-nvim
      lualine-nvim
      indent-blankline-nvim

      # Etc
      comment-nvim
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      # Nix
      nil
      alejandra

      # Lua
      lua-language-server
      stylua

      # C/C++
      clang
      clang-tools # for headers stuff

      # Etc
      rust-analyzer
      ripgrep
      fd
    ];
  };

  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
