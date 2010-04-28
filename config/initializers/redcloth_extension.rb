#module RedCloth::Formatters::HTML
#  include RedCloth::Formatters::Base
#  def before_transform(text)
#    text.chomp!
#    clean_html(text, ALLOWED_TAGS)
#  end
#  ALLOWED_TAGS = {}
#end