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
                                                           (prose-size))))
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
                                          (css-declaration 'max-height "100%")))
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

(define sizing-classes
  (make-parameter (list (width)
                        (height))))
