require 'rest-client'
require "textmood"

class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def get_posts
    tm = TextMood.new(language: "en")
    minimum_score = 0.05
    subreddits = ["UpliftingNews", "GoodNews", "UpliftingTrends"]

    for subreddit in subreddits

      url = "https://www.reddit.com/r/#{subreddit}"+".json"
      response = RestClient.get(url)
      posts = JSON.parse(response.body)

      for post in posts["data"]["children"]

        sentiment_score = tm.analyze(post["data"]["title"])

        if post["data"]["url"].present? && sentiment_score > minimum_score
          title = post["data"]["title"]
          url = post["data"]["url"]
          puts "#{title} - #{url} - Score:#{sentiment_score}"
          Post.create!(title: title, url: url, sentiment_score: sentiment_score)
        end      
      end
    end

  end

  # GET /posts or /posts.json
  def index
    get_posts
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.fetch(:post, {})
    end
end

