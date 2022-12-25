{
  settings = {
    "window.titleBarStyle" = "custom";
    "latex-workshop.latex.recipes" = [
      {
        "name" = "lualatex ➞ biber ➞ lualatex × 2";
        "tools" = ["lualatex" "lualatex"];
      }
    ];
    "latex-workshop.latex.tools" = [
      {
        "name" = "lualatex";
        "command" = "lualatex";
        "args" = [
          "-synctex=1"
          "-interaction=nonstopmode"
          "-file-line-error"
          "-output-format=pdf"
          "-output-directory=%OUTDIR%"
          "%DOC%"
        ];
      }
      {
        "name" = "biber";
        "command" = "biber";
        "args" = [
          "%DOCFILE%"
        ];
      }
    ];
    "latex-workshop.view.pdf.viewer" = "tab";
    "latex-workshop.view.pdf.external.viewer.command" = "zathura";
    "latex-workshop.view.pdf.external.viewer.args" = [
      "--synctex-editor-command"
      "code --no-sandbox --reuse-window -g \"%{input}:%{line}\""
      "%PDF%"
    ];
    "latex-workshop.view.pdf.external.synctex.command" = "zathura";
    "latex-workshop.view.pdf.external.synctex.args" = [
      "--synctex-forward=%LINE:0:%TEX%"
      "%PDF%"
    ];
    "latex-workshop.latex.rootFile.doNotPrompt" = true;
    "latex-workshop.latex.autoBuild.run" = "never";
    "latex-workshop.intellisense.citation.backend" = "biblatex";
    "latex-workshop.hover.preview.enabled" = true;
    "latex-workshop.hover.preview.mathjax.extensions" = [
      "amscd"
      "bbox"
      "boldsymbol"
      "braket"
      "cases"
      "colortbl"
      "mathtools"
      "physics"
      "unicode"
      "upgreek"
    ];
    "latex-workshop.linting.chktex.enabled" = true;
    "latex-workshop.linting.chktex.exec.args" = [
      "-wall"
      "-n22"
      "-n21"
      "-n30"
      "-e16"
      "-q"
    ];
    "latex-workshop.linting.lacheck.enabled" = true;
    "[nix]" = {
      "editor.defaultFormatter" = "kamadorueda.alejandra";
    };
    "[latex]" = {
      "editor.defaultFormatter" = "James-Yu.latex-workshop";
    };
    "ltex.enabled" = true;
    "ltex.language" = "en-GB";
    "ltex.dictionary" = {
      "en" = [
        "monic"
        "infimum"
        "supremum"
        "bolzano"
        "weierstrass"
        "euler"
      ];
    };
    "ltex.statusBarItem" = true;
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
  };
}
