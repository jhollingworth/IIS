require 'mocha'
require "spec"

class MockManager
  attr_accessor :application_pools, :sites

  def initialize(mock)
    @application_pools = mock.call
    @sites = mock.call
    @commit_changes_called = false
  end

  def commit_changes
    @commit_changes_called = true
  end

  def verify_expectations()
    @commit_changes_called.should == true
  end
end