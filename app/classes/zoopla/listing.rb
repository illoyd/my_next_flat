module Zoopla

  class Listing < APISmith::Smash
  
    property :id,            required: true, from: :listing_id

    property :status,        required: true, transformer: StringInquirerTransformer
    property :kind,          required: true, from: :property_type, transformer: StringInquirerTransformer

    property :address,       from: :displayable_address
    property :street,        from: :street_name
    property :city,          from: :post_town
    property :county
    property :country

    property :price,         required: true, transformer: IntegerTransformer
    property :beds,          from: :num_bedrooms, required: true, transformer: IntegerTransformer
    property :baths,         from: :num_bathrooms, transformer: IntegerTransformer

    property :listing_url,   from: :details_url
    property :image_url
    property :thumbnail_url

    property :description
    property :summary,        from: :short_description
    property :caption,        from: :image_caption

    property :latitude,       transformer: FloatTransformer
    property :longitude,      transformer: FloatTransformer

    property :agent_name
    property :agent_logo_url, from: :agent_logo

    property :created_at,     from: :first_published_date, transformer: TimeTransformer
    property :updated_at,     from: :last_published_date, transformer: TimeTransformer
    
    delegate :to_rent?, :for_sale?, to: :status
    alias_method :to_let?, :to_rent?
    
    def price_per_calendar_month
      return 0 if self.for_sale?
      (self.price.to_f * 52 / 12).truncate
    end
    
    def baths?
      !self.baths.blank?
    end

    def ==(other)
      self.id == other.id
    end
    
    def serialize
      to_json
    end

    def self.serialize(object)
      object.to_json
    end
    
    def self.deserialize(value)
      new( JSON.parse( value ) )
    end

  end

end
