require 'rubygems'
require "spec"
require File.dirname(__FILE__) + '/../lib/iis.rb'


iis = IIS.new

iis.delete(:app_pool, 'test_app_pool')
iis.delete(:site, 'test_site')

iis.create(:app_pool, 'test_app_pool') do |app_pool|
  app_pool.name.should == 'test_app_pool'
end

iis.create(:site, 'test_site', :path => 'c:\temp', :port => 82) do |site|
  site.application_defaults.application_pool_name = 'test_app_pool'
end

iis.has?(:app_pool, 'test_app_pool').should == true
iis.has?(:site, 'test_site').should == true

iis.delete(:app_pool, 'test_app_pool')
iis.delete(:site, 'test_site')

iis.has?(:app_pool, 'test_app_pool').should == false
iis.has?(:site, 'test_site').should == false
