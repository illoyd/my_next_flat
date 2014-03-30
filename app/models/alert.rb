class Alert < ActiveRecord::Base
  belongs_to :search, inverse_of: :alerts
end
