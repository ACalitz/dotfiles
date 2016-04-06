# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  # Hardware related settings
  boot.kernelModules = [ "applesmc" "coretemp" "i915" ];

  # Enable power management
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave"; # Can also be ondemand if running into performance problems

  # Networking settings
  networking.hostName = "Rez-Nix"; # Define your hostname.
  networking.wireless.enable = false;  # Disables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Enables wireless support via NetworkManager

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Africa/Johanesburg";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Utilities
    powertop
    tlp

    # Development
    openjdk
    openjdk7

    # Development tools
    git
    vim

    # Editors
    sublime3
    idea.idea-ultimate

    # Browsers
    firefox
    chromium

    # Latex
    #(let myTexLive = 
    #        pkgs.texLiveAggregationFun {
    #          paths =
    #            [ pkgs.texLive
    #              pkgs.texLiveCMSuper
    #              pkgs.texLiveExtra
    #              pkgs.texLiveBeamer ];
    #        };
    #       in myTexLive)
  ];

  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };

    firefox = {
      enableAdobeFlash = true;
    };
  };

  programs.bash.enableCompletion = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services = {
    upower.enable = true;
    tlp.enable = true;

    xserver = {
      enable = true;
      useGlamor = true;

      layout = "us";

      # displayManager.kdm.enable = true;
      # desktopManager.kde4.enable = true;

      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;

      # Configure drivers
      videoDrivers = [ "intel" ];

      # Configure touchpad
      synaptics = {
        enable = true;

        dev = "/dev/input/event*";  # Get rid of some errors apperently

        tapButtons = true;
        twoFingerScroll = true;
        accelFactor = "0.001";
        buttonsMap = [ 1 2 3 ];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.rez = {
    name = "rez";
    description = "Andre Calitz";
    group = "users";
    extraGroups = [ "wheel" ];
    uid = 1000;
    createHome = true;
    home = "/home/rez";
    shell = "/run/current-system/sw/bin/bash";
  };

  nixpkgs.config.pulseaudio = true;
  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    pulseaudio.enable = true;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
