class UrlController < ApplicationController

	def index
		@url = Url.new
		@urls = Url.all
	end

	def create
		@url = Url.new(url_params)
		if @url.save
      flash[:success] = "Successfuly shortened the url #{@url.original_url} to #{@url.shortened_url}"
    else
      flash[:error] = @url.errors.full_messages.join('<br/>')
    end
     redirect_to root_path
	end

	private

	def url_params
		params.require(:url).permit(:original_url)
	end

end

