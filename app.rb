require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "recipe"
require_relative "scrape_ricardo"
set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  # BetterErrors.application_root = File.expand_path('..', __FILE__)
  BetterErrors.application_root = File.expand_path(__dir__)
end

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  name = params['name']
  description = params['description']
  preptime = params['preptime']
  rating = params['rating']
  hash = { name: name, description: description, preptime: preptime, rating: rating }
  new_recipe = Recipe.new(hash)
  cookbook.add_recipe(new_recipe)
  redirect '/'
end

get '/destroy/:index' do
  cookbook.remove_recipe(params[:index].to_i)
  redirect '/'
end

get '/new-ricardo' do
  erb :new_ricardo
end

post '/new-ricardo' do
  ingredient = params['ingredient']
  redirect "/new-ricardo/#{ingredient}"
end

get '/new-ricardo/:ingredient' do
  @ingredient = params['ingredient']
  scrape = ScrapeRicardo.new(@ingredient)
  @recipes = scrape.scrape
  erb :ingredient
end

get '/new-ricardo/:ingredient/:index' do
  @ingredient = params['ingredient']
  scrape = ScrapeRicardo.new(@ingredient)
  @recipes = scrape.scrape
  index = params["index"].to_i
  new_recipe = Recipe.new(@recipes[index])
  cookbook.add_recipe(new_recipe)
  redirect '/'
end
