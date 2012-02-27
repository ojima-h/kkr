class ManipulationsController < ApplicationController
  # GET /manipulations
  # GET /manipulations.xml
  def index
    p params
    @filter = Filter.find(params[:filter_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @filter.manipulations }
    end
  end

  # DELETE /manipulations/1
  # DELETE /manipulations/1.xml
  def destroy
    @manipulation = Manipulation.find(params[:id])
    @manipulation.destroy

    respond_to do |format|
      format.html { redirect_to('/') }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end
end
