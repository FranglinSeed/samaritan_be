class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.string :requestType
      t.float :latitude
      t.float :longitude
      t.string :address
      t.boolean :status

      t.timestamps
    end
  end
end
