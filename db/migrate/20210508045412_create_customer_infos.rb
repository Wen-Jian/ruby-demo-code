class CreateCustomerInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_infos do |t|
      t.string :cam_id
      t.string :area_id
      t.string :user_tracker_id
      t.datetime :timestamp
      t.integer :detection_count
      t.text :snapshot
      t.timestamps
    end
  end
end
