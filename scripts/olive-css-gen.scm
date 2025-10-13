(use-modules (ice-9 string-fun)
             (ice-9 ports)
             (ice-9 textual-ports)
             (ice-9 popen)
             (olive-css main)
             (olive-css dsl)
             (olive-css decl colors))

(define (log-info msg)
  (format #t "\n[INFO] ~a" msg))

(define rc-huidkliniek-palettes
  (list (cons 'floral-white
              (floral-white))
        (cons 'china-rose
              (china-rose))
        (cons 'wine
              (wine))
        (cons 'redwood
              (redwood))
        (cons 'spiced-terracotta
              (spiced-terracotta))
        (cons 'terra
              (terra))
        (cons 'onyx
              (onyx))
        (cons 'stone
              (stone))
        (cons 'jeans-blue
              (jeans-blue))
        (cons 'asparagus
              (asparagus))))

(define lucidplan-palettes
  (list (cons 'floral-white
              (floral-white))
        (cons 'onyx
              (onyx))
        (cons 'stone
              (stone))
        (cons 'redwood
              (redwood))
        (cons 'jeans-blue
              (jeans-blue))
        (cons 'olive
              (olive))
        (cons 'asparagus
              (asparagus))))

(define byggsteg-palettes
  (list (cons 'onyx
              (onyx))
        (cons 'tawny
              (tawny))
        (cons 'orange
              (orange))
        (cons 'stone
              (stone))
        (cons 'redwood
              (redwood))
        (cons 'jeans-blue
              (jeans-blue))
        (cons 'olive
              (olive))
        (cons 'asparagus
              (asparagus))))

(define wikimusic-palettes
  (list (cons 'onyx
              (onyx))
        (cons 'stone
              (stone))
        (cons 'china-violet
              (china-violet))
        (cons 'persia-pink
              (persia-pink))
        (cons 'redwood
              (redwood))
        (cons 'jeans-blue
              (jeans-blue))
        (cons 'asparagus
              (asparagus))))

(define css-gen-tasks
  (list (lambda ()
          (log-info "Generate framework style sheet with ALL features")
          (write-css-to-file #:file "./resources/css/olive.min.css"
                             #:css-lines (begin
                                           (olive-css-gen))))

        (lambda ()
          (log-info "Generate RC Huidkliniek framework style sheet")
          (write-css-to-file #:file
                             "./resources/css/rc-huidkliniek.olive.min.css"
                             #:css-lines (parameterize ((responsive
                                                         reduced-responsive)
                                                        (with-dark-mode? #f)
                                                        (serif-font-family '("'Fraunces'"
                                                                             "ui-serif"
                                                                             "serif"
                                                                             "'Times New Roman'"))
                                                        (sans-font-family '("'Plus Jakarta Sans'"
                                                                            "ui-sans-serif"
                                                                            "system-ui"
                                                                            "sans-serif"
                                                                            "'Apple Color Emoji'"
                                                                            "'Segoe UI Emoji'"
                                                                            "'Segoe UI Symbol'"
                                                                            "'Noto Color Emoji'"))
                                                        (palettes
                                                         rc-huidkliniek-palettes))
                                           (olive-css-gen))))

        (lambda ()
          (log-info "Generate Lucidplan framework style sheet")
          (write-css-to-file #:file "./resources/css/lucidplan.olive.min.css"
                             #:css-lines (parameterize ((responsive
                                                         reduced-responsive)
                                                        (palettes
                                                         lucidplan-palettes))
                                           (olive-css-gen))))

        (lambda ()
          (log-info "Generate Byggsteg framework style sheet")
          (write-css-to-file #:file "./resources/css/byggsteg.olive.min.css"
                             #:css-lines (parameterize ((responsive
                                                         reduced-responsive)
                                                        (palettes
                                                         byggsteg-palettes))
                                           (olive-css-gen))))

        (lambda ()
          (log-info "Generate Wikimusic framework style sheet")
          (write-css-to-file #:file "./resources/css/wikimusic.olive.min.css"
                             #:css-lines (parameterize ((responsive
                                                         reduced-responsive)
                                                        (palettes
                                                         wikimusic-palettes))
                                           (olive-css-gen))))))

(for-each (lambda (f)
            (apply f
                   '())) css-gen-tasks)

