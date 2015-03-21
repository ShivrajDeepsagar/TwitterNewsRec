class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.integer :count

      t.timestamps null: false
    end
  end
end
