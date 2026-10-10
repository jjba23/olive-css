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

(define-module (olive-css decl typography)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (typography-classes text-wrap
                               text-underline-offset
                               text-transform
                               font-smoothing
                               white-space
                               font-variant-numeric
                               word-break
                               text-decoration-style
                               list-style-type
                               text-overflow
                               overflow-wrap
                               hyphens
                               font-stretch
                               weight-multiplier
                               text-decoration-line
                               text-decoration-thickness
                               text-indent
                               letter-spacing
                               line-clamp
                               font-size-multiplier
                               font-style
                               font-weight
                               font-size
                               leading
                               line-height-multiplier
                               list-style-position
                               text-align))

(define font-size-multiplier
  (make-parameter 0.25))

(define line-height-multiplier
  (make-parameter 0.25))

(define weight-multiplier
  (make-parameter 1))

(define font-weight
  (make-parameter (css-rule-variants ".font-~a"
                                     #:property 'font-weight
                                     #:variants weights)))

(define font-size
  (make-parameter (css-rule-variants ".text-~a"
                                     #:property 'font-size
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion
                                                                 to-rem
                                                                 #:multiplier (font-size-multiplier)))
                                                     (append tshirt-sizes
                                                             numeric-sizes)))))

(define text-align
  (make-parameter (css-rule-variants ".text-~a"
                                     #:property 'text-align
                                     #:variants '((center center)
                                                  (left left)
                                                  (right right)
                                                  (justify justify)
                                                  (start start)
                                                  (end end)))))

(define letter-spacing
  (make-parameter (css-rule-variants ".tracking-~a"
                                     #:property 'letter-spacing
                                     #:variants trackings)))

(define font-style
  (make-parameter (list (css-rule ".italic"
                                  (css-declaration 'font-style
                                                   'italic))
                        (css-rule ".not-italic"
                                  (css-declaration 'font-style
                                                   'normal)))))

(define font-smoothing
  (make-parameter (list (css-rule ".antialiased"
                                  (css-declaration "-webkit-font-smoothing"
                                                   "antialiased")
                                  (css-declaration "-moz-osx-font-smoothing"
                                                   "grayscale"))
                        (css-rule ".subpixel-antialiased"
                                  (css-declaration "-webkit-font-smoothing"
                                                   "auto")
                                  (css-declaration "-moz-osx-font-smoothing"
                                                   "auto")))))

(define font-stretch
  (make-parameter (css-rule-variants ".font-stretch-~a"
                                     #:property 'font-stretch
                                     #:variants stretches)))

(define font-variant-numeric
  (make-parameter (css-rule-variants ".~a"
                                     #:property 'font-variant-numeric
                                     #:variants numeric-variants)))

(define line-clamp
  (make-parameter (css-rule-variants ".line-clamp-~a"
                                     #:property "-webkit-line-clamp"
                                     #:other-properties '((overflow hidden)
                                                          (display
                                                           "-webkit-box")
                                                          ("-webkit-box-orient"
                                                           vertical))
                                     #:variants positive-numeric-sizes)))

(define leading
  (make-parameter (list (css-rule ".leading-none"
                                  (css-declaration 'line-height 1))
                        (css-rule-variants ".leading-~a"
                                           #:property 'line-height
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       to-rem
                                                                       #:multiplier
                                                                       (line-height-multiplier)))
                                                           (append
                                                            tshirt-sizes
                                                            numeric-sizes))))))

(define list-style-type
  (make-parameter (list (css-rule-variants ".list-~a"
                                           #:property 'list-style-type
                                           #:variants '((disc disc)
                                                        (decimal decimal)
                                                        (none none))))))

(define list-style-position
  (make-parameter (list (css-rule-variants ".list-~a"
                                           #:property 'list-style-position
                                           #:variants '((inside inside)
                                                        (outside outside))))))

(define text-decoration-line
  (make-parameter (css-rule-variants ".~a"
                                     #:property 'text-decoration-line
                                     #:variants '((underline underline)
                                                  (overline overline)
                                                  (line-through line-through)
                                                  (no-underline none)))))

(define text-decoration-thickness
  (make-parameter (append (css-rule-variants ".decoration-~a"
                                             #:property 'text-decoration-thickness
                                             #:variants '((auto auto)
                                                          (from-font from-font)))
                          (css-rule-variants ".decoration-~a"
                                             #:property 'text-decoration-thickness
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-px))
                                                             '((0 0)
                                                               (1 1)
                                                               (2 2)
                                                               (4 4)
                                                               (8 8)))))))

(define text-indent
  (make-parameter (append (list (css-rule ".indent-px"
                                          (css-declaration 'text-indent "1px")))
                          (css-rule-variants ".indent-~a"
                                             #:property 'text-indent
                                             #:variants (map (lambda (s)
                                                               (css-size s
                                                                #:conversion
                                                                to-rem))
                                                             (append
                                                              numeric-sizes
                                                              tshirt-sizes))))))

(define text-decoration-style
  (make-parameter (css-rule-variants ".decoration-~a"
                                     #:property 'text-decoration-style
                                     #:variants '((solid solid)
                                                  (double double)
                                                  (dotted dotted)
                                                  (dashed dashed)
                                                  (wavy wavy)))))

(define text-underline-offset
  (make-parameter (list (css-rule ".underline-offset-auto"
                                  (css-declaration 'text-underline-offset
                                                   'auto))
                        (css-rule-variants ".underline-offset-~a"
                                           #:property 'text-underline-offset
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       to-rem
                                                                       #:multiplier
                                                                       (line-height-multiplier)))
                                                           (append
                                                            tshirt-sizes
                                                            numeric-sizes))))))

(define text-transform
  (make-parameter (css-rule-variants ".~a"
                                     #:property 'text-transform
                                     #:variants '((uppercase uppercase)
                                                  (lowercase lowercase)
                                                  (capitalize capitalize)
                                                  (normal-case none)))))

(define text-overflow
  (make-parameter (list (css-rule ".truncate"
                                  (css-declaration 'overflow
                                                   'hidden)
                                  (css-declaration 'text-overflow
                                                   'ellipsis)
                                  (css-declaration 'white-space
                                                   'nowrap))
                        (css-rule ".text-ellipsis"
                                  (css-declaration 'text-overflow
                                                   'ellipsis))
                        (css-rule ".text-clip"
                                  (css-declaration 'text-overflow
                                                   'clip)))))

(define text-wrap
  (make-parameter (css-rule-variants ".text-~a"
                                     #:property 'text-wrap
                                     #:variants '((wrap wrap)
                                                  (nowrap nowrap)
                                                  (balance balance)
                                                  (pretty pretty)))))

(define white-space
  (make-parameter (css-rule-variants ".whitespace-~a"
                                     #:property 'white-space
                                     #:variants '((normal normal)
                                                  (nowrap nowrap)
                                                  (pre pre)
                                                  (pre-line pre-line)
                                                  (pre-wrap pre-wrap)
                                                  (break-spaces break-spaces)))))

(define word-break
  (make-parameter (css-rule-variants ".break-~a"
                                     #:property 'word-break
                                     #:variants '((normal normal)
                                                  (all break-all)
                                                  (keep keep-all)))))

(define overflow-wrap
  (make-parameter (css-rule-variants ".wrap-~a"
                                     #:property 'overflow-wrap
                                     #:variants '((break-word break-word)
                                                  (anywhere anywhere)
                                                  (normal normal)))))

(define hyphens
  (make-parameter (css-rule-variants ".hyphens-~a"
                                     #:property 'hyphens
                                     #:variants '((none none)
                                                  (manual manual)
                                                  (auto auto)))))

(define vertical-align
  (make-parameter (css-rule-variants ".align-~a"
                                     #:property 'vertical-align
                                     #:variants '((baseline baseline)
                                                  (top top)
                                                  (middle middle)
                                                  (bottom bottom)
                                                  (text-top text-top)
                                                  (text-bottom text-bottom)
                                                  (sub sub)
                                                  (super super)))))

(define typography-classes
  (make-parameter (list (font-weight)
                        (font-size)
                        (font-style)
                        (text-align)
                        (font-stretch)
                        (font-smoothing)
                        (line-clamp)
                        (leading)
                        (list-style-type)
                        (list-style-position)
                        (font-variant-numeric)
                        (text-decoration-line)
                        (text-decoration-thickness)
                        (text-indent)
                        (text-decoration-style)
                        (text-underline-offset)
                        (text-transform)
                        (text-overflow)
                        (text-wrap)
                        (white-space)
                        (word-break)
                        (overflow-wrap)
                        (hyphens)
                        (vertical-align)
                        (letter-spacing))))
