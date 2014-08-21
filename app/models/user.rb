class User < ActiveRecord::Base
	
	attr_accessor :password

	attr_accessible :name, :email, :password, :password_confirmation, :role

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	before_validation :set_role_for_admin, :student_can_not_change_role
	
	validates :role, inclusion: { in: %w(student parent teacher) } 

	validates :name, :presence => true, :length => { :maximum => 50 }

	validates :email, :presence 	=> true,
					  :format 		=> { :with => email_regex },
					  :uniqueness 	=> { :case_sensitive => false }

	validates :password, :presence => true,
			   :confirmation => true,
			   :length => { :within => 6..40 }

	before_save :encrypt_password

	def student_can_not_change_role
		self.role = role_was if role_was == 'student' 
	end

	def set_role_for_admin
		self.role = 'teacher' if admin
	end

	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end

	class << self

		def authenticate(email, submitted_password)
			user = find_by_email(email)
			(user && user.has_password?(submitted_password)) ? user : nil
		end

		def authenticate_with_salt(id, cookie_salt)
			user = find_by_id(id)
			(user && user.salt == cookie_salt) ? user : nil
		end
	end

	private

		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(self.password)
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
