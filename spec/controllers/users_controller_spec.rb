require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it "a user can be created" do
    post :create, params: {
      user: {
        name: 'Lucas',
        email: 'lucas@teste.com',
        password: '123456'
      }
    }
    expect(response).to have_http_status(201)
    expect((JSON.parse response.body).symbolize_keys).to include(name: 'Lucas', email: 'lucas@teste.com')
  end

  it "a list of users is showed" do
    user_one = no_pass_user(create(:user)).first
    user_two = no_pass_user(create(:user)).first
    get :index
    expect(JSON.parse response.body).to include(user_one, user_two)
  end

  it "a user can be showed" do
    user = create(:user)
    get :show, params: { id: user.id }
    expect(JSON.parse response.body).to include(no_pass_user(user).first)
  end

  it "password cannot be showed on response body" do
    user = create(:user)
    get :show, params: { id: user.id }
    user_hash, password = no_pass_user(user)
    expect(JSON.parse response.body).to include(user_hash)
    expect(JSON.parse response.body).to_not include({"password_digest" => password}) 
  end

  it "can be destroyed" do
    user = create(:user)
    delete :destroy, params: { id: user.id }
    expect(response).to have_http_status(204)
    expect(User.find_by_id user.id).to be_nil
  end

  it "can be updated" do
    user = create(:user)
    patch :update, params: { id: user.id, user: { name: 'Modified Name' } }
    expect(User.find_by_id(user.id).name).to eq('Modified Name')
  end
end

def no_pass_user(user)
  user_hash = user.as_json
  password = user_hash.delete("password_digest")
  [ user_hash, password ]
end
