require 'rails_helper'

RSpec.describe User, type: :model do
   it "building a user" do
     user = build(:user)
     expect(user).to be_a(User)
   end
   context "validations" do
     ## hard way to test validations without shoulda-matchers
     #it "must have a name" do
     #  user = build(:user, name: nil)
     #  user.valid? # check if can be saved
     #  expect(user.errors.messages).to include(:name)
     #end

     ## easy way using shoulda-matchers
     it "must have a name" do
       is_expected.to validate_presence_of(:name)
     end

     it "must have an email" do
       is_expected.to validate_presence_of(:email)
     end

     it "must have a password" do
       is_expected.to validate_presence_of(:password)
     end

     it "must have a valid email" do
       user = build(:user, email: '123456')
       user.valid?
       expect(user.errors.messages).to include(:email)
     end

     it "email must be unique" do
       is_expected.to validate_uniqueness_of(:email)
     end 
   end

   context "security" do
     #it "password mustn't be plain text" do
     #  user = create(:user, password: '123456')
     #  expect(user.password_digest).to_not eq('123456')
     #end

     it "password mustn't be in plain text on database" do
       expect have_secure_password
     end
   end
end
