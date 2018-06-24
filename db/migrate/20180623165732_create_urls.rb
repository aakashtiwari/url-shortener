class CreateUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :base_url
      t.string :shortened_url

      t.timestamps
    end
    add_index :urls, :original_url
    add_index :urls, :shortened_url    
  end
end
