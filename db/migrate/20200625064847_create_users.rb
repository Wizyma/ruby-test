class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :cash

      t.timestamps

      t.index :email, unique: true
    end
  end
end
