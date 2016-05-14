class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.references :post, index: true
      t.decimal :pos
      t.decimal :neutral
      t.decimal :neg
      t.integer :char_length

      t.timestamps null: false
    end
  end
end
