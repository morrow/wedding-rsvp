class AdminController < ApplicationController
  
  before_filter :authenticate_user

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @admins }
    end
  end

  def guests
    @guests = Guest.all
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @admin }
      format.csv { render :layout => false  }
      format.pdf
    end
  end

  def invitations
    @invitations = Invitation.all
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @admin }
      format.csv { render :layout => false }
    end
  end

  def meals
    @meals = Meal.all
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @admin }
    end
  end

  def deadline
    @admin = Admin.first
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @admin }
    end
  end

  def update
    #normalize params
    @admin = Admin.first
    previous_status = @admin.global_lock
    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        flash[:notice] = "Successfully updated deadline."
        if previous_status != @admin.global_lock
          if @admin.global_lock
            status = "LOCKED"
          elsif @admin.global_lock == false
            status = "UNLOCKED"
          elsif @admin.global_lock == nil
            status = "AUTOMATIC"
          end
        flash[:notice] += "  RSVP system is now #{status}.".html_safe
        end
        format.html { redirect_to("/admin/deadline") }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      redirect_to("/admin/deadline")
    end
  end

end
