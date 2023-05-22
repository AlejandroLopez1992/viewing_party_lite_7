# frozen_string_literal: true

class UsersController < ApplicationController
  def new; end

  def create
    user = User.new(user_params)
    if user.save 
      redirect_to user_path(user)
    else
      redirect_to new_user_path
      flash[:alert] = "Error: #{error_message(user.errors)}"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def login_form 
  end

  def login_user
    user = User.find_by(name: user_params[:name])
    begin 
      if user.authenticate(user_params[:password])
      flash[:success] = "Welcome, #{user.name}"
      redirect_to user_path(user)
      else
        flash[:error] = "Sorry, your credentials are bad."
        render :login_form
      end
    rescue NoMethodError
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  private

  def user_params
    params.permit(:id, :name, :email, :password, :password_confirmation)
  end
end
