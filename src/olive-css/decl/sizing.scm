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

(define-module (olive-css decl sizing)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (sizing-classes width
                           height
                           size
                           height-multiplier
                           width-multiplier
                           prose-size))

(define width-multiplier
  (make-parameter 0.24))

(define height-multiplier
  (make-parameter 0.24))

(define prose-size
  (make-parameter "84ch"))

(define width
  (make-parameter (append (list (css-rule ".w-screen"
                                          (css-declaration 'width "100vw"))
                                (css-rule ".min-w-screen"
                                          (css-declaration 'min-width "100vw"))
                                (css-rule ".max-w-screen"
                                          (css-declaration 'max-width "100vw"))
                                (css-rule ".min-w-prose"
                                          (css-declaration 'min-width
                                                           (prose-size)))
                                (css-rule ".w-full"
                                          (css-declaration 'width "100%"))
                                (css-rule ".min-w-full"
                                          (css-declaration 'min-width "100%"))
                                (css-rule ".max-w-full"
                                          (css-declaration 'max-width "100%"))
                                (css-rule ".max-w-prose"
                                          (css-declaration 'max-width
                                                           (prose-size)))
                                (css-rule ".w-auto"
                                          (css-declaration 'width
                                                           'auto))
                                (css-rule ".min-w-auto"
                                          (css-declaration 'min-width
                                                           'auto))
                                (css-rule ".max-w-none"
                                          (css-declaration 'max-width
                                                           'none))
                                (css-rule ".w-fit"
                                          (css-declaration 'width
                                                           'fit-content))
                                (css-rule ".min-w-fit"
                                          (css-declaration 'min-width
                                                           'fit-content))
                                (css-rule ".max-w-fit"
                                          (css-declaration 'max-width
                                                           'fit-content))
                                (css-rule ".w-min"
                                          (css-declaration 'width
                                                           'min-content))
                                (css-rule ".w-max"
                                          (css-declaration 'width
                                                           'max-content))
                                (css-rule ".w-dvw"
                                          (css-declaration 'width "100dvw"))
                                (css-rule ".w-svw"
                                          (css-declaration 'width "100svw"))
                                (css-rule ".w-lvw"
                                          (css-declaration 'width "100lvw")))
                          (map (lambda (d)
                                 (css-rule-variants (string-append "."
                                                                   (format #f
                                                                    "~a"
                                                                    (car d))
                                                                   "-" "~a")
                                                    #:property (cadr d)
                                                    #:variants (append (map (lambda 
                                                                                    (s)
                                                                              
                                                                              
                                                                              (css-size
                                                                               s
                                                                               #:conversion
                                                                               to-rem
                                                                               #:multiplier
                                                                               (width-multiplier)))
                                                                            (append
                                                                             numeric-sizes
                                                                             tshirt-sizes))
                                                                       (map (lambda 
                                                                                    (s)
                                                                              
                                                                              
                                                                              (css-size
                                                                               s
                                                                               #:conversion
                                                                               identity
                                                                               #:multiplier
                                                                               (width-multiplier)))
                                                                        fractions))))
                               '((w width)
                                 (min-w min-width)
                                 (max-w max-width))))))

(define height
  (make-parameter (append (list (css-rule ".h-screen"
                                          (css-declaration 'height "100vh"))
                                (css-rule ".min-h-screen"
                                          (css-declaration 'min-height "100vh"))
                                (css-rule ".max-h-screen"
                                          (css-declaration 'max-height "100vh"))
                                (css-rule ".h-full"
                                          (css-declaration 'height "100%"))
                                (css-rule ".min-h-full"
                                          (css-declaration 'min-height "100%"))
                                (css-rule ".max-h-full"
                                          (css-declaration 'max-height "100%"))
                                (css-rule ".h-auto"
                                          (css-declaration 'height
                                                           'auto))
                                (css-rule ".min-h-auto"
                                          (css-declaration 'min-height
                                                           'auto))
                                (css-rule ".max-h-none"
                                          (css-declaration 'max-height
                                                           'none))
                                (css-rule ".h-fit"
                                          (css-declaration 'height
                                                           'fit-content))
                                (css-rule ".min-h-fit"
                                          (css-declaration 'min-height
                                                           'fit-content))
                                (css-rule ".h-min"
                                          (css-declaration 'height
                                                           'min-content))
                                (css-rule ".h-max"
                                          (css-declaration 'height
                                                           'max-content))
                                (css-rule ".h-dvh"
                                          (css-declaration 'height "100dvh"))
                                (css-rule ".min-h-dvh"
                                          (css-declaration 'min-height
                                                           "100dvh"))
                                (css-rule ".h-svh"
                                          (css-declaration 'height "100svh"))
                                (css-rule ".h-lvh"
                                          (css-declaration 'height "100lvh"))
                                (css-rule ".h-dvw"
                                          (css-declaration 'height "100dvw"))
                                (css-rule ".h-svw"
                                          (css-declaration 'height "100svw"))
                                (css-rule ".h-lvw"
                                          (css-declaration 'height "100lvw"))
                                (css-rule ".min-h-svh"
                                          (css-declaration 'min-height
                                                           "100svh"))
                                (css-rule ".min-h-lvh"
                                          (css-declaration 'min-height
                                                           "100lvh"))
                                (css-rule ".max-h-dvh"
                                          (css-declaration 'max-height
                                                           "100dvh"))
                                (css-rule ".max-h-svh"
                                          (css-declaration 'max-height
                                                           "100svh")))
                          (map (lambda (d)
                                 (css-rule-variants (string-append "."
                                                                   (format #f
                                                                    "~a"
                                                                    (car d))
                                                                   "-" "~a")
                                                    #:property (cadr d)
                                                    #:variants (append (map (lambda 
                                                                                    (s)
                                                                              
                                                                              
                                                                              (css-size
                                                                               s
                                                                               #:conversion
                                                                               to-rem
                                                                               #:multiplier
                                                                               (height-multiplier)))
                                                                            (append
                                                                             numeric-sizes
                                                                             tshirt-sizes))
                                                                       (map (lambda 
                                                                                    (s)
                                                                              
                                                                              
                                                                              (css-size
                                                                               s
                                                                               #:conversion
                                                                               identity
                                                                               #:multiplier
                                                                               (height-multiplier)))
                                                                        fractions))))
                               '((h height)
                                 (min-h min-height)
                                 (max-h max-height))))))

(define size
  (make-parameter (append (list (css-rule ".size-full"
                                          (css-declaration 'width "100%")
                                          (css-declaration 'height "100%"))
                                (css-rule ".size-auto"
                                          (css-declaration 'width
                                                           'auto)
                                          (css-declaration 'height
                                                           'auto))
                                (css-rule ".size-fit"
                                          (css-declaration 'width
                                                           'fit-content)
                                          (css-declaration 'height
                                                           'fit-content))
                                (css-rule ".size-screen"
                                          (css-declaration 'width "100vw")
                                          (css-declaration 'height "100vh")))
                          (map (lambda (s)
                                 (css-rule (format #f ".size-~a"
                                                   (car s))
                                           (css-declaration 'width
                                                            (cadr s))
                                           (css-declaration 'height
                                                            (cadr s))))
                               (delete-duplicates (append (map (lambda (s)
                                                                 (css-size s
                                                                  #:conversion
                                                                  to-rem
                                                                  #:multiplier
                                                                  (width-multiplier)))
                                                               (append
                                                                numeric-sizes
                                                                tshirt-sizes))
                                                          (map css-size
                                                               fractions))
                                                  equal?)))))

(define sizing-classes
  (make-parameter (list (width)
                        (height)
                        (size))))
