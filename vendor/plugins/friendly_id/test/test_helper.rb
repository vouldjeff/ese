$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

$KCODE = 'UTF8' if RUBY_VERSION < '1.9'
$VERBOSE = false

require 'rubygems'
require 'test/unit'
require 'contest'
require 'mocha'

# You can use "rake test AR_VERSION=2.2.3" to test against 2.2.3 for example.
# The default is to use the latest installed ActiveRecord.
if ENV["AR_VERSION"]
  gem 'activerecord', "#{ENV["AR_VERSION"]}"
  gem 'activesupport', "#{ENV["AR_VERSION"]}"
end

require 'active_record'
require 'active_support'
require 'friendly_id'
require File.dirname(__FILE__) + '/../generators/friendly_id/templates/create_slugs'

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

def table(name, sql)
  "CREATE TABLE #{name} (id INTEGER PRIMARY KEY AUTOINCREMENT, #{sql})"
end

def schema(&block)
  ActiveRecord::Migration.verbose = false
  CreateSlugs.up
  yield ActiveRecord::Base.connection
end

class ActiveRecord::Base
  def log_protected_attribute_removal(*args)
  end
end

schema do |conn|
  conn.execute table("books", "name VARCHAR, type VARCHAR")
  conn.execute table("cities", "name VARCHAR, my_slug VARCHAR, population INTEGER")
  conn.execute table("countries", "name VARCHAR")
  conn.execute table("districts", "name VARCHAR, cached_slug VARCHAR")
  conn.execute table("events", "name VARCHAR, event_date TIMESTAMP")
  conn.execute table("legacy_table", "name VARCHAR")
  conn.execute table("people", "name VARCHAR")
  conn.execute table("posts", "name VARCHAR, published BOOLEAN")
  conn.execute table("residents", "name VARCHAR, country_id INTEGER")
  conn.execute table("users", "name VARCHAR")
end

# A model that uses the automagically configured "cached_slug" column
class District < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
end

# A model that specifies a custom cached slug column
class City < ActiveRecord::Base
  attr_accessible :name
  has_friendly_id :name, :use_slug => true, :cache_column => 'my_slug'
end

# A model with a custom slug text normalizer
class Person < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true do |text|
    text.upcase
  end
end

# A slugged model that uses a scope
class Resident < ActiveRecord::Base
  belongs_to :country
  has_friendly_id :name, :use_slug => true, :scope => :country
end

# A model used as a scope
class Country < ActiveRecord::Base
  has_many :people
  has_friendly_id :name, :use_slug => true
end

# A model that doesn't use slugs
class User < ActiveRecord::Base
  has_friendly_id :name
end

# A model that uses default slug settings and has a named scope
class Post < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
  named_scope :published, :conditions => { :published => true }
end

# Model that uses a custom table name
class Place < ActiveRecord::Base
  self.table_name = "legacy_table"
  has_friendly_id :name, :use_slug => true
end

# A model that uses a datetime field for its friendly_id
class Event < ActiveRecord::Base
  has_friendly_id :event_date, :use_slug => true
end

# A base model for single table inheritence
class Book < ActiveRecord::Base;
end

# A model that uses STI
class Novel < ::Book
  has_friendly_id :name, :use_slug => true
end
