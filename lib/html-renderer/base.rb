######################################################################################
require 'oga'
######################################################################################
#
# TODOs:
# - Streaming output (yield every paragraph/div/header)
# - Embed into 'c' tool (for rendering raw HTML blocks)
#
######################################################################################

class String

  def tighten
    gsub(/\s+/, ' ').strip
  end

  def blank?; !!self[/[^\s]/]; end

end

class NilClass
  def blank?; true; end
end

######################################################################################

module HTMLRenderer

  class State
    attr_accessor :list_order

    def initialize
      @list_order = :unordered
    end

    def with(opts={})
      newstate = dup
      opts.each { |k,v| newstate.send("#{k}=", v) }
      newstate
    end
  end

  class Base

    def self.render(input)
      new.render(input)
    end

    def render(input)
      doc = Oga.parse_html(input)

      state = State.new
      render_children(doc, state)
    end

private
    def render_children(node, state)

      results = node.children.map do |node|

        case node

        when Oga::XML::Text
          content = node.text
          content.blank? ? normal_text(content) : nil

        when Oga::XML::Element
          case node.name
          when "a"
            url     = node["href"]
            title   = node["title"]
            content = render_children(node, state)

            link(url, title, content)

          when "img"
            link    = node["src"]
            title   = node["title"]
            content = nil

            image(link, title, content)

          when /^h(\d)$/
            level = $1.to_i
            title = render_children(node, state)
            header(title, level)

          when "i", "strong"
            italic(render_children(node, state))
          when "em", "b"
            emphasis(render_children(node, state))
          when "sup"
            superscript(render_children(node, state))
          when "u"
            underline(render_children(node, state))
          when "br"
            linebreak
          when "hr"
            separator

          when "p"
            paragraph(render_children(node, state).strip)
          when "div"
            div(render_children(node, state))

          when "ul"
            list(render_children(node, state), state.list_order)
          when "ol"
            content = render_children(node, state.with(:list_order => :ordered))
            list(content, state.list_order)
          when "li"
            list_item(render_children(node, state), state.list_order)

          when "code"
            block_code(render_children(node, state))
          when "blockquote"
            block_quote(render_children(node, state))

          when "table"
            header = nil
            rows   = []

            node.css("tr").each do |row|
              if (cells = row.css("th")).any?
                header = cells
              elsif (cells = row.css("td")).any?
                rows << cells
              end
            end

            rows = rows.map do |row|
              row.map do |cell|
                render_children(cell, state)
              end
            end

            if header
              header = header.map do |cell|
                render_children(cell, state)
              end
            end

            table(header, rows)

          when "html", "body", "nav", "span", "form", "label", "input", "button", "section", "fieldset",
               "menu", "article", "header", "time", "aside", "footer", "nobr", "wbr", 
               "table", "tr", "td", "th", "thead", "tbody", "noscript"
            render_children(node, state)

          when "head", "script", "link", "style"
            # skip it

          else
            raise "Unrecognized HTML tag: #{node.name} -> #{node.inspect}"
          end

        when Oga::XML::Comment
          # skip it

        else
          raise "Unhandled Oga node type: #{node.class}"
        end

      end

      results.join.strip

    end
  end

end
