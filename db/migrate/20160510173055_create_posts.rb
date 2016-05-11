class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id, {null: false}
      t.text :text
      t.decimal :pos_avg
      t.decimal :nut_avg
      t.decimal :neg_avg

      t.timestamps null: false
    end
  end
end
