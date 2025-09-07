{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  hardware.opentabletdriver.enable = true;

  services = {
    flatpak.enable = true;
    tailscale.enable = true;
    yggdrasil = {
      enable = true;
      persistentKeys = true;
      settings.Peers = [
        "tcp://srv.itrus.su:7991"
        "tls://srv.itrus.su:7992"
        "ws://srv.itrus.su:7994"
        "tcp://s-mow-0.sergeysedoy97.ru:65533"
      ];
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    syncthing = {
      enable = true;
      group = "users";
      user = "leo";
      configDir = "/home/leo/.config/syncthing";
    };
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "leo" ];
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      cores = 0;
      max-jobs = "auto";
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Moscow";

  i18n = {
    defaultLocale = "ru_RU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
  };

  users.users.leo = {
    isNormalUser = true;
    description = "leo";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "dialout" "input" ];
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [ nerd-fonts.terminess-ttf ];

  system.stateVersion = "25.05";
}
