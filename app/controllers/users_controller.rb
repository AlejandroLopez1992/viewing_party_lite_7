# frozen_string_literal: true

class UsersController < ApplicationController
  def new; end

  def create
    user = User.new(user_params)
    if user.save 
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      redirect_to register_path
      flash[:alert] = "Error: #{error_message(user.errors)}"
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  def login_form 
  end

  def login_user
    user = User.find_by(name: user_params[:name])
    if user && user.authenticate(user_params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      redirect_to dashboard_path
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    end
  end

  private

  def user_params
    params.permit(:id, :name, :email, :password, :password_confirmation)
  end
end
