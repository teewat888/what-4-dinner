require "tty-prompt"
require 'open-uri'
require 'net/http'
require 'json'
require 'nokogiri'
require 'tty-spinner'
#require 'openssl'


require_relative "../lib/what4dinner.rb"
require_relative "../lib/api_client.rb"
require_relative "../lib/cli.rb"
require_relative "../lib/scraper.rb"
require_relative "../model/recipe.rb"
require_relative "../model/dinner.rb"

require_relative "./api_key.rb"
#API_KEY = 'put your API key here'

