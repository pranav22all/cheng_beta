class User < ApplicationRecord
	#Model for a User with a name and email 
	#Cookies and account activation unhased versions
	#These are NOT stored within the database 
	attr_accessor :remember_token, :activation_token, :reset_token 
	#Is invoked before the database saves email, email index
	#Gives us read / write capabilities on these 
	#These are methods that take these symbols in as parameters that reference
	#a method
	before_save :downcase_email
	before_create :create_activation_digest
	validates :name, presence: true, length: {maximum: 50} 
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
	#ABC@yahoo.com and abc@yahoo.com are both same and counted as duplicates
	#All of this is on the model (single user) side scale 
	#If we want something to be on the database side scale then we must 
	#have a db migration 
	has_secure_password #Adds a ton of password functionality
	#Enforces validation on password and password_conf attributes 
	validates :password, presence: true, length: {minimum: 6}
	def User.new_token
    	SecureRandom.urlsafe_base64 #This generates a random 22 char long 
    	#sequence to be used as a cookie remember token 
    	#The hash (digest) version of this will be stored in the database 
  	end
  	#Returns the hash of any string (used for password and cookie)
  	def User.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
  	end
  	#generates a remember cookie token and then sets the digest equal to the hashed
  	#version of this cookie token 
  	#This way our database never has to actually store the token = more secure
  	def remember 
  		self.remember_token = User.new_token
  		update_attribute(:remember_digest,User.digest(remember_token))
  	end
  	#Set cookie token digest to nil in the DATABASE 
  	def forget 
  		update_attribute(:remember_digest,nil)
  	end 
  	#Checks whether a token matches the digest (attribute can be :activation in this case)
  	def authenticated?(attribute, token)
  		digest = send("#{attribute}_digest")
  		return false if digest.nil? 
  		BCrypt::Password.new(digest).is_password?(token)
  	end 
  	def activate
  		update_attribute(:activated, true)
  		update_attribute(:activated_at, Time.zone.now)
  	end
  	def send_activation_email
  		UserMailer.account_activation(self).deliver_now
  	end
  	def create_reset_digest
  		self.reset_token = User.new_token
  		update_attribute(:reset_digest, User.digest(reset_token))
  		update_attribute(:reset_sent_at, Time.zone.now)
  	end 
  	def send_password_reset_email 
  		#Calls the password reset function within user_mailer 
  		UserMailer.password_reset(self).deliver_now
  	end  
  	def password_reset_expired? 
  		reset_sent_at < 2.hours.ago 
  	end 
	private 
		def downcase_email 
			self.email = email.downcase 
		end 
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end
