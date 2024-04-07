{
  description = "Reproducible Docker images for code-server";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # https://github.com/nix-systems/nix-systems
      systems = import inputs.systems;

      # packages that will be build for each available system
      perSystem = {pkgs, ...}: {
        packages.default = pkgs.callPackage ./images/code-server.nix {};
      };
    };
}
