class AddUpdateMethodToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :method, :string

  end
end
