require 'rest-client'

class PostsController < ApplicationController

  def get_posts
    url = "https://www.reddit.com/r/learnprogramming"+".json"
    response = RestClient.get(url)
    posts = JSON.parse(response.body)
    puts posts
    render json: posts
  end
end
