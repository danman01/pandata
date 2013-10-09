class RequestsController < ApplicationController

  def index
    puts "hello world"
  end

  # POST
  def incoming
    @params = params
    scraper = Pandata::Scraper.get(params[:email])
    response = {:email=>params[:email]}
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
    @response = {:pandata => response}
    render json: @response
  end
end
