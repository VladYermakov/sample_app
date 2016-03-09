require 'spec_helper'
require "rails_helper"

describe User do
  
  before do 
  	@user_ok = User.new(name: "Example user", email: "user@example.com",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_blank_name = User.new(name: " ", email: "vlad@mail.e",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_blank_email = User.new(name: "Meow", email: " ",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_invalid_email = User.new(name: "Vlad", email: "2@qwe..fs",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_long_name = User.new(name: "a"*51, email: "email@e.mail",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_short_name = User.new(name: "a", email: "a@a.a",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_valid_email = User.new(name: "Vlad", email: "vladikthebest97@gmail.com",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_another_valid_email = User.new(name: "Vlad", email: "yermakov.v.o@gmail.com",
  						password: 'foobar', password_confirmation: 'foobar')
  	@user_with_blank_password = User.new(name: "Woof", email: "woof@dog.com", 
  		                password: "", password_confirmation: "")
  	@user_with_different_password_and_confirmation = User.new(name: "Moo", email: "moo@cow.org",
  						password: "moomoomoo", password_confirmation: "moomoo...")
  	@user_from_example = User.new(name: "Sex", email: "sex@sex.xxx",
  						password: "iloveporn", password_confirmation: "iloveporn")
  	@user_with_short_password = User.new(name: "Vasya", email: "vasya.lover@uzhnu.edu.ua",
  						password: "aaaaa", password_confirmation: "aaaaa")
    @user = User.new(name: "Example user", email: "vlad@gmail.com",
              password: "foobar", password_confirmation: "foobar")
  end

  subject { @user_ok }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user_ok.save!
      @user_ok.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "remember token" do

  	before { @user_ok.save }

  	#its(:remember_token) { should_not be_blank }
  	it { expect(@user_ok.remember_token).not_to be_blank }

  end

  describe "when name is too short" do
    
    subject { @user_with_short_name }

    it { should_not be_valid }

  end

  describe "when name is too long" do

    subject { @user_with_long_name }

    it { should_not be_valid }

  end

  describe "when name is not valid" do
  
  	subject {@user_with_blank_name}

    it {should_not be_valid}
  
  end

  describe "when email is blank" do
  
  	subject {@user_with_blank_email}

    it {should_not be_valid}

  end

  describe "when email is not valid" do
  
    subject {@user_with_invalid_email}

    it {should_not be_valid}

  end

  describe "when all is ok" do

  	subject {@user_with_valid_email}

  	it {should be_valid}

  end

  describe "when all is ok too" do

  	subject {@user_with_another_valid_email}

  	it {should be_valid}

  end

  describe "when email is already taken" do

  	before do 

  	  @user_with_some_email_like_user_ok = @user_ok.dup
  	  @user_with_some_email_like_user_ok.email.upcase!
  	  @user_with_some_email_like_user_ok.save

  	end

  	subject {@user_with_some_email_like_user_ok}

  	it {should_not be_valid}
  
  end

  describe "when password if blank" do
    
    subject {@user_with_blank_password}

    it {should_not be_valid}

  end

  describe "when password doesn't match confirmation" do

    subject {@user_with_different_password_and_confirmation}

    it {should_not be_valid}

  end

  describe "return value of authenticate method" do
  
    subject {@user_from_example}

    before { @user_from_example.save }
    let(:found_user) { User.find_by(email: @user_from_example.email) }

    describe "with valid password" do
      
      it { should eq found_user.authenticate(@user_from_example.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      describe "" do
    
      	subject {user_for_invalid_password}
        specify { expect(user_for_invalid_password).to be false }
        it {should be false}
    
      end
    
    end
  
  end

  describe "when password too short" do

  	subject {@user_with_short_password}

  	it {should be_invalid}

  end


  describe "micropost associations" do

    before { @user.save }
      
    let!(:older_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }
    let!(:newer_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }

    it "should have right microposts in right order" do

      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]

    end

    it "should destroy associated microposts" do

      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each { |micropost| expect(Micropost.where(id: micropost.id)).to be_empty }

    end

    describe "status" do

      subject { @user }

      let(:unfollowed_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
      let(:followed_user) { FactoryGirl.create(:user) }

      before do

        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }

      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do

        followed_user.microposts.each do |micropost|

          should include(micropost)

        end

      end

    end

  end

  describe "following" do

    let(:other_user) { FactoryGirl.create(:user) }
    before do

      @user.save
      @user.follow!(other_user)

    end

    subject { @user }

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
    
      subject { other_user }
      its(:followers) { should include(@user) }
    
    end

    describe "and unfollowing" do
    
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    
    end



  end

end
