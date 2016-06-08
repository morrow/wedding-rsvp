class InvitationsController < ApplicationController
  
  before_filter :find_invitation, :only => [:show, :edit, :update, :destroy]
  before_filter :authenticate_user, :only => [:destroy]
  before_filter :check_lock

  # rescue
  rescue_from ActiveRecord::RecordNotFound, :with => :id_not_found

  # GET /invitations
  # GET /invitations.json
  def index
    if true
      redirect_to :controller => 'static', :action => 'rsvp'
    else
      @invitations = Invitation.all
      respond_to do |format|
        format.html # index.html.erb
        format.json  { render :json => @invitations }
      end
    end
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
    if params[:id].match(/[a-z]/)
      redirect_to :controller => 'invitations', :action => 'show', :id => params[:id].upcase!
    end
    @invitation = Invitation.find(params[:id])
    @guests = @invitation.guests
    @meals = Meal.all
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @invitations }
    end
   end

  # GET /invitations/new
  # GET /invitations/new.json
  def new
    @invitation = Invitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @invitation }
    end
  end

  # GET /invitations/1/edit
  def edit
  end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.new(params[:invitation])

    respond_to do |format|
      if @invitation.save
        flash[:notice] = 'Invitation was successfully created.'
        format.html { redirect_to(@invitation) }
        format.json  { render :json => @invitation, :status => :created, :location => @invitation }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitations/1
  # PUT /invitations/1.json
  def update
    respond_to do |format|
      if @invitation.update_attributes(params[:invitation])
        flash[:notice] = 'Invitation was successfully updated.'
        format.html { redirect_to(@invitation) }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to("/admin/invitations") }
      format.json  { head :ok }
    end
  end

  private
  def find_invitation
    @invitation = Invitation.find(params[:id])
  end

  def id_not_found
    if params[:id].match(/[a-z]/)
      redirect_to :controller => 'invitations', :action => 'show', :id => params[:id].upcase!
    else
      flash[:warning] = "Couldn't find an RSVP with id #{params[:id]}.  Please check your spelling and try again."
      redirect_to('/rsvp')
    end
  end
  
  
end
