class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.integer :owner
      t.string :name
      t.string :description
      t.integer :currentSlide

      t.timestamps
    end
  end
end
