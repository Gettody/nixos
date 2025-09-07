{
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
}