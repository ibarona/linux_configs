;; ~/.config/guix/channels.scm
;; (también se usa con `guix time-machine -C channels.scm` durante la instalación)

(cons* (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (introduction
         (make-channel-introduction
          "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
          (openpgp-fingerprint
           "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))

       (channel
         (name 'midnight)
         (url "https://codeberg.org/stampede/midnight.git")
         (branch "main")
         (introduction
             (make-channel-introduction
                 "d97d1568954cfcbf543c9fcdfd5771e2b730ae19"
                 (openpgp-fingerprint
                     "640A 2C3C E948 22D3 394B 40C3 CAFA EECA 00FF 9B1E"))))


       ;; Canal oficial de Noctalia: aporta el módulo (noctalia) con el
       ;; paquete `noctalia-git` (Noctalia v5). Sin sustitutos: se compila en local.
       ;; Si quieres builds reproducibles, fija un commit añadiendo (commit "...").
       ;;(channel
       ;; (name 'noctalia)
       ;; (url "https://github.com/noctalia-dev/noctalia")
       ;; (branch "main"))

       %default-channels)
