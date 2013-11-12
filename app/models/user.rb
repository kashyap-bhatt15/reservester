class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  before_validation :downcase_email
  before_create :set_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  attr_accessible :name, :role

  validates_presence_of :name
	#validates_uniqueness_of :email, :case_sensitive => false
  validates :email, presence: true, email: true

  has_many :restaurants, dependent: :destroy

  def own?(restaurant_id)
    #if self.restaurants.present?
    #(Restaurant.where("owner_id = ? AND id = ?", self.id,restaurant_id)).present?
    self.restaurants.find_by_id(restaurant_id).present?
    #end
  end

  def is_owner?
    return self.role == 'owner' ? true : false 
  end

  private
  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

  def set_role
    self.role = "patron"
  end
  
end
