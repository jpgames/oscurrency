require File.dirname(__FILE__) + '/../spec_helper'

describe ForumPost do

  fixtures :topics, :forums, :groups

  before(:each) do
    @post = ForumPost.new(:body => "Hey there")
    @post.topic  = topics(:one)
    @post.person = people(:quentin)
  end

  it "should be valid" do
    expect(@post).to be_valid
  end

  it "should require a body" do
    post = ForumPost.new
    expect(post).to_not be_valid
    expect(post.errors[:body]).to_not be_empty
  end

  describe "associations" do

    before(:each) do
      @post.save!
      @activity = Activity.find_by(item_id: @post.id)
    end

    it "should have an activity" do
      expect(@activity).to_not be_nil
    end

    it "should add an activity to the poster" do
      expect(@post.person.recent_activity).to contain(@activity)
    end
  end
end
