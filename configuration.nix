# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t440p>
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs =
    {
      config = {
        permittedInsecurePackages = [ "openssl-1.0.2u" "p7zip-16.02" "adobe-reader-9.5.5" ];
        allowUnfree = true;
        allowUnfreePredicate = (pkg: true);
        allowBroken = true;
        packageOverrides = pkgs: {
          vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
        };
      };
    };

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "262144";
  }];

  # Set your time zone.
  time.timeZone = "Europe/Samara";
  time.hardwareClockInLocalTime = true;
  networking.hostName = "rl-station"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.enableStrongSwan = true;
  hardware.usbWwan.enable = true;
  systemd.services.modem-manager.enable = true;

  services.openntpd.enable = true;
  services.openntpd.servers = [ "ntp2.vniiftri.ru" "ntp1.vniiftri.ru" ];
  #services.geoclue2.enable = true;
  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  environment.systemPackages = with pkgs; [
    wget mc screen htop p7zip
    xorg.xwininfo unetbootin ms-sys
    adobe-reader baobab dia libreoffice slack gnucash fbreader blender gimp firefox
    tdesktop vlc remmina testdisk-qt avidemux
    wine winetricks
    anydesk
    google-chrome chromium mpv #skypeforlinux zoom-us
    transmission-gtk
    qcad openscad librecad freecad kicad
    discord
    audacity ardour FIL-plugins lmms mixxx
    mono clang gitAndTools.gitFull

    ghc stack cabal-install
    ghcid haskell-language-server
    atom vscodium-fhs
    netbeans

    mtpfs jmtpfs slock pavucontrol microcodeIntel ntfs3g btrfs-progs zfs zfstools bluez firmwareLinuxNonfree blueman
    gparted psmisc modemmanager #modem-manager-gui
    obs-studio obs-studio-plugins.wlrobs obs-studio-plugins.obs-gstreamer
    bluespec
    dosfstools mtools
    python38
    python38Packages.pip python38Packages.pip-tools
    python38Packages.virtualenv
    python38Packages.pipdate
    python38Packages.ds4drv

    #games
    warzone2100 wesnoth openttd teeworlds #hedgewars

    openconnect

    patchelf
    nix-index
    autoPatchelfHook
    gtk3 gtk4 gtk3-x11 gdk-pixbuf gdk-pixbuf-xlib libcdada libstdcxx5 xorg.xstdcmap
    jdk openjfx15
    flite
    unrar rar unzip

    #Unreal Engine
    #ue4
    #ue4demos.shooter_game ue4demos.elemental_demo ue4demos.effects_cave_demo ue4demos.scifi_hallway_demo ue4demos.reflections_subway ue4demos.mobile_temple_demo ue4demos.realistic_rendering ue4demos.landscape_mountains ue4demos.blueprint_examples_demo

  ];

  programs.java.enable = true;

  # Enable sound.
  sound.enable = true;
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;
  services.blueman.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    #extraModules = [ pkgs.pulseaudio-modules-bt ];
    support32Bit = true;
  };
  services.udev.extraRules = ''
      # This rule is needed for basic functionality of the controller in
      # Steam and keyboard/mouse emulation
      SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
      # This rule is necessary for gamepad emulation; make sure you
      # replace 'pgriffais' with a group that the user that runs Steam
      # belongs to
      KERNEL=="uinput", MODE="0660", GROUP="pgriffais", OPTIONS+="static_node=uinput"
      # Valve HID devices over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"
      # Valve HID devices over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0666"
      # DualShock 4 over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
      # DualShock 4 wireless adapter over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
      # DualShock 4 Slim over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
      # DualShock 4 over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"
      # DualShock 4 Slim over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"
  '';

  programs.nano.nanorc =
''
  set nowrap
  set tabstospaces
  set tabsize 2
  set linenumbers
'';
  programs.nano.syntaxHighlight = true;

  services.openssh.enable = true;
  services.upower.enable = true;
  systemd.services.upower.enable = true;
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
    displayManager.sddm.enable = true;
    libinput.enable = false;
    libinput.touchpad.disableWhileTyping = true;
    layout = "us,ru(winkeys)";
    xkbOptions = "grp:ctrl_shift_toggle";
    synaptics = {
      enable = true;
      tapButtons = true;
      twoFingerScroll = true;
      vertTwoFingerScroll = true;
      horizontalScroll = true;
      horizTwoFingerScroll = true;
      horizEdgeScroll = true;
    };
    desktopManager.xfce.enable = true;
    #displayManager.defaultSession = "none+xmonad";
    displayManager.defaultSession = "xfce";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages =
        haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
        ];
      #config = ./config.hs;
    };
    #windowManager.default = "xmonad";
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };
  services.pipewire.enable = true;
  #programs.rofi = {
  #  enable = true;
  #  terminal = "${pkgs.alacritty}/bin/alacritty";
  #  theme = ./theme.rafi;
  #};

  services.samba.enable = true;

  services.picom = {
    enable = false;
    #activeOpacity = "1.0";
    #inactiveOpacity = "0.8";
    backend = "xr_glx_hybrid";
    fade = true;
    fadeDelta = 5;
    #opacityRule = [ "100:name *= 'i3lock'" ];
    shadow = true;
    #shadowOpacity = "0.75";
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver # only available starting nixos-19.03 or the current nixos-unstable
    ];
  };

  programs.adb.enable = true;

  users.users.cyberdront = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/cyberdront";
    createHome = true;
    extraGroups = [ "wheel" "disk" "audio" "dialout" "users" "adm" "networkmanager" "adbusers" ];
    description = "Marat Yanchurin";
  };

  system.stateVersion = "20.09"; # Did you read the comment?

}
