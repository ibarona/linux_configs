# Configuración a nivel de SISTEMA. Los programas propios del usuario
# ibarona (editor, terminal, navegador, temas, etc.) viven en ./home.nix,
# gestionados por Home Manager.

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # --- Bootloader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Evita que la ESP se llene de generaciones viejas (importante en unstable)
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.extraEntries = {
    "shipwreck.conf" = ''
      title Shipwreck (Void Linux)
      efi /EFI/odyssey/grubx64.efi
    '';
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # --- Gráficos y firmware ---
  #hardware.graphics.enable = true;
  # hardware.graphics.enable32Bit = true; # descomenta si usas Steam/Wine/juegos de 32 bits
  hardware.enableRedistributableFirmware = true;

  # --- Red ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- Localización ---
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };
  console.keyMap = "es";

  # --- Sesión gráfica: Noctalia Greeter + labwc + Noctalia ---
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor.size = 24;
      keyboard.layout = "es";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
    };
  };

  programs.labwc.enable = true;
  programs.noctalia.enable = true;
  programs.noctalia.recommendedServices.enable = true;
  programs.dconf.enable = true;

  # --- Audio (pipewire) ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # --- Cuenta de usuario ---
  # Los paquetes personales de ibarona se gestionan en home.nix (Home Manager)
  users.users."ibarona" = {
    isNormalUser = true;
    description = "Isaac Barona";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # --- Montaje de dispositivos extraíbles ---
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # --- Portales XDG (screenshot/screencast en Wayland) ---
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
    configPackages = [ pkgs.labwc ];
    config.common = {
      default = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = false;  # sustituido por nh clean
      # dates = "weekly";
      # options = "--delete-older-than 30d";
    };
  };

  # Programa nh
  programs.nh = {
    enable = true;
    flake = "/home/ibarona/nixos-flakes";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 30d";
    };
  };

  # --- Paquetes base del sistema ---
  # Solo herramientas de rescate/administración disponibles para todos los
  # usuarios (incl. root). El resto de programas van en home.nix.
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    inter
  ];

  # services.openssh.enable = true;

  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];

  
  system.stateVersion = "26.05";
}
