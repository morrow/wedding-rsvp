class StaticController < ApplicationController

  def home
    redirect_to ("/")
  end

  def index
  end

  def information
  end

  def directions
  end

  def accommodations
  end

  def pictures
  end

  def contact
  end

  def wedding_party
  end

  def rsvp
    if params[:invitation_code]
      redirect_to "/invitations/#{params[:invitation_code]}"
    end
  end

end
