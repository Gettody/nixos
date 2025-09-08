{
    environment.systemPackages = with pkgs; [
        docker-compose
        dfu-util
        esphome
        esptool
        git
    ]
}