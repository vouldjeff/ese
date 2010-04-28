require 'rubygems'
require 'redcloth'
require 'addressable/uri'
 
module CustomHTML
  
  def code(opts)
    "<code>#{opts[:text]}</code>"
  end
  
  def latex(opts)
    "<img src=\"http://chart.apis.google.com/chart?cht=tx&chl=#{opts[:text]}\" class=\"latex\" alt=\"#{opts[:text]}\" />"
  end
  
  def inline(opts)
    "#{opts[:text]}"
  end
  
  # map. google link
  def map(opts)
    begin
      uri = Addressable::URI.parse(opts[:text])
      if !uri.query_values['amp;ll'].nil?
        location = uri.query_values['amp;ll']
      elsif !uri.query_values['amp;q'].nil?
        if uri.query_values['amp;q'].match(',') == true and uri.query_values['amp;q'].split(',').count == 2
          location = uri.query_values['amp;q']
        else
          return "<strong>#{I18n.t('wrong_link')}</strong>"
        end
      else
        return "<strong>#{I18n.t('wrong_link')}</strong>"
      end
      
      (l1, l2) = location.split(",")
      if @counter.nil?
        @counter = 0
      end
      @counter += 1
      
      map = GMap.new("map_div_#{@counter}")
      map.control_init(:small_map => true, :map_type => true)
      map.center_zoom_init([l1.to_f, l2.to_f], uri.query_values['amp;z'].to_f)
  
      "#{map.to_html}" + "#{map.div(:width => 400, :height => 300)}"
    rescue
      return "<strong>#{I18n.t('wrong_link')}</strong>"
    end
  end
  
  # geogebra. filename
  def geogebra(opts)
    "<applet code=\"geogebra.GeoGebraApplet\" archive=\"http://www.geogebra.org/webstart/geogebra.jar\" width=\"800\" height=\"400\">
  <param name=\"filename\" value=\"#{opts[:text]}\"/>
  <param name=\"framePossible\" value=\"false\"/>
Please <a href=\"http://java.sun.com/getjava\">install Java 1.4</a> (or later) to use this page.
</applet>"
  end
end
