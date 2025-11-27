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

(define iter-vitae-palettes
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
              (asparagus))
        
        ))

(define documentation-intro-lines
  (param (list
          "#+title: Olive CSS Documentation
#+language: en

🚧 Work in progress

* 🫒 Welcome to Olive CSS

Olive CSS is a utility-class CSS framework designed for rapid, flexible web development, drawing inspiration from Tailwind CSS and other frameworks. It's unique because it's written entirely in Lisp (Guile Scheme), making it exceptionally hackable, transparent, and aligned with Free Software principles.

Here you'll find the resources here to build fast, beautiful, and freedom-respecting web projects with utility-class CSS. 
")))

(define* (mk-docs-from-css lines)
  (let* ((dynamic-lines (map (lambda (cl)
                               (cond
                                 ((and (rule? cl)
                                       (string-prefix? ".font-"
                                                       (format #f "~a"
                                                               (rule-selector
                                                                cl))))
                                  (list "#+begin_src css" cl "#+end_src\n"))

                                 ((and (rule? cl)
                                       (string-prefix? ".text-"
                                                       (format #f "~a"
                                                               (rule-selector
                                                                cl))))
                                  (list "#+begin_src css" cl "#+end_src\n"))
                                 (else '()))) lines))
         (lines (append (documentation-intro-lines) dynamic-lines)))
    lines))

(define css-gen-tasks
  (list (lambda ()
          (let* ((css-lines (olive-css-gen)))
            (log-info "Generate framework style sheet with ALL features")
            (write-css-to-file #:file "./resources/css/olive.min.css"
                               #:css-lines css-lines)
            (write-docs-to-file #:file "./docs/olive/olive.org"
                                #:lines (mk-docs-from-css css-lines))))

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
          (log-info "Generate Iter Vitae framework style sheet")
          (write-css-to-file #:file "./resources/css/iter-vitae.olive.min.css"
                             #:css-lines (parameterize ((responsive
                                                         reduced-responsive)
                                                        (palettes
                                                         iter-vitae-palettes))
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

