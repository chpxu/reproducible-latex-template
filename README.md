# Reproducible LaTeX Template

Full Credits to [flyx's guide](https://flyx.org/nix-flakes-latex/)!

Having been obsessed with NixOS and its developer enjoyments, namely reproducibility. This repository aims to create a standardised environment for (my) creating LaTeX documents in Maths and Physics (or any science really). This repository assumes:

- Basic understanding of Nix
  - `stdenv.mkDerivation`, phases etc.
  - Configuring environments declaratively with Nix(OS).
- Knowledge of LaTeX
  - Compiled with LuaLaTeX
  - Uses packages such as `bookmark, hyperref, tikz, amsmath, amssymb, amsthm, esint, siunitx, mathtools, pgfplots, graphicx, float, biblatex, subfiles, tabularx `

This repository only has one purpose: to compile a given set of documents and produce an output PDF. The README also contains details on my personal setup, which also lives in my [dotfiles](https://github.com/chpxu/dotfiles). The configuration will be updated there more frequently as my needs shift (if they do).

# Development Environment Installation and Configuration

1. [Visual Studio Code](https://code.visualstudio.com) is my editor of choice to edit and compile LaTeX documents. It is very extensible and configurable, and plays nicely with the Nix ecosystem. As always, it is necessary to have extensions and settings/macros configured. These can be found under the `vscode/` directory in the repository, for your convenience.
   - LaTeX Extensions are:
     1. [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)
     2. [LTeX](https://marketplace.visualstudio.com/items?itemName=valentjn.vscode-ltex)
   - Nix Extensions are:
     1. [Nix IDE](https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide)
     2. [Alejandra](https://marketplace.visualstudio.com/items?itemName=kamadorueda.alejandra)

Following the instructions are the [NixOS Wiki](https://nixos.wiki/wiki/Visual_Studio_Code) should be easy enough. For summary and completeness, add this to your `configuration.nix`:

```nix
{
# [...]
    environment.systemPackages = with pkgs; [
        (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
                jnoortheen.nix-ide
                kamadorueda.alejandra
                james-yu.latex-workshop
                valentjn.vscode-ltex
            ];
        })
    ];
# [...]
}
```

Your `settings.json` is then stored in `~/.config/Code` and you can edit this freely assuming it isn't managed by home-manager or something else.

Or, if you wish to manage VSCode through home-manager (my setup), add this to your `home.nix`:

```nix
{
    programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            kamadorueda.alejandra
            james-yu.latex-workshop
            valentjn.vscode-ltex
        ];
        userSettings = {
            # Your settings here
            # See the `vscode/` directory for some settings
        };
    };
}
```

2. Necessary Packages to install on your system.
  - Add these to either `environment.systemPackages` or `home.nix`:
    ```
       ltex-ls
       nil
    ```
