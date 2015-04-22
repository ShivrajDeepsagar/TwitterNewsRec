class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @categories = Category.all
    respond_with(@categories)
  end

  def show
    @category = Category.find(params[:id])
    url = @category.google_url
    agent = Mechanize.new #{ |agent| agent.user_agent_alias = "Mac Safari" }
    html = agent.get(url).body
    html_doc = Nokogiri::HTML(html)
    list = html_doc.xpath("//h2[@class='esc-lead-article-title']")
    @recent_news = list.first(5)
    respond_with(@category)
  end

  def new
    @category = Category.new
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    @category.save
    respond_with(@category)
  end

  def update
    @category.update(category_params)
    respond_with(@category)
  end

  def destroy
    @category.destroy
    respond_with(@category)
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :google_url)
    end
end
