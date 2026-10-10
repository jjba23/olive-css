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

(define-module (olive-css decl layout)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (aspect-ratio columns
                         z-index
                         absolute-positions
                         inset-positions
                         breaks
                         accessibility
                         displays
                         visibility
                         box-decoration-break
                         float
                         clear
                         isolation
                         object-fit
                         object-position
                         overflow
                         overflow-x
                         overflow-y
                         overscroll-behavior
                         overscroll-behavior-x
                         overscroll-behavior-y
                         position
                         absolute-positions-multiplier
                         layout-classes))

(define absolute-positions-multiplier
  (make-parameter 0.4))

(define aspect-ratio
  (make-parameter (css-rule-variants ".aspect-~a"
                                     #:property 'aspect-ratio
                                     #:variants '((square "1 / 1")
                                                  (video "16 / 9")
                                                  (auto auto)
                                                  ("16\\/9" "16 / 9")
                                                  ("16\\/10" "16 / 10")
                                                  ("4\\/3" "4 / 3")
                                                  ("3\\/2" "3 / 2")
                                                  ("2\\/3" "2 / 3")))))

(define columns
  (make-parameter (css-rule-variants ".columns-~a"
                                     #:property 'columns
                                     #:variants (append tshirt-sizes
                                                        numeric-sizes))))

