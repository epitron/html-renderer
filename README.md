# HTML Renderer

## Overview

An extensible HTML renderer.

Comes with two built-in renderers:
* `HTMLRenderer::ANSI` (outputs colored text to the termnial)
* `HTMLRenderer::Text` (outputs plain text)

## Usage

Render to ANSI:
```
ansi_text = HTMLRenderer::ANSI.render("<b>hello html</b>")
ansi_text = HTMLRenderer::ANSI.render(open("file.html"))
```

Render to plain text:
```
plain_text = HTMLRenderer::Text.render(open("file.html"))
```

## Extending it

The API design uses the same philosophy as [RedCarpet](https://github.com/vmg/redcarpet).

To create a new renderer, subclass `HTMLRenderer::Base`, then add a method to handle each type of element. Whatever the method returns is output by the renderer.

Example renderer: [HTMLRenderer::ANSI](https://github.com/epitron/html-renderer/blob/master/lib/html-renderer/ansi.rb)
