;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl interactivity)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl)
  #:use-module (olive-css sizes)
  #:export (interactivity-classes interactivity-core-classes
                                  cursor
                                  user-select
                                  pointer-events
                                  resize
                                  appearance
                                  field-sizing
                                  touch-action
                                  scroll-behavior
                                  color-scheme
                                  forced-color-adjust
                                  interactivity-colors))

(define cursor
  (make-parameter (css-rule-variants ".cursor-~a"
                                     #:property 'cursor
                                     #:variants '((auto auto)
                                                  (default default)
                                                  (pointer pointer)
                                                  (wait wait)
                                                  (text text)
                                                  (move move)
                                                  (help help)
                                                  (not-allowed not-allowed)
                                                  (none none)
                                                  (context-menu context-menu)
                                                  (progress progress)
                                                  (cell cell)
                                                  (crosshair crosshair)
                                                  (vertical-text vertical-text)
                                                  (alias alias)
                                                  (copy copy)
                                                  (no-drop no-drop)
                                                  (grab grab)
                                                  (grabbing grabbing)
                                                  (all-scroll all-scroll)
                                                  (col-resize col-resize)
                                                  (row-resize row-resize)
                                                  (n-resize n-resize)
                                                  (e-resize e-resize)
                                                  (s-resize s-resize)
                                                  (w-resize w-resize)
                                                  (ne-resize ne-resize)
                                                  (nw-resize nw-resize)
                                                  (se-resize se-resize)
                                                  (sw-resize sw-resize)
                                                  (ew-resize ew-resize)
                                                  (ns-resize ns-resize)
                                                  (nesw-resize nesw-resize)
                                                  (nwse-resize nwse-resize)
                                                  (zoom-in zoom-in)
                                                  (zoom-out zoom-out)))))

(define user-select
  (make-parameter (css-rule-variants ".select-~a"
                                     #:property 'user-select
                                     #:variants '((none none)
                                                  (text text)
                                                  (all all)
                                                  (auto auto)))))

(define pointer-events
  (make-parameter (css-rule-variants ".pointer-events-~a"
                                     #:property 'pointer-events
                                     #:variants '((none none)
                                                  (auto auto)))))

(define resize
  (make-parameter (list (css-rule ".resize"
                                  (css-declaration 'resize
                                                   'both))
                        (css-rule ".resize-none"
                                  (css-declaration 'resize
                                                   'none))
                        (css-rule ".resize-x"
                                  (css-declaration 'resize
                                                   'horizontal))
                        (css-rule ".resize-y"
                                  (css-declaration 'resize
                                                   'vertical)))))

(define appearance
  (make-parameter (css-rule-variants ".appearance-~a"
                                     #:property 'appearance
                                     #:variants '((none none)
                                                  (auto auto)))))

(define field-sizing
  (make-parameter (css-rule-variants ".field-sizing-~a"
                                     #:property 'field-sizing
                                     #:variants '((fixed fixed)
                                                  (content content)))))

(define touch-action
  (make-parameter (css-rule-variants ".touch-~a"
                                     #:property 'touch-action
                                     #:variants '((auto auto)
                                                  (none none)
                                                  (pan-x pan-x)
                                                  (pan-y pan-y)
                                                  (pan-left pan-left)
                                                  (pan-right pan-right)
                                                  (pan-up pan-up)
                                                  (pan-down pan-down)
                                                  (pinch-zoom pinch-zoom)
                                                  (manipulation manipulation)))))

(define scroll-behavior
  (make-parameter (css-rule-variants ".scroll-~a"
                                     #:property 'scroll-behavior
                                     #:variants '((auto auto)
                                                  (smooth smooth)))))

(define color-scheme
  (make-parameter (css-rule-variants ".scheme-~a"
                                     #:property 'color-scheme
                                     #:variants '((normal normal)
                                                  (light light)
                                                  (dark dark)
                                                  ("light-dark" "light dark")
                                                  ("only-light" "only light")
                                                  ("only-dark" "only dark")))))

(define forced-color-adjust
  (make-parameter (css-rule-variants ".forced-color-adjust-~a"
                                     #:property 'forced-color-adjust
                                     #:variants '((auto auto)
                                                  (none none)))))

(define (interactivity-colors palettes)
  "Palette-aware accent and caret color utilities."
  (append (css-palette-rules ".accent-~a-~a"
                             #:property 'accent-color
                             #:palettes palettes)
          (css-palette-rules ".caret-~a-~a"
                             #:property 'caret-color
                             #:palettes palettes)))

(define (interactivity-core-classes)
  "Structural interactivity utilities (no palette-derived colors)."
  (list (cursor)
        (user-select)
        (pointer-events)
        (resize)
        (appearance)
        (field-sizing)
        (touch-action)
        (scroll-behavior)
        (color-scheme)
        (forced-color-adjust)))

(define (interactivity-classes palettes)
  (append (interactivity-core-classes)
          (list (interactivity-colors palettes))))
