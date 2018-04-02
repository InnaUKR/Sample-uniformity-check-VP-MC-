class CreateData < ActiveRecord::Migration[5.1]
  def change
    create_table :data do |t|
      t.decimal :x
      t.decimal :y

      t.timestamps
    end
  end
end
