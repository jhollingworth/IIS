require "spec"
require 'mocha'
require 'mock_manager'
require File.dirname(__FILE__) + '/../lib/iis.rb'

describe "When adding an app pool that does not exit" do

  before(:each) do
    @app_pool = mock()
    @manager = MockManager.new(lambda { mock() })
    @manager.application_pools.expects(:add).with('app_pool').returns(@app_pool)
    @manager.application_pools.expects('[]').with('app_pool').returns(nil)
    @iis = IIS.new(@manager)
  end

  it "it will add the app pool and pass it to the yield block" do
    @iis.create(:app_pool, 'app_pool') do |app_pool|
      app_pool.should == @app_pool
    end
  end

  after(:each) do
    @manager.verify_expectations
  end
end

describe "When adding an app pool that does exit" do

  before(:all) do
    @manager = MockManager.new (lambda { mock() })
    @manager.application_pools.expects('[]').with('app_pool').returns(mock())
    @iis = IIS.new(@manager)
  end

  it "it will raise an error" do
    lambda { @iis.create(:app_pool, 'app_pool') }.should raise_error 
  end

end

describe "When getting an app pool that exists" do

  before(:each) do
    @app_pool = mock()
    @manager = MockManager.new (lambda { mock() })
    @manager.application_pools.expects('[]').with('app_pool').returns(@app_pool)
    @iis = IIS.new(@manager)
  end

  it "should return the app pool" do
    @iis.get(:app_pool, 'app_pool').should == @app_pool  
  end
end


