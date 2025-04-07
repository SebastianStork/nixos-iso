{
  modulesPath,
  inputs',
  lib,
  ...
}:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  nix.settings.experimental-features = [ "pipe-operators" ];

  networking.hostName = "installer";

  formatAttr = "isoImage";
  fileExtension = ".iso";

  services.openssh.enable = lib.mkForce false;
  networking.wireless.enable = false;

  console.keyMap = "de-latin1-nodeadkeys";

  environment.systemPackages = [ inputs'.disko.packages.default ];

  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [ "--ssh" ];

    # Ephemeral + not pre-approved
    authKeyFile = ../tailscale-auth-key.dec;
  };
}
