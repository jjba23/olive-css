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
  #:export (sizing-classes width height height-multiplier width-multiplier
                           prose-size))

(define width-multiplier
  (param 0.24))

(define height-multiplier
  (param 0.24))

(define prose-size
  (param "84ch"))

(define width
  (param (append (list (rul ".w-screen"
                            (dec 'width "100vw"))
                       (rul ".min-w-screen"
                            (dec 'min-width "100vw"))
                       (rul ".max-w-screen"
                            (dec 'max-width "100vw"))
                       (rul ".min-w-prose"
                            (dec 'min-width
                                 (prose-size)))
                       (rul ".w-full"
                            (dec 'width "100%"))
                       (rul ".min-w-full"
                            (dec 'min-width "100%"))
                       (rul ".max-w-full"
                            (dec 'max-width "100%"))
                       (rul ".max-w-prose"
                            (dec 'max-width
                                 (prose-size))))
                 (map (lambda (d)
                        (rulv (string-append "."
                                             (format #f "~a"
                                                     (car d)) "-" "~a")
                              #:property (cadr d)
                              #:variants (append (map (lambda (s)
                                                        (siz s
                                                             #:conversion
                                                             to-rem
                                                             #:multiplier (width-multiplier)))
                                                      (append numeric-sizes
                                                              tshirt-sizes))
                                                 (map (lambda (s)
                                                        (siz s
                                                             #:conversion
                                                             identity
                                                             #:multiplier (width-multiplier)))
                                                      fractions))))
                      '((w width)
                        (min-w min-width)
                        (max-w max-width))))))

(define height
  (param (append (list (rul ".h-screen"
                            (dec 'height "100vh"))
                       (rul ".min-h-screen"
                            (dec 'min-height "100vh"))
                       (rul ".max-h-screen"
                            (dec 'max-height "100vh"))
                       (rul ".h-full"
                            (dec 'height "100%"))                       
                       (rul ".min-h-full"
                            (dec 'min-height "100%"))
                       (rul ".max-h-full"
                            (dec 'max-height "100%")))
                 (map (lambda (d)
                        (rulv (string-append "."
                                             (format #f "~a"
                                                     (car d)) "-" "~a")
                              #:property (cadr d)
                              #:variants (append (map (lambda (s)
                                                        (siz s
                                                             #:conversion
                                                             to-rem
                                                             #:multiplier (height-multiplier)))
                                                      (append numeric-sizes
                                                              tshirt-sizes))
                                                 (map (lambda (s)
                                                        (siz s
                                                             #:conversion
                                                             identity
                                                             #:multiplier (height-multiplier)))
                                                      fractions))))
                      '((h height)
                        (min-h min-height)
                        (max-h max-height))))))

(define sizing-classes
  (param (list (width)
               (height))))
