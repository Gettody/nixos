{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  environment.systemPackages = with pkgs; [
    disko 
    git
    neovim
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
