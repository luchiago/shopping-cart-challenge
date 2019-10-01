class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :user_token
      t.integer :apple
      t.integer :banana
      t.integer :orange

      t.timestamps
    end
  end
end
