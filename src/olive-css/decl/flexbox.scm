;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl flexbox)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (flex-basis flex-justify-content
                       flex-justify-items
                       flex-justify-self
                       flex-align-items
                       flex-align-self
                       flex-align-content
                       flexbox-classes
                       flex-directions
                       gap
                       flex
                       flex-shrink
                       flex-grow
                       flex-place-content
                       flex-place-items
                       flex-place-self
                       gap-multiplier
                       order
                       flex-wrap))

(define gap-multiplier
  (make-parameter 0.3))

(define flex-basis
  (make-parameter (css-rule-variants ".basis-~a"
                                     #:property 'flex-basis
                                     #:variants (append tshirt-sizes
                                                        numeric-sizes))))

(define flex-justify-content
  (make-parameter (css-rule-variants ".justify-~a"
                                     #:property 'justify-content
                                     #:variants '((start flex-start)
                                                  (end flex-end)
                                                  (end-safe "safe flex-end")
                                                  (center center)
                                                  (center-safe "safe center")
                                                  (between space-between)
                                                  (around space-around)
                                                  (evenly space-evenly)
                                                  (stretch stretch)
                                                  (baseline baseline)
                                                  (normal normal)))))

(define flex-align-items
  (make-parameter (css-rule-variants ".items-~a"
                                     #:property 'align-items
                                     #:variants '((start flex-start)
                                                  (end flex-end)
                                                  (end-safe "safe flex-end")
                                                  (center center)
                                                  (center-safe "safe center")
                                                  (baseline baseline)
                                                  (baseline-last
                                                   "last baseline")
                                                  (stretch stretch)))))

(define flex-align-self
  (make-parameter (css-rule-variants ".self-~a"
                                     #:property 'align-self
                                     #:variants '((auto auto)
                                                  (start flex-start)
                                                  (end flex-end)
                                                  (end-safe "safe flex-end")
                                                  (center center)
                                                  (center-safe "safe center")
                                                  (baseline baseline)
                                                  (baseline-last
                                                   "last baseline")
                                                  (stretch stretch)))))

(define flex-align-content
  (make-parameter (css-rule-variants ".content-~a"
                                     #:property 'align-content
                                     #:variants '((start flex-start)
                                                  (end flex-end)
                                                  (center center)
                                                  (normal normal)
                                                  (between space-between)
                                                  (around space-around)
                                                  (evenly space-evenly)
                                                  (baseline baseline)
                                                  (stretch stretch)))))

(define flex-directions
  (make-parameter (css-rule-variants ".flex-~a"
                                     #:property 'flex-direction
                                     #:variants '((row row)
                                                  (col column)
                                                  (row-reverse row-reverse)
                                                  (col-reverse column-reverse)))))

(define gap
  (make-parameter (css-rule-variants ".gap-~a"
                                     #:property 'gap
                                     #:variants (map (lambda (s)
                                                       (css-size s
                                                                 #:conversion
                                                                 to-rem
                                                                 #:multiplier (gap-multiplier)))
                                                     (append numeric-sizes
                                                             tshirt-sizes)))))

(define flex-wrap
  (make-parameter (css-rule-variants ".flex-~a"
                                     #:property 'flex-wrap
                                     #:variants '((nowrap nowrap)
                                                  (wrap wrap)
                                                  (wrap-reverse wrap-reverse)))))

(define flex
  (make-parameter (list (css-rule-variants ".flex-~a"
                                           #:property 'flex
                                           #:variants (map (lambda (s)
                                                             (css-size s
                                                                       #:conversion
                                                                       to-rem))
                                                           (append
                                                            numeric-sizes
                                                            tshirt-sizes)))
                        (css-rule-variants ".flex-~a"
                                           #:property 'flex
                                           #:variants fractions)
                        (css-rule-variants ".flex-~a"
                                           #:property 'flex
                                           #:variants '((initial "0 auto")
                                                        (none none)
                                                        (auto auto))))))

