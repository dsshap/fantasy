class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  has_many :fantasy_leagues, autosave: true


  attr_accessible :email, :password, :password_confirmation, :remember_me
  accepts_nested_attributes_for :fantasy_leagues, :allow_destroy => true

  def leagues_belong_to
    FantasyLeague.where(status: :active).select do |league|
      !league.participants.find_by_user(self).nil?
    end
  end

  def pending_invitations
    FantasyInvitation.all_in(email: email, status: 'pending')
  end

  def email_prefix
    email.split('@')[0]
  end

  def name
    email_prefix
  end
end
