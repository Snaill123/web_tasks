class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.string :author
      t.text :content
      t.string :email

      t.timestamps
    end
  end
end
