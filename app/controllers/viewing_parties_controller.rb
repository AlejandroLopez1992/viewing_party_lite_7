class ViewingPartiesController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @movie = MovieService.movie_search(params[:movie_id])
    @users = User.where.not(id: @user.id)
  end

  def create
    @user = User.find(params[:user_id])
    @movie = MovieService.movie_search(params[:movie_id])
    if @movie[:runtime] <= params[:duration].to_i
      viewing_party = ViewingParty.new(viewing_party_params)
      if viewing_party.save && !params[:selected_users].nil?
        user = @user.user_viewing_parties.new(user_id: @user.id, viewing_party_id: viewing_party.id, host: true)
        user.save
        params[:selected_users].each do |users_id|
          UserViewingParty.new(user_id: users_id, viewing_party_id: viewing_party.id).save
        end
        redirect_to dashboard_path
      elsif params[:selected_users].nil?
        redirect_to new_user_movie_viewing_party_path(@user, @movie[:id])
        flash[:alert] = "Error: Must add users! Don't be a loner!"
      else
        redirect_to new_user_movie_viewing_party_path(@user, @movie[:id])
        flash[:alert] = "Error: #{error_message(viewing_party.errors)}"
      end
    else
      redirect_to new_user_movie_viewing_party_path(@user, @movie[:id])
      flash[:alert] = "Error: Duration must be longer than movie runtime."
    end
  end

  private

  def viewing_party_params
    params.permit(:id, :duration, :date, :time, :movie_id)
  end
end