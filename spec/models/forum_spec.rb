require File.dirname(__FILE__) + '/../spec_helper'

describe Forum do
  it "should be valid" do
    expect(Forum.new).to be_valid
  end
  
  it "should have topics" do
    expect(forums(:one).topics.load.to_a).to be_a_kind_of(Array)
  end
  
  it "should have posts" do
    expect(forums(:one).posts.load.to_a).to be_a_kind_of(Array)
  end
end
