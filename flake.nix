# TODO: find how to properly run home-manager to create the utility srcipts and dotfiles
# TODO: modularize the config
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
          pkgs._1password-cli
          pkgs.alacritty
          pkgs.aws-vault
          pkgs.awscli2
          pkgs.awslogs
          pkgs.bat
          pkgs.btop
          pkgs.cookiecutter
          pkgs.dbeaver-bin
          pkgs.difftastic
          pkgs.duf
          pkgs.entr
          pkgs.eza
          pkgs.fx
          pkgs.fzf
          pkgs.gh
          pkgs.git
          pkgs.git-cliff
          pkgs.git-lfs
          pkgs.gitflow
          pkgs.gitkraken
          pkgs.gk-cli
          pkgs.gnupg
          pkgs.graphviz
          pkgs.go
          pkgs.httpie
          # pkgs.httpie-desktop # no arm64 build
          pkgs.jq
          pkgs.lazydocker
          pkgs.lazygit
          pkgs.localstack
          pkgs.mailspring
          pkgs.mpv-unwrapped
          pkgs.neovim
          pkgs.ngrok
          pkgs.nixfmt-classic
          pkgs.nodePackages_latest.pnpm
          pkgs.openvpn
          pkgs.ouch
          pkgs.pkg-config
          pkgs.pandoc
          # pkgs.poetry
          pkgs.postgresql_16
          pkgs.raycast
          pkgs.rustup
          pkgs.silver-searcher
          pkgs.speedtest-cli
          pkgs.spotify
          pkgs.starship
          pkgs.sq
          pkgs.tectonic
          # pkgs.thefuck
          pkgs.pay-respects
          pkgs.vim
          pkgs.visidata
          pkgs.vscode
          pkgs.wakatime

          # DEV / Python
          pkgs.pipx
          pkgs.pyenv
          pkgs.uv


          # DEV / k8s
          # pkgs.argocd
          # pkgs.krew
          # pkgs.kubernetes-helm

          # DEV / Node
          pkgs.bun
          pkgs.yarn

          # Rust packages
          pkgs.broot
          pkgs.dua
          pkgs.dust
          pkgs.eva
          pkgs.fd
          pkgs.just
          pkgs.kondo
          pkgs.navi
          pkgs.ouch
          pkgs.rip2
          pkgs.rnr
          pkgs.sd
          pkgs.tealdeer
          pkgs.tokei
          pkgs.topgrade
          pkgs.tre-command
          pkgs.tree-sitter
          pkgs.xcp
        ];

        homebrew = {
          enable = true;
          taps = [
            # "derailed/k9s"
          ];
          brews = [
            "colima"
            # "derailed/k9s/k9s"
            "docker-buildx"
            "docker-compose"
            "docker-credential-helper"
            "docker"
            "kreuzwerker/taps/m1-terraform-provider-helper"
            "openssl@3"
            "tfenv"
            "xz"
            "zlib"
            "zsh-completions"
          ];
          casks = [
            # "superproductivity" # doesn't work, OS complains it can't be check for malicious software
            "insomnia"
            "inso"
          ];
          masApps = {
            "Toggl Track: Hours & Time Log" = 1291898086;
            "Fresco" = 1251572132;
            "reMarkable" = 1276493162;
          };
          onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
          };
        };

        fonts.packages = [ ]
          ++ builtins.filter nixpkgs.lib.attrsets.isDerivation
          (builtins.attrValues pkgs.nerd-fonts);

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
        programs.bash.completion.enable = true;
        # programs.fish.enable = true;
        programs.tmux.enable = true;
        programs.direnv.enable = true;
        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
        ids.gids.nixbld = 350;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        security.pam.services.sudo_local = {
          enable = true;
          reattach = true;
          touchIdAuth = true;
        };

        system.primaryUser = "malanius";
        system.defaults = {
          dock = {
            autohide = false;
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
          NSGlobalDomain.KeyRepeat = 1;
        };
        system.startup.chime = false;
        system.keyboard = {
          enableKeyMapping = true;
          nonUS.remapTilde = true;
        };

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
          lll = "ls -alF | less";
          llh = "ls -alFh";
          lg = "lazygit";
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
