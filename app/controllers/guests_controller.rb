class GuestsController < ApplicationController
  
  before_filter :find_guest, :only => [:show, :edit, :update, :destroy, :reset]
  before_filter :get_meals, :except => [:create, :update, :destroy]
  before_filter :authenticate_user, :only => [:destroy, :reset]
  after_filter  :email_guest, :only => [:create, :update]
  before_filter :check_lock

  def index
    @guests = Guest.all
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @guests }
    end
  end

  def show
    redirect_to([@guest.invitation])
  end

  def new
    @guest = Guest.new
    invitation = Invitation.find(params[:invitation_id]) if params[:invitation_id]
    if not invitation
      invitation = Invitation.new
      invitation.is_manual = true
      invitation.save
    end
    if not invitation.is_manual
      return false
    end
    @guest.invitation = invitation
    @guest.is_manual = true

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @guest }
    end
  end

  def edit
    
  end

  def create
    if params[:guest][:invitation]
      invitation_params = params[:guest][:invitation]
      params[:guest][:invitation] = nil
    end
    normalize params
    @guest = Guest.new(params[:guest])
    invitation = Invitation.find(params[:invitation_id])
    if not invitation.is_manual or (invitation.guests.length ||0) + 1 > (invitation.number_of_guests || 2)
      return false
    end
    @guest.invitation = invitation
    @guest.invitation.update_attributes(invitation_params) if invitation_params
    @guest.invitation.name ||= @guest.name
    @guest.invitation.save
    ap @guest
    respond_to do |format|
      if @guest.save
        flash[:notice] = 'Guest was successfully created.'
        format.html { redirect_to([@guest.invitation]) }
        format.json  { render :json => @guest, :status => :created, :location => [@guest.invitation] }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @guest.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    normalize params
    respond_to do |format|
      if @guest.update_attributes(params[:guest])
        if not @guest.reception
          @guest.meal_id = nil
          @guest.save
        end
        flash[:notice] = "#{@guest.first_name}&#8217;s RSVP was successfully updated.".html_safe
        format.html { redirect_to([@guest.invitation]) }
        format.json  { head :ok }
      else
        puts @guest.errors
        format.html { render :action => "edit" }
        format.json  { render :json => @guest.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @guest.destroy
    respond_to do |format|
      flash[:notice] = "#{@guest.first_name}&#8217;s RSVP was successfully destroyed.".html_safe
      format.html { redirect_to("/admin/guests") }
      format.json  { head :ok }
    end
  end

  def reset
    @guest.reset
    if @guest.save
      flash[:notice] = "#{@guest.first_name}&#8217;s RSVP was successfully reset.".html_safe
      respond_to do |format|
        format.html { redirect_to("/admin/guests") }
        format.json  { head :ok }
      end
    else
      puts @guest.errors
      format.html { render :action => "edit" }
      format.json  { render :json => @guest.errors, :status => :unprocessable_entity }
    end
  end

  private
  def find_guest
    @guest = Guest.find(params[:id])
  end
  def get_meals
    @meals = Meal.all
  end

  def normalize params
    params[:guest].each do |param, value|
      if %w(ceremony reception).include? param
        if value.match /not/
          params[:guest][param] = false
        elsif value.match /attending/
          params[:guest][param] = true
        end
      end
    end
  end

  def email_guest
    begin
      if Rails.env == 'production'
        email "RSVP Update for #{@guest.name}", 
        render_to_string(:template => "admin/guest", :layout => 'email', :locals => {:guest => @guest}) + "<hr /> <div id='#{@guest.id}' class='yaml'>#{@guest.to_yaml}</div>"
      end
    rescue
      puts "Error e-mailing guest update information for #{@guest.name}"
    end
  end

end
