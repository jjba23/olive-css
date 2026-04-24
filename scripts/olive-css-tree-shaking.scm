(use-modules (ice-9 rdelim)
             (ice-9 regex)
             (ice-9 ftw)
             (ice-9 textual-ports)
             (ice-9 string-fun)
             (srfi srfi-1)
             (olive-css dsl)
             (olive-css decl reset))

(define artifact-path
  "public")

(define (escape-class-name name)
  (let* ((with-colon (string-replace-substring name ":" "\\:"))
         (with-slash (string-replace-substring with-colon "/" "\\/")))
    with-slash))

(define (extend-classes classes . prefixes)
  (append-map (lambda (cls)
                (map (lambda (p)
                       (string-append p cls)) prefixes)) classes))

(define (extract-classes-from-html file-path)
  (let ((content (call-with-input-file file-path
                   read-string))
        (class-re (make-regexp "class=[\\\"']([^\\\"']+)[\\\"']"
                               regexp/extended)))
    (let loop
      ((start 0)
       (acc '()))
      (let ((matched (regexp-exec class-re content start)))
        (if matched
            (let* ((class-str (match:substring matched 1))
                   (current-classes (map escape-class-name
                                         (string-tokenize class-str))))
              (loop (match:end matched)
                    (append current-classes acc))) acc)))))

(define (get-all-used-classes base-dir)
  (define (enter? path stat result)
    (not (member (basename path)
                 '(".git"))))
  (define (leaf path stat result)
    (if (string-suffix? ".html" path)
        (append (extract-classes-from-html path) result) result))
  (define (down path stat result)
    result)
  (define (up path stat result)
    result)
  (define (skip path stat result)
    result)
  (define (error name stat errno result)
    (format (current-error-port) "warning: ~a: ~a~%" name
            (strerror errno)) result)

  (let ((raw-classes (file-system-fold enter?
                                       leaf
                                       down
                                       up
                                       skip
                                       error
                                       '()
                                       base-dir)))
    (delete-duplicates (filter (lambda (s)
                                 (not (or (string-null? s)
                                          (string=? s "\n")))) raw-classes))))

(define (write-matched-class class-name css-content out-port)
  (let* ((quote-name (regexp-quote class-name))
         (pattern (string-append "\\." quote-name "([[:space:]{])" "[^{]*"
                                 "\\{([^{}]*|\\{[^}]*\\})*\\}"))
         (re (make-regexp pattern regexp/extended))
         (matched (regexp-exec re css-content)))
    (when matched
      (display (match:substring matched 0) out-port)
      (newline out-port))))

(define (tree-shake-css input-file output-file . processors)
  (display "Starting css tree-shaking...\n")
  (let ((css-content (call-with-input-file input-file
                       get-string-all)))
    (call-with-output-file output-file
      (lambda (out-port)
        (for-each (lambda (proc)
                    (proc out-port css-content)) processors))))
  (display "Finished css tree-shaking.\n"))

(let* ((used-classes (get-all-used-classes artifact-path))
       (hover-classes (append used-classes
                              (extend-classes used-classes "hover\\:")))
       (dark-classes (extend-classes used-classes "dark\\:" "dark\\:hover\\:")))
  (tree-shake-css "resources/css/olive.min.css"
                  (string-append artifact-path "/olive.min.css")
                  (lambda (out css-content)
                    (display (string-join (flatten-list (map format-css
                                                             (list (reset-css))))
                                          "\n") out)
                    (newline out)
                    (for-each (lambda (cls)
                                (write-matched-class cls css-content out))
                              hover-classes))
                  ;; dark mode
                  (lambda (out css-content)
                    (newline out)
                    (display
                     "&:where([data-theme=dark], [data-theme=dark] *) {" out)
                    (newline out)
                    (for-each (lambda (cls)
                                (write-matched-class cls css-content out))
                              dark-classes)
                    (display "}" out)
                    (newline out))))
