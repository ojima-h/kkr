class NotesController < ApplicationController
  before_filter :authenticate_user!

  # GET /notes
  # GET /notes.xml
  def index
    @notes = Note.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = Note.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
    @tags = Tag.find(:all)
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])

    links_param = params[:links] or []
    filters = Filter.validate params

    respond_to do |format|
      if filters.find {|filter| filter.manipulations.find {|m| m.sort == :error}}
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      else
        if @note.save and @note.update_links links_param
          if @note.execute_manipulations filters
            format.html { redirect_to('/', :notice => 'Note was successfully created.') }
            format.xml  { render :xml => '/', :status => :created, :location => @note }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
          end
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])

    links_param = params[:links] or []
    filters = Filter.validate params[:note]
    
    respond_to do |format|
      if filters.find {|filter| filter.manipulations.find {|m| m.sort == :error}}
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      else
        if @note.update_attributes(params[:note]) and @note.update_links(links_param)
          if @note.execute_manipulations filters
            format.html { redirect_to('/', :notice => 'Note was successfully updated.') }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
          end
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to('/') }
      format.xml  { head :ok }
    end
  end

  def parse_params params
  #   if params[:links]
  #     params[:links].find_all {|d|
  #       d[:tag_id] and d[:tag_id] != '0'
  #     }.map {|d|
  #       {:tag_id => d[:tag_id], :value => (d[:value] or "")}
  #     }.inject({}) {|acc, d|
  #       if not acc[d[:tag_id]]
  #         acc[d[:tag_id]] = d[:value]
  #       end
  #       acc
  #     }.map {|k, v|
  #       {:tag_id => k, :value => v}
  #     }
  #   else
  #     []
  #   end
    
    # ruby >= 1.9.2
    links_data = params[:links].find_all {|d|
      d[:tag_id] and d[:tag_id] != '0'
    }.uniq {|d|
      [d[:tag_id], d[:value]]
    }
  end
end
