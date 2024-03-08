{ config, inputs, lib, pkgs, ... }:
{
  # Services, packages, and configurations for my OS. 
 
  # Import hardware configurations.
  imports = [ ./hardware.nix ];

  # Allow unfree software. 
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.allowed-users = [ "carson" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
 
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    }; 
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Set timezone.
  time.timeZone = "America/Chicago";
  
  programs = {
		dconf.enable = true;
    gnupg.agent.enable = true;
		zsh.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
     
      # Fix screen tearing.
      screenSection = ''
        Option	    "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
        Option      "AllowIndirectGLXProtocol" "off"
        Option      "TripleBuffer" "on"
      '';

      # startx display manager.
      displayManager.startx.enable = true;

      # Tiling window manager.
      windowManager.spectrwm.enable = true;

      # Better peripheral support.
      libinput.enable = true;

      # Caps -> Ctrl.
      xkb = {
        layout = "us";
        options = "ctrl:swapcaps";
      };
    };
    
    openssh.enable = true;
		blueman.enable = true;
  };

  # Video and Sound
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
      driSupport = true;
    };
		bluetooth = {
			enable = true;
			powerOnBoot = true;
 		};
    nvidia.modesetting.enable = true;
  };
 
  
  # Add users and their packages.
  users.users = {
    carson = {
      isNormalUser = true;
			shell = pkgs.zsh;
      extraGroups  = [ "wheel" ];
      packages = [
				pkgs.kitty
				pkgs.google-chrome
				pkgs.dmenu
				pkgs.htop
        inputs.neovim.packages.x86_64-linux.nvim
      ];
    };
  };

	# Global packages
  environment.systemPackages = [ 
    pkgs.tmux
    pkgs.git
    pkgs.unzip
    pkgs.pfetch
    pkgs.vim
    pkgs.xlockmore
  ];
 
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
  };

  system.stateVersion = "24.05";
}