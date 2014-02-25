class TicketReply < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket
  
  validates :description, :presence => true
  
  mount_uploader :attached_file, ImageUploader
end
