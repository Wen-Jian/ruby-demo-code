# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

csv_text = File.read('read_data_from_web_data.csv')
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1', :col_sep => "|")
csv.each_with_index do |row, index|
    data = CustomerInfo.create!(
        cam_id: row["cam_id"],
        area_id: row["area_id"],
        user_tracker_id: row["user_tracker_id"],
        timestamp: row["timestamp"].to_datetime,
        detection_count: row["detection_count"].to_i,
        snapshot: row["snapshot"]
    )
    p data.cam_id
end