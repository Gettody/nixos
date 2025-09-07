# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

environment.variables.EDITOR = "nvim";

#services.logmein-hamachi.enable = false;

hardware.opentabletdriver.enable = true;

services.flatpak.enable = true;
  # appimage
programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [ pkgs.xorg.libxshmfence ];
    };
};

services.k3s = {
    enable = false;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode=644"
    ];
};

programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
};

services.tailscale.enable = true;

services.yggdrasil = {
  enable = true;
  persistentKeys = true;
  settings = {
    Peers = [
      tcp://srv.itrus.su:7991
      tls://srv.itrus.su:7992
      ws://srv.itrus.su:7994
      tcp://s-mow-0.sergeysedoy97.ru:65533
    ];
  };
};

virtualisation.libvirtd.enable = true;
# docker
virtualisation.docker.enable = true;
virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
};

nix.settings.experimental-features = ["nix-command" "flakes"];
nix.settings.auto-optimise-store = true;
nix.settings.cores = 0;
nix.settings.max-jobs = "auto";

nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  services.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leo = {
    isNormalUser = true;
    description = "leo";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "dialout" "input" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # gsconnect
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
  #syncthing
  services = {
    syncthing = {
        enable = true;
        group = "users";
        user = "leo";
        #dataDir = "/home/leo/Sync";    # Default folder for new synced folders
	configDir = "/home/leo/.config/syncthing";
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    telegram-desktop
    go
    git
    #hiddify-app
    obsidian
    libreoffice-qt6-fresh
    tigervnc
    keepassxc
    xorg.libxshmfence
    libGLU
    docker-compose
    qbittorrent-enhanced
    fastfetch
    gnomeExtensions.status-icons
    gnomeExtensions.caffeine
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    chromium
    dfu-util
    esphome
    gnomeExtensions.home-assistant-extension
    gnome-boxes
    gnomeExtensions.unlock-dialog-background
    mpv
    openconnect
    esptool
    kitty
    vifm
    vscode-fhs
    lsd
    cpufetch
    librewolf
    bottles
    osu-lazer-bin
  ];


  programs.firejail.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.terminess-ttf
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

networking.firewall.allowedTCPPorts = [ 22 ];

services.openssh = {
  enable = true;
  ports = [ 22 ];
  settings = {
    PasswordAuthentication = true;
    AllowUsers = [ "leo" ]; # Allows all users by default. Can be [ "user1" "user2" ]
    UseDns = true;
    X11Forwarding = false;
    PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
  };
};
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
   networking.firewall.allowedUDPPorts = [ 10999 ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
