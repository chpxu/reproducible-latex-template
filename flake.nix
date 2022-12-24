{
  description = "A flake to produce LaTeX documents";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    with flake-utils.lib;
      eachSystem allSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-basic latex-bin latexmk bookmark tikz latex-amsmath-dev amslatex-primer braket esint hyperref siunitx mathtools pgfplots latex-graphics-dev float biblatex subfiles latex-tools-dev;
        };
      in rec {
        packages = {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "LaTeX Notes Template";
            src = ./src;
            buildInputs = [pkgs.coreutils tex];
            phases = ["unpackPhase" "buildPhase" "installPhase"];
            buildPhase = ''
                         export PATH="${pkgs.lib.makeBinPath buildInputs}";
                         mkdir -p .cache/texmf-var
                         env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              SOURCE_DATE_EPOCH=${toString self.lastModified} \
              latexmk -interaction=nonstopmode -pdf -lualatex \
              document.tex
            '';
            installPhase = ''
              mkdir -p $out
              cp document.pdf $out/
            '';
          };
        };
        defaultPackage = packages.document;
      });
}
