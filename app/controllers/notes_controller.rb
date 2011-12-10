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

    tag_data = params[:tags].find_all {|d|
      d[:tag_id] and d[:tag_id] != '0'
    }.map {|d|
      {:tag_id => d[:tag_id], :value => (d[:value] or "")}
    }.inject({}) {|acc, d|
      if acc[d[:tag_id]]
        acc
      else
        acc[d[:tag_id]] = d[:value]
      end
    }.map {|k, v|
      {:tag_id => k, :value => v}
    }
    
    tag_ids = tag_data.map{|d| d[:tag_id]}
    tags = Tag.find(tag_ids)

    respond_to do |format|
      if Restriction.validate_restriction(@note, tag_data)
        if @note.save and Link.add_link_to_note @note, tag_data
          format.html { redirect_to('/', :notice => 'Note was successfully created.') }
          format.xml  { render :xml => '/', :status => :created, :location => @note }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "complete", :locals => {:links_data => tag_data}}
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])

    tag_data = params[:tags].find_all {|d|
      d[:tag_id] and d[:tag_id] != '0'
    }.map {|d|
      {:tag_id => d[:tag_id], :value => (d[:value] or "")}
    }.inject({}) {|acc, d|
      if acc[d[:tag_id]] and not acc[d[:tag_id]].empty?
        acc
      else
        acc[d[:tag_id]] = d[:value]
        acc
      end
    }.map {|k, v|
      {:tag_id => k, :value => v}
    }

    tag_ids = tag_data.map{|d| d[:tag_id]}
    tags = Tag.find(tag_ids)

    respond_to do |format|
      if Restriction.validate_restriction(@note, tag_data)
        if @note.update_attributes(params[:note]) and
            Link.sync(@note, tag_data)
        then
          format.html { redirect_to('/', :notice => 'Note was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "complete", :locals => {:links_data => tag_data} }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
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
end
