class TicketReply < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket
  
  mount_uploader :attached_file, ImageUploader
end
