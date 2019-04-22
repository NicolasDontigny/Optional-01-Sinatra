require 'open-uri'
require 'nokogiri'

class ScrapeRicardo
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def scrape
    # chocolate_file = File.join(__dir__, "#{ingredient}.html")
    html_doc = url_to_html_doc

    recipes = []
    html_doc.search('#search-results .item-list ul .item .desc')[0...10].each do |recipe|
      name = recipe.search('h2 a')[0].text.delete("\u2028")
      preptime = recipe.search('ul li')[0].text.match(/[^0-9]*(?<preptime>[0-9]+.*min)/)
      preptime = preptime ? preptime["preptime"] : "Unknown"
      rating = recipe.search('a .rating') != "" ? recipe.search('a .rating').text : "no rating yet"
      recipes << { name: name, preptime: preptime, rating: rating }
    end

    return recipes
  end

  private

  def url_to_html_doc
    url = "https://www.ricardocuisine.com/en/search/key-words/#{@ingredient}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    return html_doc
  end
end
