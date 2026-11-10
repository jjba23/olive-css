;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;;; Commentary:
;;;
;;; Unit tests for the content-aware tree-shaker in @code{(olive-css
;;; tree-shaking)}: class-name escaping, HTML scanning and its options, the
;;; pruning rules, parameterized end-to-end runs, and the no-leakage invariant
;;; against the checked-in @file{public/sample.html} fixture and the prebuilt
;;; @file{resources/css/olive.min.css}.
;;;
;;; The file path mirrors the module name, because that is how the Veritas
;;; runner resolves it: @file{test/veritas/unit/tree-shaking.scm} declares
;;; @code{(veritas unit tree-shaking)} and exports @code{spec}.  Run everything
;;; with @code{maak test}.
;;;
;;; A note on timing: the arguments of @code{test} and @code{assert-*} are
;;; evaluated when the suite is built, so state that changes while tests run
;;; cannot be read through them.  This suite therefore builds its fixtures and
;;; computes the values it asserts on when the module is loaded, which happens
;;; once, right before @code{spec} runs; only the cleanup waits for the suites
;;; to finish.
;;;
;;;
;;; Code:

(define-module (veritas unit tree-shaking)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-1)
  #:use-module (veritas veritas)
  #:use-module (olive-css license)
  #:use-module (olive-css tree-shaking)
  #:export (spec))

;;; ---------------------------------------------------------------------------
;;; Helpers
;;; ---------------------------------------------------------------------------

;; The character CSS escapes inside a class name, and the newline used to check
;; that output is minified.  Both are built from character codes so the tests
;; never depend on how a backslash is spelled in source.
(define backslash
  (integer->char 92))
(define newline-char
  (integer->char 10))

(define (escaped suffix)
  "The backslash CSS puts in front of SUFFIX inside a class name."
  (string-append (string backslash) suffix))

