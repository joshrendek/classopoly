require 'yaml'
require 'active_record'
require 'active_support'
require 'active_model'
require 'arel'
require 'rspec'


require 'simplecov'
SimpleCov.start do 
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Libs", "lib"
  add_filter "/devise/"
  add_filter "/features/"
  # add_filter "/users/"
  # add_filter "/controllers/"
end



raw_config = File.read(File.dirname(__FILE__) + "/../config/database.yml")
DB_CONFIG = YAML.load(raw_config)
ActiveRecord::Base.establish_connection(
  :adapter => DB_CONFIG["test"]["adapter"],
  :host => DB_CONFIG["test"]["host"],
  :username => DB_CONFIG["test"]["username"],
  :password => DB_CONFIG["test"]["password"],
  :database => DB_CONFIG["test"]["database"]
)


