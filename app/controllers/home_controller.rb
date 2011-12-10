class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @notes = Note.find(:all, :order => 'updated_at DESC')
    @tags = Tag.find(:all, :order => 'updated_at DESC')
  end

  def search
    require 'search'
    
    parser = SearchParser.new
    condition = parser.parse(params[:cond])
    if not condition
      @notes = Note.all
      @search_info = parser.failure_reason + ' : ' + params[:cond]
    else
      @notes = Note.all.find_all do |note|
        condition.validate note
      end
      @search_info = params[:cond]
    end

    @tags = Tag.find(:all, :order => 'updated_at DESC')

    render 'index'
  end
end
