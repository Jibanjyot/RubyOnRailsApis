class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.datetime :published_at
      t.integer :author_id

      t.timestamps
    end
  end
end
