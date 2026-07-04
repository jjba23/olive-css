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

(define-module (olive-css decl reset)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:export (reset-css))

(define all-html-elements
  '("*" "::after" "::before" "::backdrop" "::file-selector-button"))

(define reset-css
  (make-parameter (list (css-rule (string-join all-html-elements ", ")
                                  (css-declaration 'margin 0)
                                  (css-declaration 'padding 0)
                                  (css-declaration 'border "0 solid")
                                  (css-declaration 'box-sizing
                                                   'border-box)
                                  (css-declaration 'font
                                                   'inherit)
                                  (css-declaration 'vertical-align
                                                   'baseline))
                        (css-rule (string-join (map symbol->string
                                                    '(h1 h2 h3 h4 h5 h6)) ",")
                                  (css-declaration 'font-size
                                                   'inherit)
                                  (css-declaration 'font-weight
                                                   'inherit))
                        (css-rule (string-join (map symbol->string
                                                    '(article aside
                                                              details
                                                              figcaption
                                                              figure
                                                              footer
                                                              header
                                                              hgroup
                                                              menu
                                                              nav
                                                              section)) ", ")
                                  (css-declaration 'display
                                                   'block))
                        (css-rule 'button
                                  (css-declaration 'background
                                                   'transparent)
                                  (css-declaration 'border
                                                   'none))
                        (css-rule 'body
                                  (css-declaration 'line-height 1))

                        (css-rule (string-join (map symbol->string
                                                    '(blockquote q)) ", ")
                                  (css-declaration 'quotes
                                                   'none))

                        (css-rule 'table
                                  (css-declaration 'borser-collpase
                                                   'collapse)
                                  (css-declaration 'border-spacing 0))

                        (css-rule (string-join (map symbol->string
                                                    '(blockquote:before
                                                      blockquote:after

                                                      q:before q:after)) ", ")
                                  (css-declaration 'content "''")
                                  (css-declaration 'content
                                                   'none))
                        (css-rule (string-join (map symbol->string
                                                    '(ol ul)) ", ")
                                  (css-declaration 'list-style
                                                   'none))

                        )))
