{
  description = "Malanius Darwin Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      imports = [ <home-manager/nix-darwin> ];
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget

        nixpkgs.config = { allowUnfree = true; };
        environment.systemPackages = [
          # pkgs._1password-gui # complains it is not installed in Applications :(
          pkgs._1password
          pkgs.alacritty
          pkgs.argocd
          pkgs.awscli2
          pkgs.btop
          pkgs.bun
          pkgs.fzf
          pkgs.git
          pkgs.git-cliff
          pkgs.git-lfs
          pkgs.gitflow
          pkgs.gitkraken
          pkgs.go
          pkgs.krew
          pkgs.kubernetes-helm
          pkgs.localstack
          pkgs.lunarvim # bug present w/ loading treesitter, see https://github.com/NixOS/nixpkgs/issues/312971
          pkgs.neovim
          pkgs.nixfmt-classic
          pkgs.nodePackages_latest.pnpm
          pkgs.pkg-config
          pkgs.poetry
          pkgs.powerline
          pkgs.raycast
          pkgs.rustup
          pkgs.spotify
          pkgs.starship
          pkgs.thefuck
          pkgs.vim
          pkgs.vscode
          pkgs.wakatime
          pkgs.yarn
        ];

        homebrew.enable = true;
        homebrew.taps = [ "derailed/k9s" ];
        homebrew.brews = [ "derailed/k9s/k9s" ];

        fonts.fontDir.enable = true;
        fonts.fonts = [ pkgs.nerdfonts ];

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;
        #services.skhd = {
        #	enable = true;
        #};
        #services.spacebar = {
        # enable = true;
        #};
        #services.yabai = {
        #	enable = true;
        #      };

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        programs.bash.enable = true;
        programs.bash.enableCompletion = true;
        # programs.fish.enable = true;
        programs.tmux.enable = true;
        programs.direnv.enable = true;
        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Some goodies
        security.pam.enableSudoTouchIdAuth = true;

        system.defaults = {
          dock = {
            autohide = true;
            mru-spaces = false;
            orientation = "left";
          };
          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            FXPreferredViewStyle = "clmv";
          };
          menuExtraClock = {
            Show24Hour = true;
            ShowDate = 1;
          };
          screencapture.location = "~/Pictures/screenshots";
          screensaver.askForPasswordDelay = 10;
          trackpad = { Clicking = true; };
        };
        system.startup.chime = false;

        # Enable x86 w/ rosseta
        nix.extraOptions = ''
          extra-platforms = x86_64-darwin aarch64-darwin
        '';

        # Enable building of linux bins
        nix.settings.extra-trusted-users = [ "@admin" ];
        nix.linux-builder.enable = true;

        users.users.malanius = {
          name = "malanius";
          home = "/Users/malanius";
        };

        environment.shellAliases = {
          rm = "rm -v";
          mv = "mv -v";
          cp = "xcp -v";
          ls = "eza";
          ll = "ls -alF";
          la = "ls -A";
          l = "ls -CF";
          lll = "ls -alF | less";
          llh = "ls -alFh";
        };
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."K0WWL9G0P7" =
        nix-darwin.lib.darwinSystem { modules = [ configuration ]; };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."K0WWL9G0P7".pkgs;
    };
}
