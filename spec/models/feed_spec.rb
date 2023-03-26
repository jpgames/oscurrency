require File.dirname(__FILE__) + '/../spec_helper'

describe Feed do
  before(:each) do
    @feed = Feed.new
  end

  it "should be valid" do
    expect(@feed).to be_valid
  end
end
