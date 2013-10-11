class RequestsController < ApplicationController
  
  # how to use debugger: first uncomment the following line
  # debugger
  # then, in the console with debugger: type eval varname to see what varname is

  def index
    puts "hello world"
  end

  # POST
  def incoming
    @scraper = Pandata::Scraper.get(params[:email])
    if @scraper.class == Array && @scraper.empty?
      # return not found
      @response = {:status=>"not found",:email=>params[:email]}
    else 
      # return the basics and then check for flags
      # If no flags, return all
      @response = {:status=>"found",:email=>params[:email]}
      # what to get from pandata?
      #
      # check which tags we want
      if params[:all]
        get_all
      else
        # specify specific tags
        if params[:recent_activity]
          get_recent_activity
        end
        if params[:stations]
          get_stations
        end
        if params[:playing_station]
          get_playing_station
        end
        if params[:followers]
          get_followers
        end
        if params[:following]
          get_following
        end
        if params[:likes]
          get_likes
        end 
        if params[:recent_activity]
          # get recent activity
        end
      end # specify specific tags
    end # end if scraper is Array or Scraper class
    
    @response = {:pandata => @response} # format json with a pandata wrapper

    # render json response that deals with jsonp
    render json: @response.to_json, :callback=>params[:callback]
  end

  private

  def get_all
    # collect all available from scraper
    get_recent_activity
    get_stations
    get_playing_station
    get_followers
    get_following
    get_bookmarks
    get_likes
  end

  # specifc scrapers
  def get_recent_activity
    @response.merge!({:recent_activity=>@scraper.recent_activity})
  end

  def get_stations
    @response.merge!({:stations=>@scraper.stations})
  end 

  def get_playing_station
    @response.merge!({:playing_station=>@scraper.playing_station})
  end

  def get_followers
    @response.merge!({:followers=>@scraper.followers})
  end

  def get_following
    @response.merge!({:following=>@scraper.following})    
  end 

  def get_bookmarks
    @response.merge!({:bookmarks => @scraper.bookmarks})
    
  end

  def get_likes
    @response.merge!({:likes => @scraper.likes})    
  end
end
