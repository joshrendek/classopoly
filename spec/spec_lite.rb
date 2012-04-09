require 'yaml'
require 'active_record'
require 'active_support'
require 'active_model'
require 'arel'
require 'rspec'
require 'spec_coverage'

raw_config = File.read(File.dirname(__FILE__) + "/../config/database.yml")
DB_CONFIG = YAML.load(raw_config)
ActiveRecord::Base.establish_connection(
  :adapter => DB_CONFIG["test"]["adapter"],
  :host => DB_CONFIG["test"]["host"],
  :username => DB_CONFIG["test"]["username"],
  :password => DB_CONFIG["test"]["password"],
  :database => DB_CONFIG["test"]["database"]
)


