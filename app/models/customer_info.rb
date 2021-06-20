class CustomerInfo < ApplicationRecord
    validates_presence_of :cam_id, :area_id, :user_tracker_id, :timestamp, :detection_count, :snapshot
end
