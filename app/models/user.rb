class User < ActiveRecord::Base
  SUPER_ADMIN = "SuperAdmin"
  USER = "User"
  STAFF = "Staff"

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.login_field = 'email'
  end
  
  include SearchHandler


  attr_writer :password_required

  validates :email, :presence => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_presence_of :password, :if => :password_required?

  has_one :user_role, :dependent => :destroy
  has_one :role, :through => :user_role
  
  has_many :tickets
  has_many :ticket_replies
  
  scope :all_users, joins(:role).where("roles.role_type != ?", SUPER_ADMIN)

  def password_required?
    @password_required
  end

  validates_uniqueness_of :email
  validates :email, :term, :presence => true

  mount_uploader :image, ImageUploader

  def is_admin?
    has_role?(SUPER_ADMIN)
  end

  def is_user?
   has_role?(USER)
  end
  
  def is_user?
   has_role?(STAFF)
  end  

  def name(shorten=true)
    unless first_name.nil? && last_name.nil? or first_name.empty? && last_name.empty?
      [first_name, last_name].join(" ")
    else
      email
    end
  end


end
