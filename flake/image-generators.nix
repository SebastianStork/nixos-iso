{ inputs, self, ... }:
{
  perSystem =
    {
      system,
      inputs',
      lib,
      ...
    }:
    {
      packages =
        let
          mkImage =
            {
              name,
              format,
              config ? { },
            }:
            {
              ${name} = inputs.nixos-generators.nixosGenerate {
                customFormats.minimal-iso = "${self}/formats/minimal-iso.nix";
                inherit system format;
                specialArgs = { inherit inputs'; };
                modules = [
                  { isoImage.isoBaseName = name; }
                  config
                ];
              };
            };
        in
        lib.mkMerge [

          (mkImage {
            name = "minimal";
            format = "minimal-iso";
          })

          (mkImage {
            name = "minimal-wlan";
            format = "minimal-iso";
            config = {
              networking.networkmanager.enable = true;
            };
          })

        ];
    };
}
