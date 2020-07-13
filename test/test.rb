require 'html-renderer'
require 'html-renderer/debug'

[
  HTMLRenderer::ANSI,
  HTMLRenderer::Text,
  HTMLRenderer::DebugRenderer,
].each do |renderer|
  puts
  puts "=== #{renderer} =============================="
  puts
  puts renderer.render(open("test.html"))
  puts
  puts
end
