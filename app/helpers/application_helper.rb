# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  include RedCloth::Formatters::Base
  include RedCloth::Formatters::HTML
  require 'lib/ese_cloth'

  def add_new_child(text, id, partial, object)
    link_to_function text, :class => 'remove-link' do |page|
      page.insert_html :bottom, id, :partial => partial, :object => object
    end
  end

  def remove_child(type, what = false)
    unless what
      link_to_function t('destroy'), "this.up('.#{type}').remove()", :class => 'remove-link'
    else
      link_to_function t('destroy'), "mark_for_destroy(this, '#{type}')", :class => 'remove-link'
    end
  end

  def is_teacher?
    current_user.roles.map do |role|
      return true if role[:id] == 2 or role[:id] == 1
    end
    return false
  end

  def textile(text)
    #text.chomp!
    #clean_html(text, {}) # Allowed tags are put in the dictionary
    
    extensions_replace RedCloth.new(text).extend(CustomHTML).to_html()
  end
  
  def format_datetime(time)
    time.strftime("%H:%M#{t('abbr_hours')} %d.%m.%Y#{t('abbr_year')}")
  end
  
  private
  
  # TODO: rewrite corrrectly
  def extensions_replace(text)
    text.sub!(/\[latex\](.*)\[\/latex\]/, 
    '<img src="http://chart.apis.google.com/chart?cht=tx&chl=\1" class="latex" alt="\1" />')
    
    text.sub!(/\{\[(.*)\]\}/, 
    '<img src="http://chart.apis.google.com/chart?cht=tx&chl=\1" class="latex" alt="\1" />')
    
    text
  end
end
