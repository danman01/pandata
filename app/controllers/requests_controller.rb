class RequestsController < ApplicationController
  #respond_to :json,:xml,:html

  def index
    puts "hello world"
  end

  # POST
  def incoming
    scraper = Pandata::Scraper.get(params[:email])
    if scraper.class == Array && scraper.empty?
      # return not found
      response = {:status=>"not found",:email=>params[:email]}
    else 
      # the basics
      response = {:status=>"found",:email=>params[:email]}
      # what to get from pandata?
      #
      # check which tags we want
      if params[:all]
        # debugger
        # in the console with debugger: type eval varname to see what varname is

        # recent activity
        response.merge!({:recent_activity=>scraper.recent_activity})
        #
        # stations
        response.merge!({:stations=>scraper.stations, :playing_station=>scraper.playing_station})
        # followers, following
        response.merge!({:followers=>scraper.followers,:following=>scraper.following})
        # bookmarks
        response.merge!({:bookmarks => scraper.bookmarks})
        response.merge!({:likes => scraper.likes})
      end
      if params[:recent_activity]
        # get recent activity
      end
      #if condition
        
      #end
    end
    
    @response = {:pandata => response}
    #respond_with(@response)
    render json: @response.to_json, :callback=>params[:callback]
  end
end
