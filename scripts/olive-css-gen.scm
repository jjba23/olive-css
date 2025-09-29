(use-modules (ice-9 string-fun)
             (ice-9 ports)
             (ice-9 textual-ports)
             (ice-9 popen)
             (olive-css main)
             (olive-css dsl)
             (olive-css decl colors))

(define dest-file
  "./resources/css/olive.min.css")

(define rc-huidkliniek-dest-file
  "./resources/css/rc-huidkliniek.olive.min.css")

;; generate framework style sheet with ALL features
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

;; generate RC Huidkliniek framework style sheet
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

