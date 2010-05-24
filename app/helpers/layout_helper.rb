# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper  
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def keywords(page_keywords)
    @content_for_keywords = page_keywords.to_s
  end

  def description(page_description)
    @content_for_description = page_description.to_s
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def menu(menu)
  	@content_for_menu = Array.new if @content_for_menu.nil?
  	@content_for_menu << menu.to_s
  end

  def nav(link)
    @content_for_nav = Array.new if @content_for_nav.nil?
    @content_for_nav << link.to_s
  end
end
