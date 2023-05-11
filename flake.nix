{
  description = "TODO";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    flake-utils.url = github:numtide/flake-utils;

    flake-compat.url = github:edolstra/flake-compat;
    flake-compat.flake = false;

    nix-filter.url = github:numtide/nix-filter;

    poetry2nix.url = github:nix-community/poetry2nix;
    poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
    poetry2nix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [
            inputs.poetry2nix.overlay
          ];
          pkgs = import inputs.nixpkgs {
            inherit system overlays;
          };
        in
        rec {
          packages = rec {};
          apps = rec {};
          devShells = rec {
            default = pkgs.mkShell {
              buildInputs = [ ];
              packages = [
                pkgs.python311Full
                ## other tools
                pkgs.black
                pkgs.ruff
                pkgs.just
                pkgs.rnix-lsp
                pkgs.nixpkgs-fmt
              ];

              shellHook = ''
                # The path to this repository
                if [ -z $WORKSPACE_ROOT ]; then
                  shell_nix=" ''${IN_LORRI_SHELL:-$(pwd)/shell.nix}"
                  workspace_root=$(dirname "$shell_nix")
                  export WORKSPACE_ROOT="$workspace_root"
                fi
                export TOOLCHAIN_ROOT="$WORKSPACE_ROOT/.toolchain"
              '';
            };
          };
        }
      );
}
