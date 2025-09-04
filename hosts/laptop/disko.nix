let
  btrfsOptions = [ "compress=zstd:3" "noatime" "ssd" "discard=async" ];
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = btrfsOptions;
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = btrfsOptions;
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = btrfsOptions;
                  };
                  "/var" = {
                    mountpoint = "/var";
                    mountOptions = btrfsOptions;
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap = {
                      swapfile = {
                        size = "9G";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
