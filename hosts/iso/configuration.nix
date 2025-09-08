{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  environment.systemPackages = with pkgs; [
    disko
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