(define flex-shrink
  (make-parameter (list (css-rule ".shrink"
                                  (css-declaration 'flex-shrink 1))
                        (css-rule ".shrink-0"
                                  (css-declaration 'flex-shrink 0)))))

(define flex-grow
  (make-parameter (list (css-rule ".grow"
                                  (css-declaration 'flex-grow 1))
                        (css-rule ".grow-0"
                                  (css-declaration 'flex-grow 0)))))

(define order
  (make-parameter (css-rule-variants ".order-~a"
                                     #:property 'order
                                     #:variants (append numeric-sizes
                                                        '((first -9999)
                                                          (last 9999)
                                                          (none 0))))))

(define flex-place-content
  (make-parameter (css-rule-variants ".place-content-~a"
                                     #:property 'place-content
                                     #:variants '((center center)
                                                  (center-safe "safe center")
                                                  (start start)
                                                  (end end)
                                                  (end-safe "safe end")
                                                  (between space-between)
                                                  (around space-around)
                                                  (evenly space-evenly)
                                                  (baseline baseline)
                                                  (stretch stretch)))))

(define flex-place-items
  (make-parameter (css-rule-variants ".place-items-~a"
                                     #:property 'place-items
                                     #:variants '((start start)
                                                  (end end)
                                                  (end-safe "safe end")
                                                  (center center)
                                                  (center-safe "safe center")
                                                  (baseline baseline)
                                                  (stretch stretch)))))

(define flex-place-self
  (make-parameter (css-rule-variants ".place-self-~a"
                                     #:property 'place-self
                                     #:variants '((auto auto)
                                                  (start start)
                                                  (end end)
                                                  (end-safe "safe end")
                                                  (center center)
                                                  (center-safe "safe center")
                                                  (stretch stretch)))))

(define flex-justify-items
  (make-parameter (css-rule-variants ".justify-items-~a"
                                     #:property 'justify-items
                                     #:variants '((start start)
                                                  (end end)
                                                  (end-safe "safe end")
                                                  (center center)
                                                  (center-safe "safe center")
                                                  (stretch stretch)
                                                  (normal normal)))))

(define flex-justify-self
  (make-parameter (css-rule-variants ".justify-self-~a"
                                     #:property 'justify-self
                                     #:variants '((auto auto)
                                                  (start start)
                                                  (center center)
                                                  (center-safe "safe center")
                                                  (end end)
                                                  (end-safe "safe end")
                                                  (stretch stretch)))))

(define grid-template-columns
  (make-parameter (list (css-rule-variants ".grid-cols-~a"
                                           #:property 'grid-template-columns
                                           #:variants (append (map (lambda (x)
                                                                     (list (car
                                                                            x)
                                                                           (format
                                                                            #f
                                                                            "repeat(~a, minmax(0, 1fr))"
                                                                            (cadr
                                                                             x))))
                                                               positive-numeric-sizes)
                                                              '((none none)
                                                                (subgrid
                                                                 subgrid)))))))

(define grid-template-rows
  (make-parameter (list (css-rule-variants ".grid-rows-~a"
                                           #:property 'grid-template-rows
                                           #:variants (append (map (lambda (x)
                                                                     (list (car
                                                                            x)
                                                                           (format
                                                                            #f
                                                                            "repeat(~a, minmax(0, 1fr))"
                                                                            (cadr
                                                                             x))))
                                                               positive-numeric-sizes)
                                                              '((none none)
                                                                (subgrid
                                                                 subgrid)))))))

(define grid-auto-flow
  (make-parameter (list (css-rule-variants ".grid-flow-~a"
                                           #:property 'grid-auto-flow
                                           #:variants '((row row)
                                                        (col column)
                                                        (dense dense)
                                                        (row-dense "row dense")
                                                        (col-dense
                                                         "column dense"))))))

(define grid-auto-columns
  (make-parameter (list (css-rule-variants ".auto-cols-~a"
                                           #:property 'grid-auto-columns
                                           #:variants (append '((auto auto)
                                                                (min
                                                                 min-content)
                                                                (max
                                                                 max-content))
                                                              numeric-sizes
                                                              tshirt-sizes)))))

(define flexbox-classes
  (make-parameter (list (flex-basis)
                        (flex-place-content)
                        (flex-place-items)
                        (flex-place-self)
                        (flex-justify-content)
                        (flex-justify-items)
                        (flex-justify-self)
                        (flex-align-items)
                        (flex-align-self)
                        (flex-directions)
                        (flex-align-content)
                        (flex)
                        (order)
                        (flex-shrink)
                        (flex-grow)
                        (gap)
                        (flex-wrap)
                        (grid-template-columns)
                        (grid-template-rows)
                        (grid-auto-flow)
                        (grid-auto-columns))))
