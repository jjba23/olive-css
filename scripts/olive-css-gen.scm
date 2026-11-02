;; olive-css - Utility-class CSS framework that is easy to learn and hack

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; olive-css is free software: you can redistribute it and/or modify
;; it under the terms of the Lesser GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; olive-css is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; Lesser GNU General Public License for more details.

;; You should have received a copy of the Lesser GNU General Public License
;; along with olive-css.  If not, see <https://www.gnu.org/licenses/>.

(use-modules (ice-9 string-fun)
             (ice-9 ports)
             (ice-9 textual-ports)
             (ice-9 popen)
             (olive-css main)
             (olive-css dsl)
             (olive-css sizes)
             (olive-css decl colors)
             (olive-css decl layout)
             (olive-css decl flexbox)
             (olive-css decl spacing)
             (olive-css decl sizing)
             (olive-css decl filters)
             (olive-css decl typography)
             (olive-css decl animation)
             (olive-css decl reset)
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

(define carvoeiro-water-fun-palettes
  (list (cons 'floral-white
              (floral-white))
        (cons 'lapis-lazuli
              (lapis-lazuli))
        (cons 'prussian-blue
              (prussian-blue))
        (cons 'naples-yellow
              (naples-yellow))
        (cons 'mikado-yellow
              (mikado-yellow))
        (cons 'orange
              (orange))
        (cons 'tawny
              (tawny))
        (cons 'papaya-whip
              (papaya-whip))
        (cons 'white-smoke
              (white-smoke))
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

(define torikomi-palettes
  (list (cons 'onyx
              (onyx))
        (cons 'tawny
              (tawny))
        (cons 'orange
              (orange))
        (cons 'stone
              (stone))
        (cons 'china-violet
              (china-violet))
        (cons 'prussian-blue
              (prussian-blue))
        (cons 'jeans-blue
              (jeans-blue))
        (cons 'iris
              (iris))
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

(define fatum-palettes
  (list (cons 'floral-white
              (floral-white))
        (cons 'lapis-lazuli
              (lapis-lazuli))
        (cons 'prussian-blue
              (prussian-blue))
        (cons 'white-smoke
              (white-smoke))
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

(define css-gen-tasks
  (list (lambda ()
          (log-info "Generate framework style sheet with ALL features")
          (write-css-to-file #:file "./resources/css/olive.min.css"
                             #:css-lines (parameterize ((responsive-classes (append
                                                                             (core-utility-classes)
                                                                             (color-base-classes
                                                                              (palettes)))))
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
          (log-info "Generate Carvoeiro Water Fun framework style sheet")
          (write-css-to-file #:file
           "./resources/css/carvoeiro-water-fun.olive.min.css"
           #:css-lines (parameterize ((responsive reduced-responsive)
                                      (palettes carvoeiro-water-fun-palettes))
                         (olive-css-gen))))

        (lambda ()
          (log-info "Generate Torikomi framework style sheet")
          (write-css-to-file #:file "./resources/css/torikomi.olive.min.css"
                             #:css-lines (parameterize ((responsive
                                                         reduced-responsive)
                                                        (palettes
                                                         torikomi-palettes))
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
          (log-info "Generate Fatum (Iter Vitae) framework style sheet")
          (write-css-to-file #:file "./resources/css/fatum.olive.min.css"
                             #:css-lines (parameterize ((responsive
                                                         reduced-responsive)
                                                        (responsive-classes (append
                                                                             (layout-classes)
                                                                             (filter-classes)
                                                                             (flexbox-classes)
                                                                             (spacing-classes)
                                                                             (sizing-classes)
                                                                             (typography-classes)
                                                                             (border-radius)
                                                                             (scroll-snap-aligns)
                                                                             (scroll-snap-types)
                                                                             (colors
                                                                              fatum-palettes)
                                                                             (font-family)))
                                                        (palettes
                                                         fatum-palettes))
                                           (olive-css-gen))))

        (lambda ()
          (log-info "Generate Wikimusic framework style sheet")
          (write-css-to-file #:file "./resources/css/wikimusic.olive.min.css"
                             #:css-lines (parameterize ((responsive
                                                         reduced-responsive)
                                                        (palettes
                                                         wikimusic-palettes))
                                           (olive-css-gen))))))

(call-with-input-file "./resources/banner.txt"
  (lambda (port)
    (display (get-string-all port))))

(for-each (lambda (f)
            (apply f
                   '())) css-gen-tasks)
