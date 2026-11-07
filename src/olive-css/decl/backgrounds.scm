;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl backgrounds)
  #:use-module (olive-css dsl)
  #:export (background-classes background-image background-position
                               background-size background-repeat
                               background-attachment background-clip
                               background-origin))

(define background-image
  (make-parameter (list (css-rule ".bg-none"
                                  (css-declaration 'background-image
                                                   'none)))))

(define background-position
  (make-parameter (css-rule-variants ".bg-~a"
                                     #:property 'background-position
                                     #:variants '((center center)
                                                  (top top)
                                                  ("top-right" "top right")
                                                  (right right)
                                                  ("bottom-right" "bottom right")
                                                  (bottom bottom)
                                                  ("bottom-left" "bottom left")
                                                  (left left)
                                                  ("top-left" "top left")))))

(define background-size
  (make-parameter (css-rule-variants ".bg-~a"
                                     #:property 'background-size
                                     #:variants '((auto auto)
                                                  (cover cover)
                                                  (contain contain)))))

(define background-repeat
  (make-parameter (css-rule-variants ".bg-~a"
                                     #:property 'background-repeat
                                     #:variants '((repeat repeat)
                                                  ("no-repeat" no-repeat)
                                                  ("repeat-x" repeat-x)
                                                  ("repeat-y" repeat-y)
                                                  ("repeat-round" round)
                                                  ("repeat-space" space)))))

(define background-attachment
  (make-parameter (css-rule-variants ".bg-~a"
                                     #:property 'background-attachment
                                     #:variants '((fixed fixed)
                                                  (local local)
                                                  (scroll scroll)))))

(define background-clip
  (make-parameter (css-rule-variants ".bg-clip-~a"
                                     #:property 'background-clip
                                     #:variants '((border "border-box")
                                                  (padding "padding-box")
                                                  (content "content-box")
                                                  (text text)))))

(define background-origin
  (make-parameter (css-rule-variants ".bg-origin-~a"
                                     #:property 'background-origin
                                     #:variants '((border "border-box")
                                                  (padding "padding-box")
                                                  (content "content-box")))))

(define (background-classes)
  "Background image utilities that do not depend on a palette."
  (list (background-image)
        (background-position)
        (background-size)
        (background-repeat)
        (background-attachment)
        (background-clip)
        (background-origin)))
