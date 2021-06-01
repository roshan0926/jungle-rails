require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    before do
      @user = User.new(:first_name => "Roseanna", :last_name => "Bowen", :email => "roseannab@example.com", :password => "123456", :password_confirmation => "123456")
    end

    it "is valid and has valid attributes" do
      @user.save
      expect(@user).to be_valid
      expect(@user.errors.full_messages).to be_empty
    end

     it "is not valid because it is lacking a first name" do
      @user.first_name = nil
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include ("First name can't be blank")
    end

    it "is not valid because it is lacking a last name" do
      @user.last_name = nil
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include ("Last name can't be blank")
    end

    it "is not valid because it is lacking an email" do
      @user.email = nil
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include ("Email can't be blank")
    end

    it "is not valid because it is lacking a pasword" do
      @user.password = nil
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include ("Password can't be blank")
    end

    it "is not valid because it is lacking the pasword confirmation" do
      @user.password_confirmation = nil
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include ("Password confirmation can't be blank")
    end

    it "is not valid when password and password_confirmation don't match" do
      @user.password_confirmation = "abcdef"
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include ("Password confirmation doesn't match Password")
    end

    it "is not valid when email isn't unique (case insensitive)" do
      same_as_user = User.create(
        first_name: "Roseanna",
        last_name: "Bowen",  
        email: "roseannab@example.com", 
        password: "098765", 
        password_confirmation: "098765"
      )
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include ("Email has already been taken")
    end

    it "is not valid when password is less than 6 characters" do
      @user.password = "123"
      @user.password_confirmation = "123"
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include ("Password is too short (minimum is 6 characters)")
    end

    describe '.authenticate_with_credentials' do
      it "authenticates when credentials are valid" do
        @user.save!
        auth = User.authenticate_with_credentials(@user.email, @user.password)
        expect(auth).to eq @user
      end

      it "does not authenticate when email is incorrect" do
        @user.save!
        auth = User.authenticate_with_credentials("random@gmail.com", @user.password)
        expect(auth).to eq nil
      end

      it "does not authenticate when a password is incorrect" do
        @user.save!
        auth = User.authenticate_with_credentials(@user.email, "incorrect123")
        expect(auth).to eq nil
      end

      it "authenticates when the email is correct but contains whitespace around it" do
        @user.save!
        auth = User.authenticate_with_credentials("   " + @user.email + "  ", @user.password)
        expect(auth).to eq @user
      end

      it "authenticates when email is correct but with wrong letter casing" do
        @user.save!
        auth = User.authenticate_with_credentials("RoSeaNNab@ExAMpLe.cOm", @user.password)
        expect(auth).to eq @user
      end
    end
  end 
end