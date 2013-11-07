class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :registerable, :omniauthable, omniauth_providers: [:dwolla]

  ## Database authenticatable
  # field :email,              :type => String, :default => ""
  # field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  # field :reset_password_token,   :type => String
  # field :reset_password_sent_at, :type => Time

  ## Rememberable
  # field :remember_created_at, :type => Time

  ## Trackable
  # field :sign_in_count,      :type => Integer, :default => 0
  # field :current_sign_in_at, :type => Time
  # field :last_sign_in_at,    :type => Time
  # field :current_sign_in_ip, :type => String
  # field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  rolify
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :address
  field :email, type: String
  field :invitation_token,       type: String
  field :invitation_created_at,  type: Time
  field :invitation_sent_at,     type: Time
  field :invitation_accepted_at, type: Time
  attr_accessible :role_ids, :as => :admin
  attr_accessible :provider, :uid, :name, :address, :email
  validates_presence_of :name
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })
  index({invitation_token: 1}, {background: true})
  index({invitation_by_id: 1}, {background: true})

  has_many :notes

  def self.find_for_dwolla_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth["provider"], uid: auth["uid"]).first
    unless user
      user = User.create(
        name:  auth[:info][:name],
        uid:   auth[:uid],
        email: auth[:info][:email]
      )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.dwolla_data"] && session["devise.dwolla_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
