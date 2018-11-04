class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.text :url
      t.string :short_url
      t.timestamps null: false
    end

    add_index :urls, :short_url, unique: true
  end
end
