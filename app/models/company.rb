class Company < ActiveRecord::Base
  has_many :users
  has_many :tickets
  mount_uploader :logo, TicketUploader
  
  include SearchHandler
  
  validates :name, :sub_domain, :email, :url, :presence => true
  
  def is_confirmed_and_active?
    self.is_confirmed and self.is_active
  end
end
