class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :cohort_id
      t.string :hometown
      t.string :linked_in_url
      t.string :facebook_url
      t.string :twitter_url
      t.string :github_url
      t.string :blog
      t.string :quora
      t.string :hacker_news_url
      t.string :role

      t.timestamps
    end
  end
end
