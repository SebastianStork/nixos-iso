{
  perSystem =
    { pkgs, system, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.sops
          pkgs.age
        ];
      };
    };
}
