require 'html-renderer'

class DebugRenderer < HTMLRenderer::Base
 
  def method_missing(meth, *args)
    "#{meth}(#{args})"
  end

end


if __FILE__ == $0
  puts DebugRenderer.render(open("test.html"))
end