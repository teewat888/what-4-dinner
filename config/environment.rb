require "tty-prompt"
require 'open-uri'
require 'net/http'
require 'json'
require 'nokogiri'
#require 'openssl'


require_relative "../lib/what4eat.rb"
require_relative "../lib/api_client.rb"
require_relative "../lib/cli.rb"
require_relative "../lib/scraper.rb"
require_relative "../model/recipe.rb"
require_relative "../model/dinner.rb"

#API_KEY = 'put your API key here'
API_KEY = 'e4ab17b6886c4c6081fb5661745ead04'
