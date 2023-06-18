# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
     ./hardware-configuration.nix
    ];
  environment.variables = {
	SUDO_EDITOR = "nvim";
    };
  

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  #networking.useDHCP = false;
  #networking.interfaces.enp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
    # BSPWM
  services.xserver.windowManager.bspwm.enable = true;
 
  #zsh
  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # services.xserver.xkbOptions = "eurosign:e";
  # Picom Fork
  
  # Enable CUPS to print documents.
   services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by defaul>
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;
   
     # Fonts
  fonts.fonts = with pkgs; [
  (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
];
 
 

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.main = {
     isNormalUser = true;
     description = "main";
     extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
   };
   
      users.extraUsers.main = {
 
 	shell = pkgs.zsh;
 
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
      environment.systemPackages = with pkgs; [
     neovim
     wget
     firefox
     pfetch
     git
     feh
     sxiv
     #picom
     nur.repos.reedrw.picom-next-ibhagwan
     bspwm
     sxhkd
     alacritty
     zsh
     polybar
     openspades
     rofi
     pipes
     ranger
     discord
     pavucontrol
     maim
     killall
     audacity
     mumble
     xclip
     obs-studio
     ffmpeg
     mpv
     gimp
     libsForQt5.breeze-gtk     
     lxappearance
     kdenlive
     youtube-dl
     vscode
     unzip
   ];
   
      # Auto upgr
      # ades
  system.autoUpgrade.enable = true;
#  system.autoUpgrade.allowReboot = true;

  # Hard link identical files in the store automatically
  nix.settings.auto-optimise-store = true;
   nix = {
    # automatically trigger garbage collection
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 30d";
  };
 
 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

