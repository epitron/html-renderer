require 'html-renderer'
require 'ansi/mixin'
require 'terminal-table'
require 'coderay'

class String
  include ANSI::Mixin

  def grey; self.black.bold; end
end


class ANSIRenderer < HTMLRenderer::Base

private

  def indented?(text)
    indent_sizes = text.lines.map{ |line| if line =~ /^(\s+)/ then $1 else '' end }.map(&:size)
    indent_sizes.all? {|dent| dent > 0 }
  end

  def unwrap(text)
    return text unless indented? text
    text.lines.to_a.map(&:strip).join ' '
  end

  def indent(text,amount=2)
    text.lines.map{|line| " "*amount + line }.join
  end

  def smash(s)
    s&.downcase&.scan(/\w+/)&.join
  end


public

  def normal_text(text)
    text
  end

  def raw_html(html)
    ''
  end

  def underline(content)
    content.magenta.bold
  end

  def superscript(content)
    "^(#{content})"
  end

  def link(link, title, content)
    unless content&.[] /^Back /
      str = ""
      # str += "<15>#{content}</15>" if content
      str += content.white.bold if content
      if smash(link) != smash(content)
        # str += " <8>(</8><11>#{link}</11><8>)</8>"
        str += " #{"(".grey}#{link.cyan.bold}#{")".grey}"
      end

      str
    end
  end

  def image(link, title, content)
    link(link, nil, title)
  end

  def italic(text)
    text.light_yellow
  end

  def block_code(code, language)
    language ||= :ruby

    language = language[1..-1] if language[0] == "."  # strip leading "."
    language = :cpp if language == "C++"

    require 'coderay'
    "#{indent CodeRay.scan(code, language).term, 4}\n"
  end

  def block_quote(text)
    indent paragraph(text)
  end

  def codespan(code)
    code.cyan
  end

  def header(title, level, anchor=nil)
    bar = ("-"*(title.size+4)).grey

    title = case level
      when 1 then title.bold.yellow
      when 2 then title.bold.cyan
      when 3 then title.bold.blue
      else title.purple
    end

    "#{bar}\n  #{title}\n#{bar}\n\n"
  end

  def double_emphasis(text)
    text.bold.green
  end

  def emphasis(text)
    text.green
  end

  def linebreak
    "\n"
  end

  def paragraph(text)
    div(text) + "\n"
  end

  def div(text)
    "#{indented?(text) ? text : unwrap(text)}\n"
  end

  def list(content, list_type)
    case list_type
    when :ordered
      @counter = 0
      "#{content}\n"
    when :unordered
      "#{content}\n"
    end
  end

  def list_item(content, list_type)
    case list_type
    when :ordered
      @counter ||= 0
      @counter += 1
      # "  <8>#{@counter}.</8> #{content.strip}\n".colorize
      "  #{@counter.to_s.grey}. #{content.strip}\n"
    when :unordered
      # "  <8>*</8> #{content.strip}\n".colorize
      "  #{"*".grey} #{content.strip}\n"
    end
  end

  def table(header, rows)
    if header
      table = Terminal::Table.new(headings: header, rows: rows)
    else
      table = Terminal::Table.new(rows: rows)
    end
    "#{table}\n\n"
  end

  def separator
    "_____________________________\n\n"
  end

end


if __FILE__ == $0
  puts ANSIRenderer.render(open("test.html"))
end