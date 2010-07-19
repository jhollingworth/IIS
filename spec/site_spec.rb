require "spec"
require 'mocha'
require 'mock_manager'
require File.dirname(__FILE__) + '/../lib/iis.rb'

describe "When adding a site that does not exist" do

  before(:each) do
    @site = mock()
    @manager = MockManager.new(lambda { mock() })
    @manager.sites.expects(:add).with('site').returns(@site)
    @manager.sites.expects('[]').with('site').returns(nil)
    @iis = IIS.new(@manager)
  end

  it "should should add the site and pass it to the yield block" do
    @iis.create(:site, 'site') do |site|
      site.should == @site
    end
  end

  after(:each) do
    @manager.verify_expectations
  end
end

describe "When adding an site that does exit" do

  before(:all) do
    @manager = MockManager.new (lambda { mock() })
    @manager.sites.expects('[]').with('site').returns(mock())
    @iis = IIS.new(@manager)
  end

  it "it will raise an error" do
    lambda { @iis.create(:site, 'site') }.should raise_error
  end

end

describe "When asking whether IIS has a site which is not present" do

  before(:all) do
    @manager = MockManager.new (lambda { mock() })
    @manager.sites.expects('[]').with('site').returns(nil)
    @iis = IIS.new(@manager)
  end

  it "should return false" do
    @iis.has?(:site, 'site').should == false
  end
end

describe "When asking whether IIS has a site which is not present" do

  before(:all) do
    @manager = MockManager.new (lambda { mock() })
    @manager.sites.expects('[]').with('site').returns(mock())
    @iis = IIS.new(@manager)
  end

  it "should return true" do
    @iis.has?(:site, 'site').should == true
  end
end