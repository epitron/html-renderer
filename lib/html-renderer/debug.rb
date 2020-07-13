require 'html-renderer'

class HTMLRenderer::DebugRenderer < HTMLRenderer::Base

  def method_missing(meth, *args)
    "#{meth}(#{args})"
  end

end