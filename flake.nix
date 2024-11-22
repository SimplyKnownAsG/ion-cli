{
  description = "Nix packaging for amazon-ion/ion-cli";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        ion-cli = pkgs.rustPlatform.buildRustPackage {
          name = "ion-cli";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          doCheck = true;
          nativeBuildInputs = [
            pkgs.jdk17
            pkgs.gradle
          ];
        };
      in
      {
        packages.default = ion-cli;
        packages.ion-cli = ion-cli;

        devShells.default = pkgs.mkShell {
          buildInputs = ion-cli.buildInputs;
          # buildRustPackage defines the baseline native build inputs
          nativeBuildInputs = ion-cli.nativeBuildInputs;
        };
      });
}
