class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]

  # GET /users
  def index
    @users = Rails.cache.fetch('users_index') do
      User.all.as_json
    end

    render json: @users, except: "password_digest"
  end

  # GET /users/1
  def show
    render json: @user, except: :password_digest
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      Rails.cache.delete 'users_index'
      render json: @user, except: :password_digest, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      Rails.cache.delete 'users_index'
      Rails.cache.delete "user_id#{params[:id]}"
      render json: @user, except: :password_digest
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = Rails.cache.fetch("user_id#{params[:id]}") do
        User.find(params[:id])
      end
      #@user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :birthdate)
    end
end
