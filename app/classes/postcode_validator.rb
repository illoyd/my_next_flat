class PostcodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless UKPostcode.new(self.area).valid?
      record.errors[attribute] << (options[:message] || "is not a valid UK Postcode")
    end
  end

end
