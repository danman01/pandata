class RequestsController < ApplicationController

  def index
    puts "hello world"
  end

  # POST
  def incoming
    scraper = Pandata::Scraper.get(params[:email])
    if scraper.class == Array && scraper.empty?
      # return not found
      response = {:email=>params[:email],:status=>"not found"}
    else
      # the basics
      response = {:email=>params[:email], :status=>"found"}
      # what to get from pandata?
      #
      # recent activity
      response.merge!({:recent_activity=>scraper.recent_activity})
      #
      # stations
      response.merge!({:stations=>scraper.stations, :playing_station=>scraper.playing_station})
      # followers, following
      response.merge!({:followers=>scraper.followers,:following=>scraper.following})
      response.merge!({:bookmarks => scraper.bookmarks})
      response.merge!({:likes => scraper.likes})
    end
    
    @response = {:pandata => response}
    render json: @response
  end
end
