# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];


home-manager = {
	extraSpecialArgs = { inherit inputs;};
	users = {
		"cjminus" = import ./home.nix;
	};
};

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.



services.passSecretService.enable = true;

fonts.packages = with pkgs; [
terminus-nerdfont
pkgs.fira-code-nerdfont
pkgs.hackgen-nf-font

  noto-fonts
 pretendard
vegur
noto-fonts-cjk
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
];

networking.extraHosts =
  ''
  0.0.0.0 sg-public-data-api.hoyoverse.com
0.0.0.0 log-upload-os.hoyoverse.com
0.0.0.0 log-upload-os.mihoyo.com
0.0.0.0 overseauspider.yuanshen.com
   '';





   time.timeZone = "America/Nassau";

   nix.settings.experimental-features = ["nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true; 
security.pam.services.swaylock = {};


services.printing.enable = true;

services.xserver.displayManager.gdm.enable = true;
services.xserver.desktopManager.budgie.enable = false;
environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  cheese # webcam tool
  gnome-music
  gnome-terminal
  gedit # text editor
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
]);

programs.hyprland = { # or wayland.windowManager.hyprland
  enable = true;
  xwayland.enable = true;
};
 
 programs.hyprland.enableNvidiaPatches = true;
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
programs.gamemode.enable = true;

programs.starship.enable = true;
  services.asusd.enable = true;
  services.flatpak.enable = true;
hardware.opengl.extraPackages = [ pkgs.libvdpau-va-gl ]; #NVIDIA doesn't support libvdpau, so this package will redirect VDPAU calls to LIBVA.
environment.variables.VDPAU_DRIVER = "va_gl";
environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; 
  programs.steam.enable = true;
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };




  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

 # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     #keyMap = "us";
     useXkbConfig = true; # use xkbOptions in tty.
   };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
 # services.xserver.displayManager.sddm.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  services.xserver.desktopManager.plasma5.enable = false;
  services.xserver.desktopManager.gnome.enable = true;
  security.rtkit.enable = true; 
  services.pipewire = {
  enable = true; 
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};

hardware.pulseaudio.enable = false;

   users.users.cjrminus= {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       lutris
       wttrbar
       tree
       skypeforlinux
       osu-lazer-bin
       neovim
       brave
       lunar-client
       spotify
       kitty
       vscode       
       wl-screenrec	
       foot
       rofi
       cool-retro-term
      gnome.nautilus
         pkgs.git-credential-manager
        pamixer
 	wlogout
      pkgs.discord-canary
     ];
   };


  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     waybar
     wget
     home-manager
     gnupg    
     git
   ];

  system.stateVersion = "23.05"; # Did you read the comment?

}