(define z-index
  (make-parameter (append (css-rule-variants ".z-~a"
                                             #:property 'z-index
                                             #:variants numeric-sizes)
                          (list (css-rule ".z-auto"
                                          (css-declaration 'z-index
                                                           'auto))))))

(define absolute-positions
  (make-parameter (map (lambda (d)
                         (css-rule-variants (string-append "."
                                                           (format #f "~a" d)
                                                           "-" "~a")
                                            #:property d
                                            #:variants (append (map (lambda (s)
                                                                      (css-size
                                                                       s
                                                                       #:conversion
                                                                       to-rem
                                                                       #:multiplier
                                                                       (absolute-positions-multiplier)))
                                                                numeric-sizes)
                                                               '((0 0))
                                                               (map css-size
                                                                    fractions))))
                       '(top bottom left right)))

  )

(define (positioned-values)
  "Numeric, zero and fractional offset values shared by inset utilities."
  (append (map (lambda (s)
                 (css-size s
                           #:conversion
                           to-rem
                           #:multiplier
                           (absolute-positions-multiplier)))
               numeric-sizes)
          '((0 0))
          (map css-size fractions)))

(define inset-positions
  (make-parameter (append (css-rule-variants ".inset-~a"
                                             #:property 'inset
                                             #:variants (positioned-values))
                          (css-rule-variants ".inset-x-~a"
                                             #:property 'inset-inline
                                             #:variants (positioned-values))
                          (css-rule-variants ".inset-y-~a"
                                             #:property 'inset-block
                                             #:variants (positioned-values))
                          (css-rule-variants ".start-~a"
                                             #:property 'inset-inline-start
                                             #:variants (positioned-values))
                          (css-rule-variants ".end-~a"
                                             #:property 'inset-inline-end
                                             #:variants (positioned-values))
                          (css-rule-variants ".inset-~a"
                                             #:property 'inset
                                             #:variants '((auto auto)))
                          (css-rule-variants ".start-~a"
                                             #:property 'inset-inline-start
                                             #:variants '((auto auto)))
                          (css-rule-variants ".end-~a"
                                             #:property 'inset-inline-end
                                             #:variants '((auto auto))))))

(define breaks
  (make-parameter (append (css-rule-variants ".break-after-~a"
                                             #:property 'break-after
                                             #:variants '((auto auto)
                                                          (avoid avoid)
                                                          (all all)
                                                          (avoid-page
                                                           avoid-page)
                                                          (page page)
                                                          (left left)
                                                          (right right)
                                                          (column column)))
                          (css-rule-variants ".break-before-~a"
                                             #:property 'break-before
                                             #:variants '((auto auto)
                                                          (avoid avoid)
                                                          (all all)
                                                          (avoid-page
                                                           avoid-page)
                                                          (page page)
                                                          (left left)
                                                          (right right)
                                                          (column column)))
                          (css-rule-variants ".break-inside-~a"
                                             #:property 'break-inside
                                             #:variants '((auto auto)
                                                          (avoid avoid)
                                                          (avoid-page
                                                           avoid-page)
                                                          (avoid-column
                                                           avoid-column))))))

(define accessibility
  (make-parameter (list (css-rule ".sr-only"
                                  (css-declaration 'position 'absolute)
                                  (css-declaration 'width "1px")
                                  (css-declaration 'height "1px")
                                  (css-declaration 'padding 0)
                                  (css-declaration 'margin "-1px")
                                  (css-declaration 'overflow 'hidden)
                                  (css-declaration 'clip
                                                   "rect(0, 0, 0, 0)")
                                  (css-declaration 'white-space 'nowrap)
                                  (css-declaration 'border-width 0))
                        (css-rule ".not-sr-only"
                                  (css-declaration 'position 'static)
                                  (css-declaration 'width 'auto)
                                  (css-declaration 'height 'auto)
                                  (css-declaration 'padding 0)
                                  (css-declaration 'margin 0)
                                  (css-declaration 'overflow 'visible)
                                  (css-declaration 'clip 'auto)
                                  (css-declaration 'white-space
                                                   'normal)))))

(define displays
  (make-parameter (css-rule-variants ".~a"
                                     #:property 'display
                                     #:variants '((inline inline)
                                                  (block block)
                                                  (inline-block inline-block)
                                                  (flow-root flow-root)
                                                  (flex flex)
                                                  (inline-flex inline-flex)
                                                  (grid grid)
                                                  (inline-grid inline-grid)
                                                  (contents contents)
                                                  (table table)
                                                  (inline-table inline-table)
                                                  (table-caption table-caption)
                                                  (table-cell table-cell)
                                                  (table-column table-column)
                                                  (table-column-group
                                                   table-column-group)
                                                  (table-footer-group
                                                   table-footer-group)
                                                  (table-header-group
                                                   table-header-group)
                                                  (table-row-group
                                                   table-row-group)
                                                  (table-row table-row)
                                                  (list-item list-item)
                                                  (hidden none)))))

(define visibility
  (make-parameter (css-rule-variants ".~a"
                                     #:property 'visibility
                                     #:variants '((visible visible)
                                                  (invisible invisible)
                                                  (collapse collapse)))))

(define overflow
  (make-parameter (css-rule-variants ".overflow-~a"
                                     #:property 'overflow
                                     #:variants '((auto auto)
                                                  (hidden hidden)
                                                  (clip clip)
                                                  (visible visible)
                                                  (scroll scroll)))))

(define overflow-x
  (make-parameter (css-rule-variants ".overflow-x-~a"
                                     #:property 'overflow-x
                                     #:variants '((auto auto)
                                                  (hidden hidden)
                                                  (clip clip)
                                                  (visible visible)
                                                  (scroll scroll)))))

(define overflow-y
  (make-parameter (css-rule-variants ".overflow-y-~a"
                                     #:property 'overflow-y
                                     #:variants '((auto auto)
                                                  (hidden hidden)
                                                  (clip clip)
                                                  (visible visible)
                                                  (scroll scroll)))))

(define overscroll-behavior
  (make-parameter (css-rule-variants ".overscroll-~a"
                                     #:property 'overscroll-behavior
                                     #:variants '((auto auto)
                                                  (contain contain)
                                                  (none none)))))

(define overscroll-behavior-x
  (make-parameter (css-rule-variants ".overscroll-x-~a"
                                     #:property 'overscroll-behavior-x
                                     #:variants '((auto auto)
                                                  (contain contain)
                                                  (none none)))))

(define overscroll-behavior-y
  (make-parameter (css-rule-variants ".overscroll-y-~a"
                                     #:property 'overscroll-behavior-y
                                     #:variants '((auto auto)
                                                  (contain contain)
                                                  (none none)))))

(define box-decoration-break
  (make-parameter (css-rule-variants ".box-decoration-~a"
                                     #:property 'box-decoration-break
                                     #:variants '((clone clone)
                                                  (slice slice)))))

(define box-sizing
  (make-parameter (css-rule-variants ".box-~a"
                                     #:property 'box-sizing
                                     #:variants '((border border-box)
                                                  (content content-box)))))

(define float
  (make-parameter (css-rule-variants ".float-~a"
                                     #:property 'float
                                     #:variants '((right right)
                                                  (left left)
                                                  (start inline-start)
                                                  (end inline-end)
                                                  (none none)))))

(define clear
  (make-parameter (css-rule-variants ".clear-~a"
                                     #:property 'clear
                                     #:variants '((left left)
                                                  (right right)
                                                  (both both)
                                                  (start inline-start)
                                                  (end inline-end)
                                                  (none none)))))

(define isolation
  (make-parameter (css-rule-variants ".~a"
                                     #:property 'isolation
                                     #:variants '((isolate isolate)
                                                  (isolation-auto auto)))))

(define object-fit
  (make-parameter (css-rule-variants ".object-~a"
                                     #:property 'object-fit
                                     #:variants '((contain contain)
                                                  (cover cover)
                                                  (fill fill)
                                                  (none none)
                                                  (scale-down scale-down)))))

(define object-position
  (make-parameter (css-rule-variants ".object-~a"
                                     #:property 'object-position
                                     #:variants '((top-left "top left")
                                                  (top top)
                                                  (top-right "top right")
                                                  (left left)
                                                  (center center)
                                                  (right right)
                                                  (bottom-left "bottom left")
                                                  (bottom bottom)
                                                  (bottom-right "bottom right")))))

(define position
  (make-parameter (css-rule-variants ".~a"
                                     #:property 'position
                                     #:variants '((absolute absolute)
                                                  (fixed fixed)
                                                  (relative relative)
                                                  (sticky sticky)
                                                  (static static)))))

(define layout-classes
  (make-parameter (list (aspect-ratio)
                        (columns)
                        (object-fit)
                        (object-position)
                        (absolute-positions)
                        (inset-positions)
                        (breaks)
                        (accessibility)
                        (displays)
                        (float)
                        (clear)
                        (overflow)
                        (overflow-x)
                        (overflow-y)
                        (overscroll-behavior)
                        (overscroll-behavior-x)
                        (overscroll-behavior-y)
                        (box-decoration-break)
                        (box-sizing)
                        (isolation)
                        (position)
                        (z-index))))
