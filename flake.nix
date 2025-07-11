{
  description = "craft-preprocess";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pname = "craft-preprocess";
        version = "0.0.1";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = false;
        };
      in {
        packages.default = pkgs.buildGoModule {
          inherit pname version;
          src = ./.;
          vendorHash = null;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.alejandra
            pkgs.go_1_23
            pkgs.golangci-lint
            pkgs.pre-commit
          ];

          shellHook = ''
            # Source .bashrc
            . .bashrc

            # Tooling
            go install golang.org/x/tools/cmd/goimports@latest
          '';
        };
      }
    );
}
