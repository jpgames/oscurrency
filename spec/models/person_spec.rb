require File.dirname(__FILE__) + '/../spec_helper'

describe Person do

  before(:each) do
    @person = people(:quentin)
  end

  describe "attributes" do
    it "should be valid" do
      expect(create_person).to be_valid
    end

    it 'requires password' do
      p = create_person(:password => nil)
      expect(p.errors[:password]).to_not be_nil
    end

    it 'requires password confirmation' do
      p = create_person(:password_confirmation => nil)
      expect(p.errors[:password_confirmation]).to_not be_nil
    end

    it 'requires email' do
      p = create_person(:email => nil)
      expect(p.errors[:email]).to_not be_nil
    end

    it "should require name" do
      p = create_person(:name => nil)
      expect(p.errors[:name]).to_not be_nil
    end

    it "should strip spaces in email field" do
      expect(create_person(:email => 'example@example.com ')).to be_valid
    end

    it "should be valid even with a nil description" do
      p = create_person(:description => nil)
      expect(p).to be_valid
    end
  end

  describe "utility methods" do
    it "should have the right to_param method" do
      # Person params should have the form '1-michael-hartl'.
      param = "#{@person.id}-quentin"
      expect(@person.to_param).to eq(param)
    end

    it "should have a safe uri" do
      @person.name = "Michael & Hartl"
      param = "#{@person.id}-michael-and-hartl"
      expect(@person.to_param).to eq(param)
    end
  end

  describe "contact associations" do
    it "should have associated photos" do
      expect(@person.photos).to_not be_nil
    end

    it "should not currently have any photos" do
      expect(@person.photos).to be_empty
    end
  end

  describe "message associations" do
    it "should have sent messages" do
      expect(@person.sent_messages).to_not be_nil
    end

    it "should have received messages" do
      expect(@person.received_messages).to_not be_nil
    end
  end

  describe "activation" do

    it "should deactivate a person" do
      expect(@person).to_not be_deactivated
      @person.toggle(:deactivated)
      expect(@person).to be_deactivated
    end

    it "should reactivate a person" do
      @person.toggle(:deactivated)
      expect(@person).to be_deactivated
      @person.toggle(:deactivated)
      expect(@person).to_not be_deactivated
    end

    it "should have nil email verification" do
      person = create_person
      expect(person.email_verified).to be_nil
    end

    it "should have a working active? helper boolean" do
      expect(@person).to be_active
      enable_email_notifications
      @person.email_verified = false
      expect(@person).to_not be_active
      @person.email_verified = true
      expect(@person).to be_active
    end

    it "should hide and show connected requests after deactivation and then activation of user" do
      group = created_group_id(@person)
      @person.default_group_id = group.id
      @person.save
      create_request_like(@person, group)

      expect(Req.custom_search(nil, group, true, 1, 25, nil)).to_not be_empty
      @person.deactivated = true
      @person.save

      expect(Req.custom_search(nil, group, true, 1, 25, nil)).to be_empty
      @person.deactivated = false
      @person.save      
      expect(Req.custom_search(nil, group, true, 1, 25, nil)).to_not be_empty
    end

    it "should hide and show connected offers after deactivation and then activation of user" do
      group = created_group_id(@person)
      @person.default_group_id = group.id
      @person.save
      create_offer_like(@person, group)

      expect(Offer.custom_search(nil, group, true, 1, 25, nil)).to_not be_empty
      @person.deactivated = true
      @person.save

      expect(Offer.custom_search(nil, group, true, 1, 25, nil)).to be_empty
      @person.deactivated = false
      @person.save      
      expect(Offer.custom_search(nil, group, true, 1, 25, nil)).to_not be_empty
    end

  end

  describe "mostly active" do
    it "should include a recently logged-in person" do
      expect(Person.mostly_active).to contain(@person)
    end

    pending "should not include a deactivated person" do
      @person.toggle!(:deactivated)
      expect(Person.mostly_active).to_not contain(@person)
    end

    pending "should not include an email unverified person" do
      enable_email_notifications
      @person.email_verified = false; @person.save!
      expect(Person.mostly_active).to_not contain(@person)
    end

    it "should not include a person who has never logged in" do
      @person.last_logged_in_at = nil; @person.save
      expect(Person.mostly_active).to_not contain(@person)
    end

    it "should not include a person who logged in too long ago" do
      @person.last_logged_in_at = Person::TIME_AGO_FOR_MOSTLY_ACTIVE.ago - 1
      @person.save
      expect(Person.mostly_active).to_not contain(@person)
    end
  end

  describe "admin" do

    before(:each) do
      @person = people(:admin)
    end

    it "should un-admin a person" do
      expect(@person).to be_admin
      @person.toggle(:admin)
      expect(@person).to_not be_admin
    end

    it "should have a working last_admin? method" do
      expect(@person).to be_last_admin
      people(:aaron).toggle!(:admin)
      expect(@person).to_not be_last_admin
    end
  end

  describe "active class methods" do
    it "should not return deactivated people" do
      @person.toggle!(:deactivated)
      expect(Person.active).to_not contain(@person)
    end

    pending "should not return email unverified people" do
      @person.email_verified = false
      @person.save!
      expect(Person.active).to_not contain(@person)
    end
  end

  describe "your requests" do
    it "should not include requests associated with direct payments" do
      group = created_group_id(@person)
      @person.default_group_id = group.id
      @person.save
      pseudo_req = create_request_like(@person, group, false)
      expect(@person.reqs_for_group(group)).to_not contain(pseudo_req)
    end

    it "should include real requests" do
      group = created_group_id(@person)
      @person.default_group_id = group.id
      @person.save
      real_req = create_request_like(@person, group, true)
      expect(@person.reqs_for_group(group)).to contain(real_req)
    end
  end

  protected

    def create_request_like(person, group, biddable = true)
      request = Req.new( {
        :name => 'test req',
        :due_date => DateTime.now+1,
        :biddable => biddable
        })
      request.person_id = person.id
      request.group_id = group.id
      request.valid?
      request.save!
      request
    end

    def create_offer_like(person, group)
      offer = Offer.new({
        :description => 'test offer description',
        :available_count => 1,
        :group_id => group.id,
        :name => 'test offer',
        :expiration_date => DateTime.now + 1.day
        })
      offer.person_id = person.id
      
      offer.valid?
      offer.save!
      offer
    end

    def created_group_id(person)
      group = Group.new({
        :name => "test group",
        :description => "test group description"
        })
      group.update_attribute(:person_id, person.id)

      group.valid?
      group.save!
      group
    end

    def create_person(options = {})
      save_record = options[:save]
      options.delete(:save)
      record = Person.new({ :email => 'quire@example.com',
                            :password => 'quire',
                            :password_confirmation => 'quire',
                            :name => 'Quire',
                            :description => 'A new person' }.merge(options))
      record.valid?
      record.save! if save_record
      record
    end
end
