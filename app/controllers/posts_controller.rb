require 'rest-client'
require "textmood"

class PostsController < ApplicationController

  def get_posts
    tm = TextMood.new(language: "en")
    minimum_score = 0.05
    subreddit = "learnprogramming"

    url = "https://www.reddit.com/r/#{subreddit}"+".json"
    response = RestClient.get(url)
    posts = JSON.parse(response.body)

    for post in posts["data"]["children"]

      sentiment_score = tm.analyze(post["data"]["title"])

      if post["data"]["url"].present? && sentiment_score > minimum_score
        title = post["data"]["title"]
        url = post["data"]["url"]
        puts "#{title} - #{url} - Score:#{sentiment_score}"
      end      
    end


  end
end
