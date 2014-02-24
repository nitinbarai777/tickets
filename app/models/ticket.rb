class Ticket < ActiveRecord::Base
  has_many :ticket_replies, dependent: :destroy
  belongs_to :user
  
  mount_uploader :attached_file, ImageUploader
  
  validates :subject, :description, :priority_id, :presence => true
  
  scope :active, -> { where(:is_active => true) }
  scope :open, -> { where(:status_id => 1) }
  scope :close, -> { where(:status_id => 2) }
end
