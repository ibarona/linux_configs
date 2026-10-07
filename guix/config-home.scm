;; config-home.scm — entorno de usuario para la sesión labwc + Noctalia.
;; Solo paquetes y servicios de usuario: los ficheros de ~/.config se gestionan
;; de forma externa (ver dotfiles/).
;; (labwc en sí está en el perfil del sistema, ver config.scm)

(use-modules (gnu home)
             (gnu home services)
             (gnu home services desktop)   ; home-dbus-service-type
             (gnu home services shells)    ; home-bash-service-type
             (gnu home services sound)     ; home-pipewire-service-type
             (gnu packages)
             (guix gexp))

(home-environment
 ;; specifications->packages resuelve por nombre en todos los canales
 ;; (firefox viene de nonguix; noctalia-git del canal noctalia).
 (packages
  (specifications->packages
   (list
    ;; Sesión labwc
    "noctalia"
    "foot"                        ; terminal
    "kitty"

    ;; Gestor de archivos GTK: Thunar + complementos
    "thunar"
    "thunar-volman"               ; automontaje de medios extraíbles
    "thunar-archive-plugin"       ; menú contextual: comprimir/extraer
    "tumbler"                     ; miniaturas
    "xfconf"                      ; almacén de ajustes de Thunar
    "gvfs"                        ; montar USB, papelera, MTP...
    "file-roller"                 ; motor de compresión/extracción
    "zip"
    "unzip"
    ;; "7zip"                     ; formato .7z; comprueba el nombre con `guix search 7zip`

    ;; Gestor de archivos Qt (para comparar con Thunar)
    "pcmanfm-qt"

    ;; Aplicaciones GTK
    "ristretto"                   ; visor de imágenes
    "mousepad"                    ; editor de texto

    ;; Aplicaciones Qt
    "featherpad"
    "qimgv"

    ;; Otras aplicaciones
    ;;"ungoogled-chromium-wayland"
    "google-chrome-stable"
    "firefox"
    "helix"
    "btop"
    "fastfetch"
    "ncdu"

    ;; Base de escritorio. Antes las traía Plasma; ahora van explícitas.
    "shared-mime-info"            ; tipos MIME (hook de perfil)
    "desktop-file-utils"          ; base de datos de .desktop (hook de perfil)
    "xdg-utils"                   ; xdg-open, xdg-mime
    "dconf"                       ; persistencia de ajustes GTK (nwg-look, gsettings)
    "qtwayland"                   ; Qt sobre Wayland
    "qtsvg"                       ; para que funcionen los iconos papirus
    "papirus-icon-theme"
    "hicolor-icon-theme"
    "adwaita-icon-theme"
    "adw-gtk3-theme"
    "kvantum"
    "qt6ct"
    "nwg-look"

    ;; Fuentes
    "font-google-noto"
    "font-google-noto-emoji"
    "font-nerd-jetbrains-mono"

    ;; Utilidades de Wayland
    "wl-clipboard"
    "cliphist"
    "grim"
    "slurp"
    ;;"satty"
    "brightnessctl"
    "playerctl"
    "wlsunset"
    "pavucontrol-qt"
    "mpv"
    "imv"
    "zathura"
    "zathura-pdf-mupdf"
    "wdisplays"
    "kanshi"

    ;; Portales XDG (configuración en ~/.config/xdg-desktop-portal*/, ver dotfiles/)
    "xdg-desktop-portal"
    "xdg-desktop-portal-wlr"      ; captura y compartir pantalla
    "xdg-desktop-portal-gtk")))   ; selector de archivos y resto de portales

 (services
  (list
   ;; Bus de sesión y audio como servicios de usuario (Shepherd)
   (service home-dbus-service-type)
   (service home-pipewire-service-type)

   (service home-bash-service-type
            (home-bash-configuration
             (bash-profile
              (list
               (plain-file
                "arranque-grafico.sh"
                "# Espera (máx. ~5 s) al bus de sesión que levanta Guix Home
esperar_bus() {
  for i in $(seq 50); do
    [ -S \"$XDG_RUNTIME_DIR/bus\" ] && return 0
    sleep 0.1
  done
  return 1
}

# Sesión lanzada desde SDDM: SDDM ejecuta un shell de login, así que este
# fichero se lee antes de arrancar labwc.
case \"$XDG_SESSION_TYPE\" in
  wayland|x11) esperar_bus ;;
esac

# Alternativa sin display manager: labwc directamente desde tty1
if [ -z \"$WAYLAND_DISPLAY\" ] && [ -z \"$DISPLAY\" ] && [ \"$(tty)\" = /dev/tty1 ]; then
  esperar_bus
  exec labwc
fi
"))))))))
