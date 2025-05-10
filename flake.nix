{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { system, pkgs, ... }:
        {
          packages = {
            iso = inputs.nixos-generators.nixosGenerate {
              format = "install-iso";
              inherit system;
              specialArgs = { inherit inputs; };
              modules = [ ./configuration.nix ];
            };
          };

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.sops
              pkgs.age
            ];
          };

          formatter =
            (inputs.treefmt-nix.lib.evalModule pkgs {
              projectRootFile = "flake.nix";
              programs = {
                nixfmt.enable = true;
                prettier.enable = true;
                just.enable = true;
              };
            }).config.build.wrapper;
        };
    };
}
