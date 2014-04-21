class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [ :twitter ]

  has_many :searches, inverse_of: :user, dependent: :destroy
  
  validates :name, presence: true
  
  def twitter?
    self.twitter_uid.present?
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.twitter_data"] && session["devise.twitter_data"]["info"]
        user.email             = data['email']    if user.email.blank?
        user.name              = data['name']     if user.name.blank?
        user.twitter_handle    = data["nickname"] if user.twitter_handle.blank?
        user.profile_image_url = data['image']    if user.profile_image_url.blank?
      end
    end
  end

  def self.find_or_create_with_twitter_oauth(auth)
    find_or_create_by(twitter_uid: auth.uid) do |user|
      user.twitter_uid       = auth.uid
      user.twitter_handle    = auth.info.nickname
      user.profile_image_url = auth.info.image
      user.email             = auth.info.email || auth.email || "#{ auth.info.nickname }_twitter@mynextflat.co.uk"
      user.password          = Devise.friendly_token[0,20]
      user.name              = auth.info.name
      user.real_email        = false
    end
  end
  
  def merge!(other_user)
    other_user.searches.each { |search| search.update!( user: self ) }    
    other_user.reload
    self.reload
  end

end
