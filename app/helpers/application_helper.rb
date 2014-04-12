module ApplicationHelper

  def alert_class_for(kind)
    kind = case kind
      when 'notice'
        'info'
      when 'alert'
        'warning'
      else
        kind
      end
    "alert-#{ kind }"
  end
  
  def map_tag(search, options={})
    options.reverse_merge!(src: map_url('place', search), frameborder: 0)
    content_tag(:iframe, '', options)
  end
  
  def map_url(mode, search, params={})
    params.reverse_merge!( q: search, key: Rails.application.secrets.google_maps_embed_api_key )
    "https://www.google.com/maps/embed/v1/#{ mode }?#{ params.to_query }"
  end

  def link_to_add_fields(name=nil, f=nil, association=nil, &block)
    f, association = name, f if block_given?
  
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    
    html_options = { onclick: "add_section(this, \"#{association}\", \"#{escape_javascript(fields)}\"); return false;" }
    
    if block_given?
      link_to('#', html_options, &block)
    else
      link_to(name, '#', html_options)
    end
  end
  
  def number_to_sterling_buy(value)
    "&pound;#{ number_with_delimiter(value / 1_000) }k".html_safe
  end
  
  alias_method :number_to_sterling, :number_to_sterling_buy
  
  def number_to_sterling_let(value)
    "&pound;#{ number_with_delimiter(value) }pcm".html_safe
  end
  
  def results_count(search)
    Zoopla::CachedListings.new.search(search, {}, {allow_query: false}).count
  end
  
  def price_for(listing)
    number_to_price(listing.to_let? ? listing.price_per_calendar_month : listing.price, listing.to_let?)
  end

  def number_to_price(price, to_let=false)
    to_let ? number_to_sterling_let(price) : number_to_sterling_buy(price)
  end
  
  def number_to_fraction(number, options={})
    case number
      when (1.to_f/2) then '&frac12;' # One half
      when (1.to_f/4) then '&frac14;' # One quarter
      when (3.to_f/4) then '&frac34;' # Three quarters
      when (1.to_f/3) then '&#x2153;' # One third
      when (2.to_f/3) then '&#x2154;' # Two thirds
      when (1.to_f/5) then '&#x2155;' # One fifth
      when (2.to_f/5) then '&#x2156;' # Two fifths
      when (3.to_f/5) then '&#x2157;' # Three fifths
      when (4.to_f/5) then '&#x2158;' # Four fifths
      when (1.to_f/6) then '&#x2159;' # One sixth
      when (5.to_f/6) then '&#x215A;' # Five sixths
      when (1.to_f/8) then '&#x215B;' # One eighth
      when (3.to_f/8) then '&#x215C;' # Three eighths
      when (5.to_f/8) then '&#x215D;' # Five eighths
      when (7.to_f/8) then '&#x215E;' # Seven eighths
      else number_with_delimiter(number, options)
   end
  end
  
  def beds_for(beds)
    beds = beds.try(:beds) || beds
    case beds
      when 0
        'studio'
      else
        pluralize(beds, 'bed')
    end
  end
  
  def baths_for(baths)
    baths = baths.try(:baths) || baths
    pluralize(baths, 'bath')
  end

end
