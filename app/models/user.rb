class User
  include Mongoid::Document
  
  has_and_belongs_to_many :groups
  
  field :userName, type: String
  field :passHash, type: String
  
  field :email, type: String
  field :pubKey, type: String
  
  
  
  field :register_date, type: DateTime, :default => DateTime.now
  
  validates_presence_of :passHash
  validates_uniqueness_of :email
  validates_uniqueness_of :pubKey
  
  
end
