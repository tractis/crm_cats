class CreateCats < ActiveRecord::Migration
  def self.up
    create_table :cats do |t|    
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string  :name
      t.text    :description
      t.string  :cat_type
      t.string  :color
      t.datetime :deleted_at
      
      t.timestamps
    end
    
    add_index :cats, :parent_id
    add_index :cats, [:cat_type, :deleted_at]
  end
  
  def self.down
    drop_table :cats
  end
end
