{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Develop
    neovim
    go
    vscode-fhs
    
    # Internet
    telegram-desktop
    chromium
    librewolf
    qbittorrent-enhanced
    openconnect
    
    # Utils
    fastfetch
    cpufetch
    lsd
    kitty
    vifm
    keepassxc
    tigervnc
    bottles
    
    # Productivity
    obsidian
    libreoffice-qt6-fresh
    
    # Multimedia
    mpv
  ];
}
