class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      
      t.string :name
      t.text :description
      t.string :image_large
      t.string :image_small

      t.timestamps
    end

    add_index :courses, :name, unique: true
  end
end
