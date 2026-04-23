; Inject markdown into text nodes
((text) @injection.content
 (#set! injection.language "markdown")
 (#set! injection.combined)
 (#set! injection.include-children))