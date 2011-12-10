class RestrictionsController < ApplicationController
    before_filter :authenticate_user!

  # GET /restrictions
  # GET /restrictions.json
  def index
    @restrictions = Restriction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @restrictions }
    end
  end

  # GET /restrictions/1
  # GET /restrictions/1.json
  def show
    @restriction = Restriction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @restriction }
    end
  end

  # GET /restrictions/new
  # GET /restrictions/new.json
  def new
    @restriction = Restriction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @restriction }
    end
  end

  # GET /restrictions/1/edit
  def edit
    @restriction = Restriction.find(params[:id])
  end

  # POST /restrictions
  # POST /restrictions.json
  def create
    @restriction = Restriction.new(params[:restriction])
    respond_to do |format|
      if @restriction.save
        format.html { redirect_to @restriction, notice: 'Restriction was successfully created.' }
        format.json { render json: @restriction, status: :created, location: @restriction }
      else
        format.html { render action: "new" }
        format.json { render json: @restriction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /restrictions/1
  # PUT /restrictions/1.json
  def update
    @restriction = Restriction.find(params[:id])

    respond_to do |format|
      if @restriction.update_attributes(params[:restriction])
        format.html { redirect_to @restriction, notice: 'Restriction was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @restriction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restrictions/1
  # DELETE /restrictions/1.json
  def destroy
    @restriction = Restriction.find(params[:id])
    @restriction.destroy

    respond_to do |format|
      format.html { redirect_to restrictions_url }
      format.json { head :ok }
    end
  end
end
