require File.dirname(__FILE__) + '/../spec_helper'

describe Message do
  
  before(:each) do
    @sender    = people(:quentin)
    @recipient = people(:aaron)
    @message   = new_message
  end
  
  it "should be valid" do
    expect(@message).to be_valid
  end
  
  it "should have the right sender" do
    expect(@message.sender).to eq(@sender)
  end
  
  it "should have the right recipient" do
    expect(@message.recipient).to eq(@recipient)
  end
  
  it "should require a subject" do
    expect(new_message(:subject => "")).to_not be_valid
  end
  
  it "should require content" do
    expect(new_message(:content => "")).to_not be_valid
  end
  
  it "should not be too long" do
    too_long_content = "a" * (Message::MAX_CONTENT_LENGTH + 1)
    expect(new_message(:content => too_long_content)).to_not be_valid
  end

  it "should be able to trash messages as sender" do
    @message.trash(@message.sender)
    expect(@message).to be_trashed(@message.sender)
    expect(@message).to_not be_trashed(@message.recipient)
  end
  
  it "should be able to trash message as recipient" do
    @message.trash(@message.recipient)
    expect(@message).to be_trashed(@message.recipient) 
    expect(@message).to_not be_trashed(@message.sender)
  end
  
  it "should untrash messages" do
    @message.trash(@message.sender)
    expect(@message).to be_trashed(@message.sender)
    @message.untrash(@message.sender)
    expect(@message).to_not be_trashed(@message.sender)
  end
  
  it "should handle replies" do
    @message.save!
    @reply = create_message(:sender    => @message.recipient,
                            :recipient => @message.sender,
                            :parent    => @message)
    expect(@reply).to be_reply
    expect(@reply.parent).to be_replied_to
  end

  it "should not allow anyone but recipient to reply" do
    @message.save!
    @next_message = create_message(:sender    => people(:kelly),
                                   :recipient => @message.sender,
                                   :parent    => @message)
    expect(@next_message).to_not be_reply
    expect(@next_message.parent).to_not be_replied_to
  end
  
  it "should mark messages as read" do
    @message.mark_as_read
    expect(@message).to be_read
  end
  
  it "should belong to a conversation" do
    expect(@message).to respond_to(:conversation)
  end

  it "should assign conversation ids properly" do
    @message.save!
    expect(@message.conversation).to_not be_nil
    @next_message = create_message(:sender    => people(:kelly),
                                   :recipient => @message.sender,
                                   :parent    => @message)
    expect(@next_message.conversation).to eq(@message.conversation)
  end

  it "should not include unread trashed messages in inbox count" do
    @message.save!
    @message.trash(@recipient)
    expect(@recipient.inbox_messages_count).to eq(0)
  end
    
  describe "email notifications" do
    
    before(:each) do
      @emails = ActionMailer::Base.deliveries
      @emails.clear
      @global_prefs = Preference.first
    end
    
    it "should not send an email when recipient's notifications are off" do
      @recipient.toggle!(:message_notifications)
      expect(@recipient.message_notifications).to eq(false)
      expect(lambda do
        @message.save
      end).to_not change(@emails, :length)
    end
  end


  private

    def new_message(options = { :sender => @sender, :recipient => @recipient })
      Message.unsafe_build({ :subject => "The subject",
                             :content => "Lorem ipsum" }.merge(options))
    end
  
    def create_message(options = { :sender => @sender,
                                   :recipient => @recipient })   
      Message.unsafe_create({ :subject => "The subject",
                              :content => "Lorem ipsum" }.merge(options))
    end
end
