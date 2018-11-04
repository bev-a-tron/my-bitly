require 'digest'
require 'base64'

class UrlController < ApplicationController

  def new
  end


  def create
    param! :url, String, required: true

    begin
      url = Url.lookup(params[:url])
      @short_url = url.short_url
    rescue Errors::InvalidUrl
      render status: 404
    end
  end

  def show
    param! :short_url, String, required: true

    begin
      @full_url = Url.lookup_by_short_url(params[:short_url])
      redirect_to @full_url
    rescue Errors::InvalidUrl
      render status: 404
    end
  end
end
