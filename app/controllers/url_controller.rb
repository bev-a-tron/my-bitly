require 'digest'
require 'base64'

class UrlController < ApplicationController
  def new
  end


  def create
    param! :url, String, required: true

    url = params[:url]

    begin
      @short_url = Base64.encode64(Digest::SHA256.hexdigest(url)).first(8)
      Url.create!(url: url, short_url: @short_url)
    rescue StandardError => e
      print e
    end
  end

  def show
    param! :short_url, String, required: true

    begin
      url = Url.where(short_url: params[:short_url]).first.url
      @answer = "THIS IS THE URL!!!!! #{url.url}"
      redirect_to url.url
    rescue StandardError => e
      print e
    end
  end
end
