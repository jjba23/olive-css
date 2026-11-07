;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; The stylesheets this repository ships.  Each build is a name, the file it
;;; is written to, a thunk that generates its CSS lines, and a one-line
;;; description the CLI prints.  Projects that use Olive CSS copy one of these
;;; and change its palette and feature set; the CLI builds every entry here so
;;; `maak build' regenerates all of them in one call.
;;;
;;;
;;; Code:

(define-module (olive-css builds)
  #:use-module (olive-css main)
  #:use-module (olive-css sizes)
  #:use-module (olive-css decl colors)
  #:use-module (olive-css decl layout)
  #:use-module (olive-css decl flexbox)
  #:use-module (olive-css decl spacing)
  #:use-module (olive-css decl sizing)
  #:use-module (olive-css decl filters)
  #:use-module (olive-css decl typography)
  #:export (build-specs build-names build-file build-css))

(define rc-huidkliniek-palettes
  (list (cons 'floral-white (floral-white))
        (cons 'china-rose (china-rose))
        (cons 'wine (wine))
        (cons 'redwood (redwood))
        (cons 'spiced-terracotta (spiced-terracotta))
        (cons 'terra (terra))
        (cons 'onyx (onyx))
        (cons 'stone (stone))
        (cons 'jeans-blue (jeans-blue))
        (cons 'asparagus (asparagus))))

(define lucidplan-palettes
  (list (cons 'floral-white (floral-white))
        (cons 'onyx (onyx))
        (cons 'stone (stone))
        (cons 'redwood (redwood))
        (cons 'jeans-blue (jeans-blue))
        (cons 'olive (olive))
        (cons 'asparagus (asparagus))))

(define carvoeiro-water-fun-palettes
  (list (cons 'floral-white (floral-white))
        (cons 'lapis-lazuli (lapis-lazuli))
        (cons 'prussian-blue (prussian-blue))
        (cons 'naples-yellow (naples-yellow))
        (cons 'mikado-yellow (mikado-yellow))
        (cons 'orange (orange))
        (cons 'tawny (tawny))
        (cons 'papaya-whip (papaya-whip))
        (cons 'white-smoke (white-smoke))
        (cons 'onyx (onyx))
        (cons 'stone (stone))
        (cons 'redwood (redwood))
        (cons 'jeans-blue (jeans-blue))
        (cons 'olive (olive))
        (cons 'asparagus (asparagus))))

(define byggsteg-palettes
  (list (cons 'onyx (onyx))
        (cons 'tawny (tawny))
        (cons 'orange (orange))
        (cons 'stone (stone))
        (cons 'redwood (redwood))
        (cons 'jeans-blue (jeans-blue))
        (cons 'olive (olive))
        (cons 'asparagus (asparagus))))

(define torikomi-palettes
  (list (cons 'onyx (onyx))
        (cons 'tawny (tawny))
        (cons 'orange (orange))
        (cons 'stone (stone))
        (cons 'china-violet (china-violet))
        (cons 'prussian-blue (prussian-blue))
        (cons 'jeans-blue (jeans-blue))
        (cons 'iris (iris))
        (cons 'asparagus (asparagus))))

(define wikimusic-palettes
  (list (cons 'onyx (onyx))
        (cons 'stone (stone))
        (cons 'china-violet (china-violet))
        (cons 'persia-pink (persia-pink))
        (cons 'redwood (redwood))
        (cons 'jeans-blue (jeans-blue))
        (cons 'asparagus (asparagus))))

(define iter-vitae-palettes
  (list (cons 'onyx (onyx))
        (cons 'stone (stone))
        (cons 'china-violet (china-violet))
        (cons 'persia-pink (persia-pink))
        (cons 'redwood (redwood))
        (cons 'jeans-blue (jeans-blue))
        (cons 'asparagus (asparagus))))

(define fatum-palettes
  (list (cons 'floral-white (floral-white))
        (cons 'lapis-lazuli (lapis-lazuli))
        (cons 'prussian-blue (prussian-blue))
        (cons 'white-smoke (white-smoke))
        (cons 'onyx (onyx))
        (cons 'stone (stone))
        (cons 'redwood (redwood))
        (cons 'jeans-blue (jeans-blue))
        (cons 'olive (olive))
        (cons 'asparagus (asparagus))))

(define (full-build)
  "Every utility, with responsive color parity and dark mode."
  (parameterize ((responsive-classes (append (core-utility-classes)
                                             (color-base-classes
                                              (palettes)))))
    (olive-css-gen)))

(define (rc-huidkliniek-build)
  "No dark mode, a reduced responsive set, Fraunces headings and its palette."
  (parameterize ((responsive reduced-responsive)
                 (with-dark-mode? #f)
                 (serif-font-family '("'Fraunces'" "ui-serif" "serif"
                                      "'Times New Roman'"))
                 (palettes rc-huidkliniek-palettes))
    (olive-css-gen)))

(define (lucidplan-build)
  (parameterize ((responsive reduced-responsive)
                 (palettes lucidplan-palettes))
    (olive-css-gen)))

(define (byggsteg-build)
  (parameterize ((responsive reduced-responsive)
                 (palettes byggsteg-palettes))
    (olive-css-gen)))

(define (carvoeiro-water-fun-build)
  (parameterize ((responsive reduced-responsive)
                 (palettes carvoeiro-water-fun-palettes))
    (olive-css-gen)))

(define (torikomi-build)
  (parameterize ((responsive reduced-responsive)
                 (palettes torikomi-palettes))
    (olive-css-gen)))

(define (iter-vitae-build)
  (parameterize ((responsive reduced-responsive)
                 (palettes iter-vitae-palettes))
    (olive-css-gen)))

(define (fatum-build)
  "Reduced responsive set over the families Fatum actually uses."
  (parameterize ((responsive reduced-responsive)
                 (responsive-classes
                  (append (layout-classes)
                          (filter-classes)
                          (flexbox-classes)
                          (spacing-classes)
                          (sizing-classes)
                          (typography-classes)
                          (border-radius)
                          (scroll-snap-aligns)
                          (scroll-snap-types)
                          (colors fatum-palettes)
                          (font-family)))
                 (palettes fatum-palettes))
    (olive-css-gen)))

(define (wikimusic-build)
  (parameterize ((responsive reduced-responsive)
                 (palettes wikimusic-palettes))
    (olive-css-gen)))

;; Name, output file, generator and the line `olive-css list' prints.
(define build-specs
  (list (list "full"
              "resources/css/olive.min.css"
              full-build
              "every utility, full responsive parity and dark mode")
        (list "rc-huidkliniek"
              "resources/css/rc-huidkliniek.olive.min.css"
              rc-huidkliniek-build
              "no dark mode, Fraunces headings and its palette")
        (list "lucidplan"
              "resources/css/lucidplan.olive.min.css"
              lucidplan-build
              "lean responsive set and the Lucidplan palette")
        (list "byggsteg"
              "resources/css/byggsteg.olive.min.css"
              byggsteg-build
              "lean responsive set and the Byggsteg palette")
        (list "carvoeiro-water-fun"
              "resources/css/carvoeiro-water-fun.olive.min.css"
              carvoeiro-water-fun-build
              "lean responsive set and the Carvoeiro Water Fun palette")
        (list "torikomi"
              "resources/css/torikomi.olive.min.css"
              torikomi-build
              "lean responsive set and the Torikomi palette")
        (list "iter-vitae"
              "resources/css/iter-vitae.olive.min.css"
              iter-vitae-build
              "lean responsive set and the Iter Vitae palette")
        (list "fatum"
              "resources/css/fatum.olive.min.css"
              fatum-build
              "lean responsive set over Fatum's families and palette")
        (list "wikimusic"
              "resources/css/wikimusic.olive.min.css"
              wikimusic-build
              "lean responsive set and the Wikimusic palette")))

(define (build-names)
  "The names of every shipped build."
  (map car build-specs))

(define (build-file name)
  "The output file NAME writes, or #f when NAME is not a build."
  (let ((spec (assoc name build-specs)))
    (and spec (cadr spec))))

(define (build-css name)
  "The CSS lines of build NAME, or #f when NAME is not a build."
  (let ((spec (assoc name build-specs)))
    (and spec ((caddr spec)))))
