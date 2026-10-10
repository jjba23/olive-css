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

(define-module (maak)
  #:declarative? #t
  #:use-module (maak maak))

;; ====== Maak constants ======

;; The URL for the CSS style-sheet used to style API documentation.
(define api-docs-css-url
  "https://jointhefreeworld.org/static/css/jointhefreeworld.css")

;; The absolute path to the directory where the API documentation will be deployed.
(define deploy-api-docs-dir
  "/srv/http/jointhefreeworld.org")

;; The name of the project, represented as a symbol.
(define project-name
  'olive-css)

(define hot-reload-file-types
  '(scm css))

;; ====== Maak tasks ======

(define (fmt)
  "Format Scheme source code files according to the Guix style guide."
  ($ '("find . -maxdepth 8 -name '*.scm'" "-type f -exec guix style -f {} \\;")))

(define (repl)
  "Development REPL."
  (time-machine-manifest-shell '("guile -L ./src"
                                 "-c '((@ (ares server) run-nrepl-server))'")))

(define (docs)
  "Generate technical API documentation."
  (delete-file-recursively "doc")
  (time-machine-manifest-shell (list (~ "documenta api ./src/~a && "
                                        project-name)
                                     (~ "texi2any -v --html --css-ref=~a"
                                        api-docs-css-url)
                                     "./doc/api/index.texi"))
  (mv "./index" "./doc/api-dist"))

(define (deploy)
  "Generate documentation for the project and publish to web directory."
  (fmt)
  (build)
  (docs)
  (remkdir-p (~ "~a/api-docs/~a" deploy-api-docs-dir project-name))
  (mv "doc/api-dist/*"
      (~ "~a/api-docs/~a" deploy-api-docs-dir project-name))
  (delete-file-recursively "doc"))

(define (compile)
  "Compile all project source code."
  (time-machine-manifest-shell (list "guild compile -L ./src" "-W3"
                                     "./src/**/*.scm")))

(define (build)
  "Generate production CSS."
  (time-machine-manifest-shell '("guile -L ./src"
                                 "./scripts/olive-css-gen.scm")))

(define (tree-shake)
  "Tree-shake and optimize CSS."
  (time-machine-manifest-shell '("guile -L ./src"
                                 "./scripts/olive-css-tree-shaking.scm")))

;; Veritas looks for unit tests by default and reports with emoji-reporter, so
;; the environment needs nothing else.  Variable assignments cannot be prefixed
;; to the command here: `guix shell ... -- VAR=value guile' would take the
;; assignment for the program name.
(define (test)
  "Run the unit test suite with the Veritas testing framework."
  (time-machine-manifest-shell '("guile --fresh-auto-compile -L ./src -L ./test"
                                 "-c '((@ (veritas runner) run-tests))'")))

(define (hot-reload)
  "Hot-reloading developer's setup."
  (fmt)
  (time-machine-manifest-shell (list "watchexec"
                                     "--clear"
                                     (~ "--exts ~a"
                                        (string-join (map symbol->string
                                                      hot-reload-file-types)
                                                     ","))
                                     "--ignore=resources/css/*.min.css"
                                     "--on-busy-update=restart"
                                     "--shell bash"
                                     "--watch . --"
                                     "maak build")))

(define (dev)
  "Developer's setup."
  (hot-reload))

(define (default)
  "Default task to be run, list available tasks."
  ($ '("maak --list")))
