class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, {null: false}
      t.string :email, {null: false}
      t.string :password_hash, {null: false}
      t.boolean :ok_to_email

      t.timestamps null: false
    end
  end
end
