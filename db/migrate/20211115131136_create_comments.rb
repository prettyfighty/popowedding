class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :phone_number
      t.string :name
      t.text :message
      t.boolean :win, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
