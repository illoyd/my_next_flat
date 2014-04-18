module Zoopla

  class Listing < APISmith::Smash
  
    property :id,            required: true, from: :listing_id

    property :status,        required: true, transformer: StringInquirerTransformer
    property :kind,          required: true, from: :property_type, transformer: StringInquirerTransformer

    property :address,       from: :displayable_address, transformer: BlankToNilTransformer
    property :street,        from: :street_name,         transformer: BlankToNilTransformer
    property :city,          from: :post_town,           transformer: BlankToNilTransformer
    property :outcode,                                   transformer: BlankToNilTransformer
    property :county,                                    transformer: BlankToNilTransformer
    property :country,                                   transformer: BlankToNilTransformer

    property :price,         required: true,             transformer: IntegerTransformer
    property :price_modifier,                            transformer: BlankToNilTransformer

    property :beds,          from: :num_bedrooms,        transformer: IntegerTransformer
    property :baths,         from: :num_bathrooms,       transformer: FloatTransformer
    property :receptions,    from: :num_receptions,      transformer: IntegerTransformer

    property :listing_url,   from: :details_url
    property :image_url
    property :thumbnail_url

    property :description
    property :summary,        from: :short_description, transformer: BlankToNilTransformer
    property :caption,        from: :image_caption,     transformer: BlankToNilTransformer

    property :latitude,       transformer: FloatTransformer
    property :longitude,      transformer: FloatTransformer

    property :agent_name
    property :agent_logo_url, from: :agent_logo

    property :created_at,     from: :first_published_date, transformer: TimeTransformer
    property :updated_at,     from: :last_published_date, transformer: TimeTransformer
    
    delegate :to_rent?, :for_sale?, to: :status
    alias_method :to_buy?, :for_sale?
    alias_method :to_let?, :to_rent?
    
    def price_per_calendar_month
      return 0 if self.for_sale?
      (self.price.to_f * 52 / 12).truncate
    end
    
    def beds?
      !self.beds.blank? && self.beds > 0
    end
    
    def baths?
      !self.baths.blank? && self.baths > 0
    end

    def receptions?
      !self.receptions.blank? && self.receptions > 0
    end
    
    def city?
      !self.city.blank?
    end
    
    def outcode?
      !self.outcode.blank?
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
