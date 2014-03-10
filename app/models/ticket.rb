class Ticket < ActiveRecord::Base
  has_many :ticket_replies, dependent: :destroy
  belongs_to :user
  
  acts_as_taggable
  
  mount_uploader :attached_file, TicketUploader
  
  include SearchHandler
  
  validates :subject, :description, :priority_id, :presence => true
  
  scope :active, -> { where(:is_active => true) }
  scope :open, -> { where(:status_id => 1) }
  scope :close, -> { where(:status_id => 2) }
  
  def is_last_reply_by_staff?(current_user_id)
     ticket_reply = self.ticket_replies.order("id desc").first
     if ticket_reply.present?
       unless ticket_reply.user_id == current_user_id
         return true
       else
         return false  
       end
     else
       return false  
     end
  end
  
end
