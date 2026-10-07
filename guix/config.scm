;; config.scm — Guix System minimalista: kernel/firmware de nonguix, SDDM y sesión labwc
;; (+ Noctalia, que se lanza desde ~/.config/labwc/autostart).
;; Los paquetes de usuario se declaran en config-home.scm.

(use-modules (gnu)
             (guix gexp)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (gnu services base)  ;; for greetd
             (gnu services dbus) ;; polkit-service-type
             (midnight packages noctalia-greeter) ;; for the main greeter package
             (midnight services noctalia-greeter)) ;; for the noctalia-greeter service

             
(use-package-modules wm)                    ; labwc
(use-service-modules desktop pm xorg)

(define %teclado (keyboard-layout "es"))

;; Clave pública del servidor de sustitutos de nonguix.
(define %clave-nonguix
  (plain-file "nonguix.pub"
              "(public-key
 (ecc
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))
"))

(operating-system
  (host-name "guix")
  (locale "es_ES.utf8")
  (timezone "Europe/Madrid")                ; ajústalo
  (keyboard-layout %teclado)

  ;; Kernel completo + firmware + microcódigo (nonguix)
  (kernel linux-lts)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))

  (users (cons (user-account
                (name "ibarona")
                (comment "Isaac Barona")
                (group "users")
                (supplementary-groups '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))

  ;; Paquetes instalados en todo el sistema.
  ;; labwc va en el perfil del SISTEMA: SDDM busca las sesiones (.desktop) en
  ;; /run/current-system/profile/share/{wayland-sessions,xsessions}.
  (packages (append (list
                     (specification->package "labwc")
                     (specification->package "noctalia-greeter")
                     ;; Fonts to cover all languages.
                     (specification->package "font-google-noto")
                     (specification->package "font-google-noto-emoji")
                     (specification->package "font-sarasa-gothic")
                     (specification->package "os-prober")
                     ;; Herramientas de sistemas de archivos para memorias USB y
                     ;; discos externos (las usa udisks al montar/formatear).
                     (specification->package "ntfs-3g")
                     (specification->package "exfatprogs")
                     (specification->package "dosfstools"))
                    %base-packages))

  (services
   (append
;;      (modify-services %base-services
;;          (delete mingetty-service-type))
          
      (list
                (service noctalia-greeter-state-service-type)

                (simple-service 'noctalia-greeter-passwordless-sync polkit-service-type
                    (list noctalia-greeter))

                (service greetd-service-type
                    (greetd-configuration
                        (greeter-supplementary-groups '("video" "input"))
                        (terminals
                            (list
                                (greetd-terminal-configuration
                                    (extra-shepherd-requirement '(elogind))
                                    (terminal-vt "1")
                                    (default-session-command
                                        (file-append noctalia-greeter "/bin/noctalia-greeter-session")))
                                (greetd-terminal-configuration (terminal-vt "2"))
                                (greetd-terminal-configuration (terminal-vt "3"))
                                (greetd-terminal-configuration (terminal-vt "4"))
                                (greetd-terminal-configuration (terminal-vt "5"))
                                (greetd-terminal-configuration (terminal-vt "6"))))))

     ;; Perfiles de energía (power-saver / balanced / performance) por D-Bus.
     ;; Es lo que usa el control center de Noctalia. No combinar con TLP.
     (service power-profiles-daemon-service-type))

    ;; %desktop-services incluye elogind, dbus, polkit, udisks (montaje de USB),
    ;; upower, NetworkManager, NTP, accountsservice, etc.
    ;; Se quita GDM porque lo sustituye SDDM.
    (modify-services %desktop-services
      (delete gdm-service-type)
      (delete mingetty-service-type)
      ;; Sustitutos de nonguix además de los oficiales
      (guix-service-type
       config => (guix-configuration
                  (inherit config)
                  (substitute-urls
                   (append (list "https://substitutes.nonguix.org")
                           %default-substitute-urls))
                  (authorized-keys
                   (append (list %clave-nonguix)
                           %default-authorized-guix-keys)))))))

  ;; UEFI + GRUB.
  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets (list "/boot/efi"))
               (keyboard-layout %teclado)
               ;;(menu-entries
                 ;; (list
                   ;; (menu-entry
                     ;; (label "Odyssey")
                     ;; (device (uuid "AAA3-E869" 'fat))
                     ;; (chain-loader "/EFI/odyssey/grubx64.efi"))))))
		))

  (swap-devices
   (list
    (swap-space
     (target
      (uuid
       "4628d49c-2ea0-4f08-9da0-d177973133cf")))))

  (file-systems
   (cons*
    (file-system
     (mount-point "/")
     (device
      (uuid
       "77fda45f-0527-4438-bc8a-1d5188128491"
       'ext4))
     (type "ext4"))

    (file-system
     (mount-point "/boot/efi")
     (device
      (uuid "4B03-8831" 'fat32))
     (type "vfat"))

    %base-file-systems)))
