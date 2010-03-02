class CreateCattings < ActiveRecord::Migration
  def self.up
    create_table :cattings do |t|
      t.integer  :cat_id
      t.integer  :cattable_id
      t.datetime :created_at
    end
    
    add_index :cattings, :cat_id
    add_index :cattings, :cattable_id
  end
  
  def self.down
    drop_table :cattings
  end
end
