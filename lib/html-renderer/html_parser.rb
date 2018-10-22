require 'strscan'

class Stack < Array
  alias_method :top, :last
  alias_method :peek, :last
end

class String
  def recursive_inspect(depth)
    ("  "*depth)+inspect
  end
end

class HTMLParser

  OPEN_TAG_RE  = %r{<([^>]+)>}
  CLOSE_TAG_RE = %r{</([^>]+)>}
  TEXT_RE      = %r{[^<]+}
  ATTR_RE      = %r{(\w+)=(?:"([^"]+)"|'([^']+)'|(\w+))}

  class Tag

    attr_accessor :name, :attrs, :children

    def self.from_str(s)
      name, rest = s.split(/\s+/, 2)
      
      if rest
        attrs = rest.scan(HTMLParser::ATTR_RE).flatten.compact.each_slice(2).to_h
      else
        attrs = {}
      end
      new(name, attrs)
    end

    def initialize(name, attrs={}, children=[])
      @name     = name
      @attrs    = attrs
      @children = children
    end

    def recursive_inspect(depth=0)
      curdent = "  "*depth
      indent = "  "*(depth+1)
      "#{curdent}<#{name} #{attrs}>\n#{indent}#{children.map{|c| c.recursive_inspect(depth+1)}}\n#{curdent}</#{name}>"
    end

  end

  def initialize(html)
    @s = StringScanner.new(html)
    # @s = html
  end

  def each_tag
      until @s.eos?
      if @s.scan(CLOSE_TAG_RE)
        yield [:close_tag, @s.captures.first]
      elsif @s.scan(OPEN_TAG_RE)
        tag = Tag.from_str(@s.captures.first)
        yield [:open_tag, tag]
      elsif @s.scan(TEXT_RE)
        yield [:text, @s.matched]
      end
    end
  end

  def as_tree
    tree.map { |e| e.recursive_inspect }
  end

  def tree
    stack = Stack.new
    stack.push Tag.new("root")

    each_tag do |type, elem|
      case type
      when :text
        text = elem.strip
        stack.top.children << text unless text.empty?
      when :open_tag
        stack.top.children << elem
        stack.push elem
      when :close_tag
        stack.pop
      else
        raise "wat"
      end
    end

    stack
  end

end

unless file = ARGV.first
  file = "test.html"
end

html = File.read(file)

r = HTMLParser.new(html)
r.each_tag{|t| p t}

# puts r.as_tree