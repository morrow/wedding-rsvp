class MealsController < ApplicationController
  
  before_filter :find_meal, :only => [:show, :edit, :update, :destroy]
  before_filter :authenticate_user, :except => [:index, :show]

  def index
    @meals = Meal.all
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @meals }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @meal }
    end
  end

  def new
    @meal = Meal.new
    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @meal }
    end
  end

  def edit
  end

  def create
    @meal = Meal.new(params[:meal])
    respond_to do |format|
      if @meal.save
        flash[:notice] = 'Meal was successfully created.'
        format.html { redirect_to(@meal) }
        format.json  { render :json => @meal, :status => :created, :location => @meal }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @meal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @meal.update_attributes(params[:meal])
        flash[:notice] = 'Meal was successfully updated.'
        format.html { redirect_to(@meal) }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @meal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to(meals_url) }
      format.json  { head :ok }
    end
  end

  private
    def find_meal
      @meal = Meal.find(params[:id])
    end

end
