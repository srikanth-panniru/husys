class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :registration_id
      t.integer :total_marks
      t.float :marks_secured
      t.string :exam_result
      t.string :pass_text

      t.timestamps
    end
  end
end
