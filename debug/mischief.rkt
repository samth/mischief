#lang mischief

(require
  (for-syntax
    racket
    mischief)
  racket/provide-syntax
  debug
  (for-template
    debug/syntax))

(define-provide-syntax (debug-out stx)
  (syntax-parse stx
    [(_ spec:expr name:id ...)
     (define/syntax-parse {name/debug ...}
       (for/list {[stx (in-list (@ name))]}
         (format-id stx #:source stx "~a/debug" stx)))
     #'(combine-out
         (except-out spec name ...)
         (rename-out [name/debug name] ...))]))

(provide
  (debug-out
    (all-from-out mischief)
    #%app
    define
    lambda)
  (for-template
    (rename-out
      [define-syntax/debug define-syntax]))
  (for-syntax
    (all-from-out racket)))