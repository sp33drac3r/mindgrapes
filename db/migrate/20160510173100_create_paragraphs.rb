class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.integer :post_id, {null: false}
      t.decimal :neg
      t.decimal :nut
      t.decimal :neg
      t.integer :char_length

      t.timestamps null: false
    end
  end
end
