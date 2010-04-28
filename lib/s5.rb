require 'rubygems'
require 'redcloth'
require 'erb'
 
module RedCloth
  # Patch up
  class TextileDoc
    attr_accessor :settings
    
    def to_s5(*config)
      self.settings = config.last.is_a?(Hash) ? config.pop : {}
      apply_rules config
      to RedCloth::Formatters::S5
    end
  end
  
  module Formatters::S5
    include RedCloth::Formatters::HTML, ERB::Util
    attr_reader :settings
    
    def render(scope = nil, template_file = nil)
      template_file ||= settings[:template] || 'default.html.erb'
      template_data = File.read template_file
      code = ERB.new template_data, nil, '-'
      render_template code, scope
    end
    
    def render_template(code, scope = nil)
      scope ||= binding
      eval code.src, scope
    end
    
    def slide(opts)
      slide_end + "\n\n" + slide_start(opts) + "\n"
    end
    
    def after_transform(text)
      content = text
      content << slide_end if @slides_used
      text[0..-1] = render binding
    end
    
    def slide_start(opts = {})
      @slides_used  ||= true
      (opts[:class] ||= '') << ' slide'
      %[<div#{pba opts}><h1>#{h opts[:text]}</h1><div class="slidecontent">]
    end
    
    def annotation(opts)
      '</div><div class="handout">' + opts[:text].to_s
    end
    
    def slide_end
      '</div></div>'
    end
  end
end