;; extends

; Use verbatim's highlight for quote blocks
((block name: (expr) @_name (contents) @org.verbatim)
 (#match? @_name "\\c^quote$"))

; Use code's highlight for example blocks
((block name: (expr) @_name (contents) @org.code)
 (#match? @_name "\\c^example$"))

((block name: (expr) @_name (contents) @org.comment)
 (#match? @_name "\\c^comment$"))
