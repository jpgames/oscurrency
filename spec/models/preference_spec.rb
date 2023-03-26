require File.dirname(__FILE__) + '/../spec_helper'

describe Preference do
  describe "static global preference" do
    it "should prohibit multiple preference objects" do
      @preferences = Preference.new
      expect(@preferences.save).to be_falsey
      expect(@preferences.errors.full_messages).to include('Attempting to instantiate another Preference object')
    end
  end

  describe "non-boolean attributes" do
    before(:each) do
      @preferences = Preference.new
    end

    it "should have an analytics field" do
      expect(@preferences).to respond_to(:analytics)
    end

    it "should have a blank initial analytics" do
      expect(@preferences.analytics).to be_blank
    end
  end
end
