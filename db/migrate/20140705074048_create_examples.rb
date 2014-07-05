class CreateExamples < ActiveRecord::Migration
  def up
    rename_table :searches, :examples
    add_column :examples, :type, :string
    add_index :examples, :type
    
    rename_column :locations, :search_id, :example_id
    rename_column :criteria, :search_id, :example_id
    
    # Update all examples with users to be searches
    Example.where('user_id is not null').update_all(type: 'Search')
    Example.where('user_id is null').update_all(type: 'Example')
  end
  
  def down
    rename_column :locations, :example_id, :search_id
    rename_column :criteria, :example_id, :search_id

    remove_column :examples, :type
    rename_table :examples, :searches
  end
end