(define (remove-tree path)
  "Best-effort recursive removal of PATH, files and directories alike."
  (when (file-exists? path)
    (if (eq? 'directory
             (stat:type (stat path)))
        (begin
          (for-each (lambda (entry)
                      (remove-tree (string-append path "/" entry)))
                    (scandir path
                             (lambda (name)
                               (not (member name
                                            '("." ".."))))))
          (rmdir path))
        (delete-file path))))

(define (ensure-dir path)
  "Create PATH and its parents when they do not exist yet."
  (unless (file-exists? path)
    (ensure-dir (dirname path))
    (mkdir path)))

(define (write-text-file! path text)
  "Write TEXT to PATH, creating the parent directories as needed."
  (ensure-dir (dirname path))
  (call-with-output-file path
    (lambda (port)
      (display text port))))

(define (read-text-file path)
  (call-with-input-file path
    get-string-all))

(define (mentions? haystack needle)
  "True when HAYSTACK contains NEEDLE."
  (if (string-contains haystack needle) #t #f))

(define (contains? names name)
  "Whether the list NAMES holds NAME.  A real boolean, because assert-true and
assert-false compare with eq?."
  (if (member name names) #t #f))

(define (count-occurrences haystack needle)
  "How many times NEEDLE appears in HAYSTACK."
  (let loop
    ((from 0)
     (found 0))
    (let ((hit (string-contains haystack needle from)))
      (if hit
          (loop (+ hit
                   (string-length needle))
                (+ found 1)) found))))

(define (class-name-end selector start)
  "Exclusive end index of the class name beginning at START in SELECTOR, where
an escaped character belongs to the name."
  (let loop
    ((i start))
    (cond
      ((>= i
           (string-length selector))
       i)
      ((char=? (string-ref selector i) backslash)
       (loop (+ i 2)))
      ((or (char-alphabetic? (string-ref selector i))
           (char-numeric? (string-ref selector i))
           (char=? (string-ref selector i) #\-)
           (char=? (string-ref selector i) #\_))
       (loop (+ i 1)))
      (else i))))

(define (class-names-in-selector selector)
  "The class names SELECTOR references.  Because escaped characters belong to
the name, `md:hover:bg-x/50' is one name rather than three."
  (let loop
    ((i 0)
     (acc '()))
    (cond
      ((>= i
           (string-length selector))
       (reverse acc))
      ((char=? (string-ref selector i) backslash)
       (loop (+ i 2) acc))
      ((char=? (string-ref selector i) #\.)
       (let ((end (class-name-end selector
                                  (+ i 1))))
         (loop end
               (cons (substring selector
                                (+ i 1) end) acc))))
      (else (loop (+ i 1) acc)))))

(define (selector-preludes css)
  "Every selector or at-rule prelude in CSS, descending into grouping rules so
the rules nested in media queries and the dark-mode scope are visited too."
  (append-map (lambda (block)
                (let ((prelude (car block))
                      (body (cdr block)))
                  (cond
                    ((not body)
                     (list prelude))
                    ((mentions? body "{")
                     (selector-preludes body))
                    (else (list prelude)))))
              (parse-css-blocks css)))

(define (class-names-in-stylesheet css)
  "The distinct class names the selectors of CSS reference."
  (delete-duplicates (append-map class-names-in-selector
                                 (selector-preludes css))))

;;; ---------------------------------------------------------------------------
;;; A small stylesheet that exercises every pruning rule
;;; ---------------------------------------------------------------------------

(define fixture-css
  (string-append "*{box-sizing:border-box}"
                 ".used{color:red}"
                 ".unused{color:blue}"
                 "@media (width >= 40rem){.used-md{color:green}"
                 ".unused-md{color:pink}}"
                 "@media (width >= 80rem){.unused-xl{color:black}}"
                 ".kept-list,.unused-list{color:olive}"
                 ":where([data-theme=dark], [data-theme=dark] *)"
                 "{.dark-used{color:white}.dark-unused{color:gray}}"
                 "@keyframes spin{to{transform:rotate(1turn)}}"
                 "@view-transition{navigation:auto}"
                 "@layer base;"))

(define fixture-used-classes
  '("used" "used-md" "dark-used" "kept-list"))

(define fixture-pruned
  (tree-shake-css fixture-css fixture-used-classes))

;;; ---------------------------------------------------------------------------
;;; Fixture trees
;;; ---------------------------------------------------------------------------

(define scan-root
  "/tmp/olive-css-veritas-scan")
(define scan-site
  (string-append scan-root "/site"))

(define (build-scan-fixture!)
  (remove-tree scan-root)
  (write-text-file! (string-append scan-site "/index.html")
                    (string-append
                     "<div class=\"bg-jeans-blue-500 hover:bg-white"
                     " bg-jeans-blue-500\">Hello Olive CSS!</div>"))
  (write-text-file! (string-append scan-site "/sub/page.htm")
                    "<p class=\"text-onyx-500\">nested page</p>")
  ;; Not HTML, so it is only read when scanned-file-types says so.
  (write-text-file! (string-append scan-site "/notes.txt")
                    "<div class=\"bg-mantis-900\">notes</div>")
  ;; Inside a skipped directory, so it is only read when that option is cleared.
  (write-text-file! (string-append scan-site "/.git/ignored.html")
                    "<div class=\"bg-onyx-900\">history</div>"))

(define (classes-used-under path)
  "The classes a scan of PATH finds with the default options."
  (parameterize ((artifact-path path))
    (scan-used-classes path)))

;; Built now rather than in a #:before-all hook: the arguments of the
;; assertions below are evaluated while this module loads, which is before any
;; hook would have run.
(build-scan-fixture!)

(define scan-used
  ;; 3: the two from index.html, plus the nested .htm page.
  (classes-used-under scan-site))

(define scan-used-skipping-nothing
  (parameterize ((artifact-path scan-site)
                 (skipped-directories '()))
    (scan-used-classes scan-site)))

(define scan-used-text-files
  (parameterize ((artifact-path scan-site)
                 (scanned-file-types '(".txt")))
    (scan-used-classes scan-site)))

(define e2e-root
  "/tmp/olive-css-veritas-e2e")
(define e2e-site
  (string-append e2e-root "/site"))
(define e2e-stylesheet
  (string-append e2e-root "/style.css"))

(define (build-e2e-fixture!)
  (remove-tree e2e-root)
  (write-text-file! (string-append e2e-site "/index.html")
                    "<div class=\"bg-jeans-blue-500 hover:bg-white\">hi</div>")
  (write-text-file! e2e-stylesheet
                    (string-append ".bg-jeans-blue-500{color:red}" "."
                                   (escape-class-name "hover:bg-white")
                                   ":hover{color:blue}"
                                   ".never-used{color:green}")))

(define e2e-result
  (begin
    (build-e2e-fixture!)
    (parameterize ((artifact-path e2e-site)
                   (base-stylesheet-path e2e-stylesheet)
                   (output-css-target "app.min.css"))
      (tree-shake))))

(define e2e-destination
  (assoc-ref e2e-result
             'destination))

;;; ---------------------------------------------------------------------------
;;; The real build, pruned once for the no-leakage tests
;;; ---------------------------------------------------------------------------

(define sample-stylesheet
  "resources/css/olive.min.css")

(define sample-css-length
  (string-length (read-text-file sample-stylesheet)))

(define sample-used
  (scan-used-classes "public"))

(define sample-pruned
  (tree-shake-css (read-text-file sample-stylesheet) sample-used))

(define sample-classes-in-output
  (class-names-in-stylesheet sample-pruned))

;;; ---------------------------------------------------------------------------
;;; Escaping
;;; ---------------------------------------------------------------------------

(define escaping-suite
  (suite "class-name escaping"
         (test "state variants and opacity modifiers are escaped"
               (assert-equal #:expect (string-append "hover"
                                                     (escaped ":bg-x"))
                             #:got (escape-class-name "hover:bg-x")
                             #:name "hover:bg-x")
               (assert-equal #:expect (string-append "bg-x"
                                                     (escaped "/50"))
                             #:got (escape-class-name "bg-x/50")
                             #:name "bg-x/50")
               (assert-equal #:expect (string-append "md"
                                                     (escaped ":hover")
                                                     (escaped ":bg-x")
                                                     (escaped "/50"))
                             #:got (escape-class-name "md:hover:bg-x/50")
                             #:name
                             "stacked variant carrying an opacity modifier")
               (assert-equal #:expect (string-append "mask-t-from-50"
                                                     (escaped "%"))
                             #:got (escape-class-name "mask-t-from-50%")
                             #:name "percentage-suffixed mask utility"))
         (test "ordinary names pass through untouched"
               (assert-equal #:expect "bg-jeans-blue-500"
                             #:got (escape-class-name "bg-jeans-blue-500")
                             #:name "hyphenated utility name")
               (assert-equal #:expect "sr-only"
                             #:got (escape-class-name "sr-only")
                             #:name "double-barrelled utility name"))))

;;; ---------------------------------------------------------------------------
;;; HTML scanning and its options
;;; ---------------------------------------------------------------------------

(define scanning-suite
  (suite "HTML scanning and options"
         #:after-all (lambda (vc)
                       (remove-tree scan-root))
         (test "recurses into subdirectories for .html and .htm files"
               (assert-equal #:expect 3
                             #:got (length scan-used)
                             #:name "three classes across two files")
               (assert-true (contains? scan-used "bg-jeans-blue-500")
                            #:name "the .html file is scanned")
               (assert-true (contains? scan-used "text-onyx-500")
                            #:name "the nested .htm file is scanned"))
         (test "reads every class attribute and de-duplicates"
               (assert-equal #:expect 1
                #:got (length (filter (lambda (name)
                                        (string=? name "bg-jeans-blue-500"))
                                      scan-used))
                #:name "a class repeated in one attribute is reported once")
               (assert-true (contains? scan-used
                                       (escape-class-name "hover:bg-white"))
                            #:name "variant names are escaped when scanned"))
         (test "skipped-directories keeps version control contents out"
               (assert-false (contains? scan-used "bg-onyx-900")
                             #:name "nothing under .git is scanned by default")
               (assert-true (contains? scan-used-skipping-nothing
                                       "bg-onyx-900")
                            #:name "clearing the option does reach .git"))
         (test "scanned-file-types selects which files are read"
               (assert-false (contains? scan-used "bg-mantis-900")
                             #:name "a .txt file is ignored by default")
               (assert-true (contains? scan-used-text-files "bg-mantis-900")
                            #:name "binding the option reads the .txt file"))))

;;; ---------------------------------------------------------------------------
;;; Pruning
;;; ---------------------------------------------------------------------------

(define pruning-suite
  (suite "pruning rules"
         (test "keeps what the pages use and drops the rest"
               (assert-true (mentions? fixture-pruned ".used{")
                            #:name "the used rule survives")
               (assert-false (mentions? fixture-pruned ".unused{")
                             #:name "the unused rule is dropped"))
         (test "prunes inside media queries"
               ;; Counted rather than matched as text, so the assertion does not
               ;; depend on how the minifier writes the media feature.
               (assert-equal #:expect 1
                             #:got (count-occurrences fixture-pruned "@media")
                             #:name "only the used media query is written")
               (assert-true (mentions? fixture-pruned ".used-md{")
                            #:name "the used rule inside it survives")
               (assert-false (mentions? fixture-pruned ".unused-md{")
                             #:name "the unused rule inside it is dropped"))
         (test "drops a grouping rule that became empty"
               (assert-false (mentions? fixture-pruned ".unused-xl{")
                             #:name "the rule of the 80rem query is gone")
               (assert-false (mentions? fixture-pruned "80rem")
                             #:name
                             "a media query whose every rule was dropped"))
         (test "keeps only the used part of a selector list"
               (assert-true (mentions? fixture-pruned ".kept-list{")
                            #:name "the used selector of the list survives")
               (assert-false (mentions? fixture-pruned ".unused-list")
                             #:name
                             "the unused selector of the list is dropped"))
         (test "prunes inside the dark-mode scope"
               (assert-true (mentions? fixture-pruned
                                       ":where([data-theme=dark]")
                            #:name "the dark scope itself survives")
               (assert-true (mentions? fixture-pruned ".dark-used{")
                            #:name "the used rule inside it survives")
               (assert-false (mentions? fixture-pruned ".dark-unused{")
                             #:name "the unused rule inside it is dropped"))
         (test "keeps rules that carry no class"
               (assert-true (mentions? fixture-pruned "box-sizing:border-box")
                            #:name "the reset rule survives")
               (assert-true (mentions? fixture-pruned "@keyframes spin")
                            #:name "keyframes survive")
               (assert-true (mentions? fixture-pruned "@view-transition")
                            #:name "view transitions survive")
               (assert-true (mentions? fixture-pruned "@layer base;")
                            #:name "an at-rule without a block survives"))
         (test "writes minified output"
               (assert-false (mentions? fixture-pruned
                                        (string newline-char))
                             #:name "no newlines in the pruned stylesheet")
               (assert-true (string-prefix? "/*" fixture-pruned)
                            #:name "the stylesheet opens with a comment"))
         (test "the license header is a parameter"
               (assert-true (> (string-length (license-header)) 0)
                            #:name "the header has a default value")
               (assert-true (mentions? fixture-pruned
                                       "olive-css - Utility-class")
                            #:name "the header is written by default")
               (assert-false (mentions? (parameterize ((license-header ""))
                                          (tree-shake-css fixture-css
                                           fixture-used-classes))
                                        "olive-css - Utility-class")
                #:name "binding the header to the empty string omits it"))))

;;; ---------------------------------------------------------------------------
;;; End to end, driven by the parameters
;;; ---------------------------------------------------------------------------

(define end-to-end-suite
  (suite "tree-shake through its parameters"
         #:after-all (lambda (vc)
                       (remove-tree e2e-root))
         (test "writes to the configured directory and target"
               (assert-equal #:expect (string-append e2e-site "/app.min.css")
                             #:got e2e-destination
                             #:name
                             "the destination resolves inside artifact-path")
               (assert-true (file-exists? e2e-destination)
                            #:name "the pruned stylesheet was written")
               (assert-true (mentions? (read-text-file e2e-destination)
                                       ".bg-jeans-blue-500{")
                            #:name "the used rule was kept")
               (assert-false (mentions? (read-text-file e2e-destination)
                                        ".never-used{")
                             #:name "the unused rule was dropped"))
         (test "reports what it did"
               (assert-equal #:expect 2
                             #:got (assoc-ref e2e-result
                                              'used-classes)
                             #:name "two classes are in use")
               (assert-equal #:expect (string-length (read-text-file
                                                      e2e-stylesheet))
                             #:got (assoc-ref e2e-result
                                              'input-bytes)
                             #:name
                             "input-bytes reports the source stylesheet")
               (assert-equal #:expect (string-length (read-text-file
                                                      e2e-destination))
                             #:got (assoc-ref e2e-result
                                              'output-bytes)
                             #:name "output-bytes reports what was written"))))

;;; ---------------------------------------------------------------------------
;;; No leakage, against the real build and the checked-in fixture
;;; ---------------------------------------------------------------------------

(define no-leakage-suite
  (suite "no leakage on the checked-in sample"
         (test "the sample fixture drives a substantial prune"
               (assert-true (> (length sample-used) 20)
                            #:name "the sample uses a good number of classes")
               (assert-true (< (string-length sample-pruned)
                               (/ sample-css-length 100))
                            #:name "the pruned stylesheet is a tiny fraction")
               (assert-false (mentions? sample-pruned
                                        (string newline-char))
                             #:name "the pruned stylesheet is minified"))
         (test "exactly the classes the sample uses survive"
               ;; Passed as separate cases on purpose: a Veritas test keeps only the
               ;; assertions that are direct arguments, so wrapping these in a
               ;; `let' would silently drop all but the last one.
               (assert-equal #:expect '()
                             #:got (lset-difference string=?
                                                    sample-classes-in-output
                                                    sample-used)
                             #:name "no unused class is left in the output")
               (assert-equal #:expect '()
                             #:got (lset-difference string=? sample-used
                                                    sample-classes-in-output)
                             #:name "every used class is in the output")
               (assert-equal #:expect (length sample-used)
                             #:got (length sample-classes-in-output)
                             #:name "the output references no other class"))))

;;; ---------------------------------------------------------------------------
;;; Entry-point
;;; ---------------------------------------------------------------------------

(define (spec)
  (veritas-run escaping-suite scanning-suite pruning-suite end-to-end-suite
               no-leakage-suite))
