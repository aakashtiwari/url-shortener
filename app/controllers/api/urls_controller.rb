# frozen_string_literal: true
require 'csv'
module Api
  class UrlsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      urls = Url.all
      render json: urls
    end

    def show
      url = Url.find_by(shortened_url: params[:id])
      if url
        render json: url
      else
        render json: { message:  "Url not found" }
      end
    end

    def download_urls
      filename = file_params[:file].original_filename
      extension = filename.split('.').last
      tmp_file = "#{Rails.root}/tmp/uploaded.#{extension}"
      urls = []
      File.open(tmp_file, 'wb') do |f|
        f.write file_params[:file].read
      end
      CSV.foreach(tmp_file).with_index do |row, i|
        urls << Url.create(original_url: row[0])
      end
      render json: urls
    end

    def create
      url = Url.new(url_params)
      if url.save
        render json: url
      else
        render json: { message: url.errors.full_messages.join(', ') }
      end
    end

    def destroy
      url = Url.find_by(shortened_url: params[:id])
      if url
        url.destroy
        render json: { url: url, message: "Successfully deleted" }
      else
        render json: { message:  "Record doesn't exists" }
      end
    end

    private

    def file_params
      params.permit(:file)
    end

    def url_params
      params.require(:url).permit(:original_url)
    end
  end
end
