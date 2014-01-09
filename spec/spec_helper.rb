require 'rubygems'
require 'bundler'

Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'schenker.rb')
# Dir["./spec/support/**/*.rb"].each {|f| require f}

