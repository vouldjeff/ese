# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
#ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  #config.gem "declarative_authorization", :source => "http://gemcutter.org"
  #config.gem "friendly_id"
  config.gem "RedCloth", :version => ">= 3.301", :source => "http://code.whytheluckystiff.net/"

  #config.gem "ruby-openid", :lib => "openid"
  config.gem "authlogic"
  #config.gem "authlogic-oid", :lib => "authlogic_openid"
  #config.gem "facebooker"

  config.time_zone = "Sofia"

  config.action_controller.session = {
          :session_key => '_ese_session',
          :secret      => 'f3f57b71ef9345ffccd0c4e841d8e74bb2e7d2ef692a5303bb455fea0667a62d30458d17f95766b12906aa6c2a3c29d584a55dd18426ffc04610be49956a51af'
  }

  config.i18n.default_locale = :bg  
end

  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  	"<span class=\"error-field\">#{html_tag}</span>"
  end