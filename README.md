# Reproducible LaTeX Template

Full Credits to [flyx's guide](https://flyx.org/nix-flakes-latex/)!

Having been obsessed with NixOS and its developer enjoyments, namely reproducibility. This repository aims to create an opinionated, standardised environment for (my) creating LaTeX documents in Maths and Physics (or any science really), as well as providing a helper shell script to automate actions (mostly subfile related) commonly taken. This repository assumes:

- Basic understanding of Nix
  - `stdenv.mkDerivation`, phases if you want to do elaborate modification of `flake.nix` etc.
  - Configuring environments declaratively with Nix(OS).
  - How TeXLive is structured in Nixpkgs (It isn't the clearest. In the nixpkgs repo, look in `pkgs/tools/typesetting/tex/texlive`)
- Knowledge of LaTeX
  - Compiled with LuaLaTeX
  - Uses packages such as `bookmark, hyperref, tikz, amsmath, amssymb, amsthm, esint, siunitx, mathtools, pgfplots, graphicx, float, biblatex, subfiles, tabularx`
- Shell Scripting, if you wish to modify `rlt.sh`

This repository only has one purpose: to compile a given set of TeX files and produce an output PDF. The README also contains details on my personal setup, which also lives in my [dotfiles](https://github.com/chpxu/dotfiles). The configuration will be updated there more frequently as my needs shift (if they do).

## Using `rlt.sh`

First, give it executable permissions (this file should only ever need to operate in your LaTeX project directory. If it doesn't, something's up, and reporting an issue would be appreciated). Then it's as simple as running in your terminal: `./rlt.sh <args>`

```sh
./rlt.sh new subfile <name>
./rlt.sh rm <name>
./rlt.sh build
```

1. `new` is a command to generate a new TeX file according to the skeleton files in `./skel`. It accepts the following arguments:
   - `subfile <name>` will produce a new folder in `./src` with the name `(current number of folders + 1)-<name>` with the file structure of `./skel/subfile`.
     - The script automatically renames the `subfile.tex` to `<name>.tex`.
     - The script also automatically appends a `\subfile{{/path/to/subfile}}` in the main `./src/document.tex`.
     - The script checks the `<name>` is alphanumeric.
2. `rm` is a command to remove a subfile from `src`
   - `rm <name>` will delete the folder named `<name>` by first matching it to a regex (WIP) before **permanently deleting it.**
     - It will also remove the appropriate subfile command from `document.tex` (WIP)
3. `build` will attempt to compile the document
   - Note: if you have nix installed, run `nix develop` and then `nix build` in the root directory of repo to get an output
   - Does a dirty check to see if nix is installed to run the flake, otherwise runs `latexmk` directly.

## Roadmap

Since this is a template, the actual LaTeX/flake should never really need to change. Issues may arise if you are not using nix, in which case you will probably have a different/changing TeXLive version (or maybe a different TeX distribution altogether!) in which case reproducibility may not be guaranteed. It should, however, be idempotent for the same version of TeX you are using to compile the project with.

- Ensure the flake is updated with common Maths/Physics packages
- Explore a less destructive `/src` directory. Perhaps a `edit/` folder of some sorts?
- Update repo with brief examples of the packages used

### `rlt`

- Maybe this should become a separate utility?
- [ ] Add more checks for `rm` to reduce unsafe deletes
- [ ] Explore management of some document/compiler options through the shell script

# (Personal) Development Environment Installation and Configuration

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
        # See vscode/settings.nix for my personal setup. Modify to your choosing and add to your VSCode configuration!
        userSettings = (import ./vscode/settings.nix).settings;
    };
}
```

2. Necessary Packages to install on your system.

- Add these to either `environment.systemPackages` or `home.nix`:

  ```
     ltex-ls
     nil
  ```

## Inside `vscode/`

The `vscode` folder contains (as of time of writing, 2 files:

1. `NT.code-snippets` is a set of 2 snippets used to scaffold a root LaTeX document and a subfile. These are generic and can be filled in manually.
2. `settings.nix` is a nix file containing a set called `settings`, using my settings for a LaTeX project
