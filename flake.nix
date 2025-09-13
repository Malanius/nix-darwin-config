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
          # Apps / Utilities
          pkgs._1password-cli # op for cli
          # pkgs._1password-gui # complains it is not installed in Applications :(
          # pkgs.openvpn
          pkgs.pkg-config # FIXME: what needs this?
          # pkgs.raycast # can't use Mac without it, I know, skill issue 😒# nixpgs version is fairly behind, some plugins don't work with it, using brew version
          pkgs.speedtest-cli

          # Apps / Comms
          pkgs.mailspring

          # Apps / Media
          pkgs.mpv-unwrapped
          #pkgs.ffmpeg_8-full # raycast plugins doesn't seem to see nix version
          #pkgs.spotify # broken MacOS build, using native version

          # Apps / CLI
          pkgs.alacritty # best terminal ever, https://alacritty.org/
          pkgs.bat # better cat, https://github.com/sharkdp/bat
          pkgs.broot # fuzzy file navigator, https://github.com/Canop/broot
          pkgs.btop # resource monitor, https://github.com/aristocratos/btop
          pkgs.dua # disk usage analyzer, https://github.com/Byron/dua-cli
          pkgs.duf # disk usage formatter, https://github.com/muesli/duf/
          pkgs.dust # more intuitive du, https://github.com/bootandy/dust
          pkgs.entr # run arbitrary commands when files change, https://eradman.com/entrproject/
          pkgs.eva # cli calculator, https://github.com/oppiliappan/eva
          pkgs.eza # better ls, https://github.com/eza-community/eza
          pkgs.fd # better find, https://github.com/sharkdp/fd
          pkgs.fx # better jq for json, https://github.com/antonmedv/fx
          pkgs.fzf # fuzzy finder, used by many other tools, https://github.com/junegunn/fzf
          pkgs.ouch # multi-format file de/compressor, https://github.com/ouch-org/ouch
          pkgs.pay-respects # better thefuck?, https://codeberg.org/iff/pay-respects 
          pkgs.rip2 # rm improved, with recycle bin, https://github.com/MilesCranmer/rip2
          pkgs.ripgrep # superfast grep, https://github.com/BurntSushi/ripgrep
          pkgs.rnr # rename files with regex, https://github.com/ismaelgv/rnr
          pkgs.sd # sed but better, https://github.com/chmln/sd
          pkgs.silver-searcher # ag, Code-searching tool similar to ack, but faster, https://github.com/ggreer/the_silver_searcher/
          pkgs.starship # the only shell prompt you'll ever need, https://starship.rs/
          pkgs.tealdeer # fast, rust-based tldr client, https://github.com/tealdeer-rs/tealdeer
          # pkgs.thefuck # no longer maintained and disappeared from nixpkgs
          pkgs.topgrade # upgrade everything, https://github.com/topgrade-rs/topgrade
          pkgs.tre-command # better fster, tree, still can't properly sort, https://github.com/dduan/tre
          # pkgs.xcp # some of the dependent libs don't specify aarch64 as supported

          # DEV / AWS
          pkgs.aws-vault
          pkgs.awscli2
          pkgs.awslogs
          pkgs.localstack

          # DEV / Databases
          pkgs.dbeaver-bin
          pkgs.postgresql_16
          pkgs.sq # Swiss army knife for data, https://sq.io/
          pkgs.visidata

          # DEV / Git
          pkgs.difftastic
          pkgs.gh # GitHub CLI, https://cli.github.com/
          pkgs.git
          pkgs.git-cliff # changelog generator, https://github.com/orhun/git-cliff
          pkgs.git-lfs
          pkgs.gitflow
          pkgs.gitkraken
          pkgs.gk-cli
          pkgs.gnupg
          pkgs.lazygit

          # DEV / Docker
          pkgs.lazydocker

          # DEV / Python
          pkgs.graphviz # used by diagrams-py
          pkgs.pipx
          # pkgs.poetry # act's wonky when isntalled from nix, surpassed by UV anyways
          pkgs.pyenv
          pkgs.uv

          # DEV / k8s
          # pkgs.argocd
          # pkgs.krew
          # pkgs.kubernetes-helm

          # DEV / Node
          pkgs.bun
          pkgs.nodePackages_latest.pnpm
          pkgs.yarn

          # DEV / Rust
          pkgs.rustup

          # DEV / Neovim
          pkgs.vim # fallback for neovim
          pkgs.neovim
          pkgs.bottom # used by AstroNvim
          pkgs.gdu # used by AstroNvim
          pkgs.lazygit # used by AstroNvim
          pkgs.ripgrep  # used by AstroNvim
          pkgs.tree-sitter # used by AstroNvim

          # DEV / Go
          pkgs.go

          # DEV / Tools
          pkgs.cookiecutter # project templating, https://cookiecutter.readthedocs.io/en/latest/
          pkgs.httpie # better curl, https://httpie.io/
          # pkgs.httpie-desktop # no arm64 build
          pkgs.jq # command-line JSON processor, https://stedolan.github.io/jq/
          # pkgs.jetbrains-toolbox # Older version, can't auto-update, using native
          pkgs.just # better make, https://github.com/casey/just
          pkgs.kondo # clean up space from inactive projects, https://github.com/tbillington/kondo
          pkgs.navi # interactive cheatsheet tool, https://github.com/denisidoro/navi
          pkgs.ngrok # secure introspectable tunnels to localhost, https://ngrok.com/
          pkgs.nixfmt-classic # Nix files formatter, required by VSCode extension
          pkgs.pandoc # universal document converter, https://hackage.haskell.org/package/pandoc-cli
          pkgs.tectonic # LaTeX engine, required by Pandoc for PDF output, https://tectonic-typesetting.github.io/en-US/
          pkgs.tokei # Count your code, quickly, https://github.com/XAMPPRocky/tokei
          pkgs.vscode # VSCode, https://code.visualstudio.com/
          pkgs.wakatime # time tracking, https://wakatime.com/
        ];

        homebrew = {
          # Still requires homebrew to be installed manually once
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
            "ffmpeg"
            # "kreuzwerker/taps/m1-terraform-provider-helper"
            "openssl@3"
            #"tfenv"
            "xz"
            "yt-dlp"
            "zlib"
            "zsh-completions"
          ];
          casks = [
            "insomnia" # Gui Insomina
            "inso" # CLI Insomnia
            "vesktop"
            "raycast"
          ];
          masApps = {
            # When adding app for first time, it needs to be done trough MaS to link with account
            # only then it can be managed through nix
            "Toggl Track: Hours & Time Log" = 1291898086;
            "Fresco" = 1251572132;
            "reMarkable" = 1276493162;
            "Slack" = 803453959;
            # "SuperProductivity" = 1482572463; # old version, troubles with sync, using DMG version
            "Telegram" = 747648890;
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
          cp = "xcp -v";
          ls = "eza";
          ll = "ls -alF";
          la = "ls -A";
          l = "ls -CF";
          lll = "ls -alF | less";
          llh = "ls -alFh";
          rm = "rm -v";
          mv = "mv -v";
          # Dev tools
          d = "docker";
          dc = "docker-compose";
          k = "kubectl";
          kn = "k9s";
          ldc = "lazydocker";
          lg = "lazygit";
          tf = "terraform";
          projen = "npx projen";
          pj = "npx projen";
        };
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."macshit" =
        nix-darwin.lib.darwinSystem { modules = [ configuration ]; };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."macshit".pkgs;
    };
}
