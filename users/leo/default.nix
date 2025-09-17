{ lib, pkgs, stateVersion, ... }:
{
  imports = [
    ./../../modules/home/packages.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";

    stateVersion = stateVersion;
  };
}
