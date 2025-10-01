(use-modules (ice-9 string-fun)
             (ice-9 ports)
             (ice-9 textual-ports)
             (ice-9 popen)
             (olive-css main)
             (olive-css dsl)
             (olive-css decl colors))

(define (log-info msg)
  (format #t "\n[INFO] ~a" msg))

(define dest-file
  "./resources/css/olive.min.css")

(define rc-huidkliniek-dest-file
  "./resources/css/rc-huidkliniek.olive.min.css")

(define lucidplan-dest-file
  "./resources/css/lucidplan.olive.min.css")

(define byggsteg-dest-file
  "./resources/css/byggsteg.olive.min.css")

(log-info "Generate framework style sheet with ALL features")
(let* ((complete-olive-css (olive-css-gen)))
  (catch #t
         (lambda ()
           (delete-file dest-file))
         (lambda _
           (display "")))
  (with-output-to-file dest-file
    (lambda ()
      (display (string-join (flatten-list (map format-css complete-olive-css))
                            "\n")))))

(log-info "Generate RC Huidkliniek framework style sheet")
(let* ((rc-huidkliniek-olive-css (parameterize ((responsive reduced-responsive)
                                                (with-dark-mode? #f)
                                                (palettes (list (cons 'floral-white
                                                                      (floral-white))
                                                                (cons 'china-rose
                                                                      (china-rose))
                                                                (cons 'wine
                                                                      (wine))
                                                                (cons 'bistre
                                                                      (bistre))
                                                                (cons 'redwood
                                                                      (redwood))
                                                                (cons 'spiced-terracotta
                                                                      (spiced-terracotta))
                                                                (cons 'papaya-whip
                                                                      (papaya-whip))
                                                                (cons 'onyx
                                                                      (onyx))
                                                                (cons 'stone
                                                                      (stone))
                                                                (cons 'jeans-blue
                                                                      (jeans-blue))
                                                                (cons 'asparagus
                                                                      (asparagus)))))
                                   (olive-css-gen))))
  (catch #t
         (lambda ()
           (delete-file rc-huidkliniek-dest-file))
         (lambda _
           (display "")))
  (with-output-to-file rc-huidkliniek-dest-file
    (lambda ()
      (display (string-join (flatten-list (map format-css
                                               rc-huidkliniek-olive-css)) "\n")))))

(log-info "Generate Lucidplan framework style sheet")
(let* ((lucidplan-olive-css (parameterize ((responsive reduced-responsive)
                                           (palettes (list (cons 'floral-white
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
                                                                 (asparagus)))))
                              (olive-css-gen))))
  (catch #t
         (lambda ()
           (delete-file lucidplan-dest-file))
         (lambda _
           (display "")))
  (with-output-to-file lucidplan-dest-file
    (lambda ()
      (display (string-join (flatten-list (map format-css lucidplan-olive-css))
                            "\n")))))

(log-info "Generate Byggsteg framework style sheet")
(let* ((byggsteg-olive-css (parameterize ((responsive reduced-responsive)
                                          (palettes (list (cons 'onyx
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
                                                                (asparagus)))))
                             (olive-css-gen))))
  (catch #t
         (lambda ()
           (delete-file byggsteg-dest-file))
         (lambda _
           (display "")))
  (with-output-to-file byggsteg-dest-file
    (lambda ()
      (display (string-join (flatten-list (map format-css byggsteg-olive-css))
                            "\n")))))
