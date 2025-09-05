{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-vm";
  networking.useDHCP = true;

  users.users.vmuser = {
    isNormalUser = true;
    home = "/home/vmuser";
    description = "VM user";
    extraGroups = [ "wheel" ];
    password = "password";
  };

  services.openssh.enable = true;
  services.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
  ];

  swapDevices = [
    { device = "/swapfile"; size = 1024; }
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Moscow";

  nix.enable = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  system.stateVersion = "25.05";
}
