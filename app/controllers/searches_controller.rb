class SearchesController < ApplicationController
  def search
  end

  def foursquare
    begin

    @resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
      req.params['client_id'] = 'YOUR foursquare client_id'
      req.params['client_secret'] = 'YOUR foursquare client_secret'
      req.params['v'] = '20160201'
      req.params['near'] = params[:zipcode]
      req.params['query'] = 'coffee shop'
      #req.options.timeout = 0 => 0 means it always timeout and throw error msg.
    end

    body = JSON.parse(@resp.body)
    # Faraday provides 'success?' method
    if @resp.success?
      @venues = body["response"]["venues"]
    else
      @error = body["meta"]["errorDetail"]
    end

  rescue Faraday::ConnectionFailed
    @error = "There was a timeout. Please try again."
  end
    render 'search'
  end

end
