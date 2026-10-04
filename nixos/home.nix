{ pkgs, ... }:

{
  home.username = "ibarona";
  home.homeDirectory = "/home/ibarona";

  # Debe fijarse una vez al empezar a usar Home Manager y no tocarse después
  # (igual que system.stateVersion en configuration.nix).
  home.stateVersion = "26.05";

  # Permite usar el comando `home-manager` directamente
  programs.home-manager.enable = true;

  # --- Programas y utilidades personales ---
  home.packages = with pkgs; [
    helix
    fastfetch
    kitty
    btop
    adw-gtk3
    nwg-look
    qt6Packages.qt6ct
    featherpad
    pcmanfm-qt
    qimgv
    qt6Packages.qtstyleplugin-kvantum
    catppuccin
    catppuccin-kvantum
    catppuccin-qt5ct
    catppuccin-gtk
    brave-origin # verifica que existe: `nix search nixpkgs brave-origin`; si no, usa `brave`
    xarchiver
    peazip
    adwaita-icon-theme
    papirus-icon-theme
    zed-editor
    xwayland-satellite
  ];

  # --- Navegador como app de usuario ---
  programs.firefox.enable = true;

  # --- Git (rellena tus datos cuando quieras) ---
  programs.git = {
    enable = true;
    settings.user.name = "Isaac Barona";
    settings.user.email = "ibarona@gmail.com";
  };

  # --- Cursor Catppuccin para toda la sesión (GTK/X11) ---
  home.pointerCursor = {
    enable= true;
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # --- Theming GTK/Qt coherente entre sí ---
  #gtk.enable = true;

  #qt = {
  #  enable = true;
  #  platformTheme.name = "qtct";
    #style.name = "kvantum";
  #};

  # --- Variables de entorno de usuario ---
  home.sessionVariables = {
    XCURSOR_THEME = "catppuccin-mocha-mauve-cursors";
    XCURSOR_SIZE = "24";
    EDITOR = "hx";
    NIXOS_OZONE_WL = "1";
  };
}
