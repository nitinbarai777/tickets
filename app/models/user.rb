class User < ActiveRecord::Base
  SUPER_ADMIN = "SuperAdmin"
  COMPANY_ADMIN = "CompanyAdmin"
  USER = "User"
  STAFF = "Staff"

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.login_field = 'email'
  end
  
  include SearchHandler


  attr_writer :password_required

  validates :email, :presence => true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_presence_of :password, :if => :password_required?

  has_one :user_role, :dependent => :destroy
  has_one :role, :through => :user_role
  
  has_many :tickets, :dependent => :destroy
  has_many :ticket_replies
  belongs_to :company
  
  scope :all_users, joins(:role).where(:roles => { :role_type => USER })
  
  scope :all_users_and_staffs, joins(:role).where(:roles => { :role_type => [USER, STAFF] })
  
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
  
  def is_staff?
   has_role?(STAFF)
  end  
  
  def is_company_admin?
    has_role?(COMPANY_ADMIN)
  end  

  def name(shorten=true)
    if first_name && last_name
      [first_name, last_name].join(" ")
    else
      email
    end
  end


end
