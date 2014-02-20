class Ticket < ActiveRecord::Base
  has_many :ticket_replies
  belongs_to :user
end
