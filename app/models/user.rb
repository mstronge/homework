class User < ActiveRecord::Base
	
	has_many :students, class_name: "User", foreign_key: "parent_id"
	has_many :lessons
	has_many :comments
	belongs_to :parent, class_name: "User"

	attr_accessor :password

	attr_accessible :name, :email, :password, :password_confirmation, :role, :parent_id, :admin

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	before_validation :set_role_for_admin
	
	validates :role, inclusion: { in: %w(student parent teacher) } 

	validates :name, :presence => true, :length => { :maximum => 50 }

	validates :email, :presence 	=> true,
					  :format 		=> { :with => email_regex },
					  :uniqueness 	=> { :case_sensitive => false }

	validates :password, :presence => true,
			   :confirmation => true,
			   :length => { :within => 6..40 }, if: :new_record_or_update_password?

	validate :parent_id_only_for_student

	before_save :encrypt_password

	scope :only_students, -> { where role: 'student' }
	scope :only_students_without_parent, -> { where role: 'student', parent: nil }
	scope :only_parents, -> { where role: 'parent'}

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

		def parent_id_only_for_student
			errors.add(:role, "This role can not have parent!") if parent_id.present? && role != 'student'
		end

		def new_record_or_update_password?
			new_record? || self.password.present? || self.admin
		end

		def set_role_for_admin
			self.role = 'teacher' if admin
		end

		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(self.password) if self.password.present?
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
