#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "html-renderer"
  s.version     = File.read "VERSION"
  s.date        = File.mtime("VERSION").strftime("%Y-%m-%d")
  s.summary     = "HTML Renderer"
  s.description = "Easily implement an HTML renderer by creating a subclass and adding some methods, similar to RedCarpet. (Examples are included for rendering HTML to ANSI and plain text.)"
  s.homepage    = "http://github.com/epitron/html-renderer/"
  s.licenses    = ["WTFPL"]
  s.email       = "chris@ill-logic.com"
  s.authors     = ["epitron"]

  s.files            = `git ls`.lines.map(&:strip)
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  
  s.add_dependency "oga", "~> 2"
  s.add_dependency "terminal-table", "~> 1.8"
  s.add_dependency "term-ansicolor", "~> 1.7"
end
