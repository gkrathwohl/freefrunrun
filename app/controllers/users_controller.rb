class UsersController < ApplicationController

  def show

    if !current_user || current_user.id != params[:id].to_i
      redirect_to :root
    end


    @races = current_user.races
  end

end