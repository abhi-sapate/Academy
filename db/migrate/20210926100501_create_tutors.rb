class CreateTutors < ActiveRecord::Migration[6.0]
  def change
    create_table :tutors, id: :uuid do |t|
      t.string :name
      t.string :faculty_no

      t.references :course, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
