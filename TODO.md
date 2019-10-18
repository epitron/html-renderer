# TODO list

## Base class

! add HTMLRenderer.reflow_paragraph
* #render takes options (and passes them to subclasses)
* :debug option (hide parse errors unless 'true')

## ANSI renderer

* use HTMLRenderer.reflow_paragraph
* :wrap option (with optional terminal width)
* Better table renderer (with line-drawing)
* Follow `<table>` style attributes when drawing tables (eg: borders)
