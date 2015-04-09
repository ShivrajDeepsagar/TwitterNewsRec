class ChangeHashtagTable < ActiveRecord::Migration
  def change
  	remove_column :hashtags, :keyword_id
  	add_column :hashtags, :word, :string
  end
end
