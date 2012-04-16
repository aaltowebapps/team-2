class AddUrlToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :url, :string

  end
end
