(use-modules (ice-9 string-fun)
             (ice-9 ports)
             (ice-9 textual-ports)
             (ice-9 popen)
             (olive-css hss)
             (olive-css dsl)
             (olive-css decl colors))

(define hss-dest-file
  "./resources/css/olive.min.css")

(define hss-rc-huidkliniek-dest-file
  "./resources/css/rc-huidkliniek.olive.min.css")

;; generate entire HSS
(let* ((all-hss (hss)))
  (catch #t
         (lambda ()
           (delete-file hss-dest-file))
         (lambda _
           (display "")))
  (with-output-to-file hss-dest-file
    (lambda ()
      (display (string-join (flatten-list (map format-css all-hss)) "\n")))))

;; generate RC Huidkliniek HSS
(let* ((all-hss (parameterize ((responsive reduced-responsive)
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
                  (hss))))
  (catch #t
         (lambda ()
           (delete-file hss-rc-huidkliniek-dest-file))
         (lambda _
           (display "")))
  (with-output-to-file hss-rc-huidkliniek-dest-file
    (lambda ()
      (display (string-join (flatten-list (map format-css all-hss)) "\n")))))

