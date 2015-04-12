#$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'google-search'
require 'mechanize'
class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  
  respond_to :html

  def index
    if !current_user.nil?
      @tweets = Tweet.all
      
      client = Twitter::REST::Client.new do |config|
  
       config.consumer_key        = "mR5sZOHA4GKCtE8LJF4YQQEnQ"
       config.consumer_secret     = "9P1XXydm7Z7wJmeBZEfEZRgipLUFihPnNmSvZNWLCAUMon0AvR"
       config.access_token        = "2992787178-A7b9hs7GXJSMTnTEtVlPTAhPy3zt1NERk2R8UrZ"
       config.access_token_secret = "NPJFJrgoRlIDKjYE1gYaO5OFIcXsy6hWCzNuHBMRsHlim"
      end
      @my_tweets = client.user_timeline(current_user.name)
      @htags = []
      Hashtag.delete_all
      hashes = current_user.hashtags
      for tweet in  @my_tweets 
       words = tweet.text.split(/ /) 
         for word in words 
           if word.include?("#") || word.include?("@")
              word.slice!(0) 
              if !word.nil?
                @htags << word 
              end
            end 
         end  
       end 
       
       if hashes.empty?
         @htags.uniq.each do |word|
            Hashtag.create(:user_id => current_user.id, :word => word, :count => @htags.count(word))
         end
       #else
           #@htags.uniq.each do |word|
             #hash_word = Hashtag.where('user_id = ? AND word = ?', current_user.id, word).first
             #hash_word.count = @htags.count(word)
             #hash_word.save
           #end
       end
       @kwords = []
       @key_words = Hashtag.order('count DESC')
       @key_words.each do |w|
         @kwords << w.word
       end
      respond_with(@tweets)
    else
      #Google Top Stories
      url = 'https://news.google.co.in/news?pz=1&cf=all&ned=in&siidp=7055ecc1c1f503ce3ad494721c0998bd7f1d&ict=ln'
      @list_top = get_list(url)
      #Google Technology News
      url = 'https://news.google.co.in/news/section?pz=1&cf=all&ned=in&topic=tc&siidp=51a8e0c9f1fb4c19a56f76c6e2c0a66a2d36&ict=ln'
      @list_tech = get_list(url)
      #India News
      url = 'https://news.google.co.in/news/section?pz=1&cf=all&ned=in&topic=n&siidp=1127bfb9f7d3dcaa1254b0c6f3a3ce97677f&ict=ln'
      @list_india = get_list(url)
      #Business
      url = 'https://news.google.co.in/news/section?pz=1&cf=all&ned=in&topic=b&siidp=3fd6f26fc6bb30089b5a88be24dd3d6c0dc0&ict=ln'
      @list_business = get_list(url)
      #World
      url = 'https://news.google.co.in/news/section?pz=1&cf=all&ned=in&topic=w&siidp=fc764afcb2f14630e4fba44f94706e97146d&ict=ln'
      @list_world = get_list(url)
      #Entertainment
      url = 'https://news.google.co.in/news/section?pz=1&cf=all&ned=in&topic=e&siidp=47f84be18e74bc1bf5d8cd20939cf87fcd98&ict=ln'
      @list_entertainment = get_list(url)
      #Sports
      url = 'https://news.google.co.in/news/section?pz=1&cf=all&ned=in&topic=s&siidp=4142ba2ebe24aded8da3cfa58a202b3db4a7&ict=ln'
      @list_sports = get_list(url)
      #Science
      url = 'https://news.google.co.in/news/section?pz=1&cf=all&ned=in&topic=snc&siidp=b300874a3c17eecdffe434d086fac5c626e6&ict=ln'
      agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
      @list_science = get_list(url)
      #Health
      url = 'https://news.google.co.in/news/section?pz=1&cf=all&ned=in&topic=m&siidp=0b8f8f8472add2a9b8330d6195161ff45a12&ict=ln'
      @list_health = get_list(url)
    end
    
  end

  def show
    #respond_with(@tweet)
    redirect_to :action => "index"
  end

  def new
    @tweet = Tweet.new
    respond_with(@tweet)
  end

  def edit
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    @tweet.save

    respond_with(@tweet)
  end

  def update
    @tweet.update(tweet_params)
    respond_with(@tweet)
  end

  def destroy
    @tweet.destroy
    respond_with(@tweet)
  end

  private
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:user_id, :body)
    end
    def get_list(link)
      url = link
      agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
      html = agent.get(url).body
      html_doc = Nokogiri::HTML(html)
      list = html_doc.xpath("//h2[@class='esc-lead-article-title']")
      list_6 = list.first(6)
      return list_6
    end
end
