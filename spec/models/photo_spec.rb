require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do

  before(:each) do
    @filename = "rails.png"
    @person = people(:quentin)
    @image = uploaded_file(@filename, "image/png")
  end

  it "should upload successfully" do
    expect(new_photo).to be_valid
  end

  it "should be able to make a primary photo" do
    expect(new_photo(:primary => true)).to be_primary
  end

  it "should be able to make a non-primary photo" do
    expect(new_photo(:primary => false)).to_not be_primary
  end


  it "should have an associated person" do
    expect(new_photo.photoable).to eq(@person)
  end

  private

    def new_photo(options = {})
      Photo.new({:photoable => @person }.merge(options))
    end
end
