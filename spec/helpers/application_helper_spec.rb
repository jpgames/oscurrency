require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do

  describe "#first_n_words" do

    it "leaves short sentences untouched" do
      sentence = "a b  c   d"
      expect(helper.first_n_words(sentence)).to eq(sentence)
    end

    it "shortens long sentences" do
      sentence = "a b  c   d " * 8
      sentence.strip!
      shortened = helper.first_n_words(sentence)
      expect(shortened).to_not eq(sentence)
      expect(shortened.split.size).to eq(20)
      expect(sentence).to start_with(shortened)
    end

    it "shortens long sentences (specified length)" do
      sentence = "a b  c   d " * 3
      sentence.strip!
      shortened = helper.first_n_words(sentence, 8)
      expect(shortened).to_not eq(sentence)
      expect(shortened.split.size).to eq(8)
      expect(sentence).to start_with(shortened)
    end

  end

end
