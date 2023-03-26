require File.dirname(__FILE__) + '/../spec_helper'

describe Conversation do
  
  before(:each) do
    @conversation = conversations(:one)
  end

  it "should have many messages" do
    expect(@conversation).to respond_to(:messages)
  end
  
  it "should order messages by most recent first" do
    sorted_messages = @conversation.messages.sort_by(&:created_at)
    expect(@conversation.messages).to eq(sorted_messages)
  end
end
