class Url < ApplicationRecord
	require "uri"
	require "base64"

	validates :original_url, presence: true, uniqueness: true

	validates_format_of :original_url,
                       with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/

	before_save :extract_base, :encode_url 

	private

	def extract_base
		uri = URI.parse(original_url.strip.downcase)
		uri = URI.parse('http://' + original_url.strip.downcase) if !uri.scheme
		domain = PublicSuffix.parse(uri.host).domain
		base_url = "http://#{domain}"
		base_url += "#{uri.path}" if uri.path
		base_url += "?#{uri.query}" if uri.query
		base_url += "##{uri.path}" if uri.fragment
		self.base_url = base_url
	end

	def encode_url
		self.shortened_url = Base64.urlsafe_encode64(base_url)	
	end
end
