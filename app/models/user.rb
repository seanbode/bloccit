class User < ActiveRecord::Base
  before_save { self.email = email.downcase if email.present? }
  before_save { self.first_name = name.split(" ").first.capitalize if name.present? }
  before_save { self.last_name = name.split(" ").last.capitalize if name.present? }
  # In case your version of ruby is giving problems with .capitalize this alternative can work: 
  #before_save { self.first_name[0] = self.first_name[0].capitalize if name.present? }
  #before_save { self.last_name[0] = self.last_name[0].capitalize if name.present? }
  before_save { self.name = first_name + " " + last_name if name.present? }

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true
  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  has_secure_password
end
