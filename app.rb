require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  # BetterErrors.application_root = File.expand_path('..', __FILE__)
  BetterErrors.application_root = File.expand_path(__dir__)
end

get '/' do
  "<h1>This is my router, and the blocks on this page will be part of my controller</h1>
  <strong>Strong</strong>\n
  <span>Span</span>
  <h2>H2</h2>"
end
