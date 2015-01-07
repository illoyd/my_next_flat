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
  
  def title_for(listing)
    listing.try(:display_name) || 'New Listing'
  end
  
  def photo_tag_for(user)
    image_tag(user.try(:photo_url) || 'default.png', style: 'height: 30px;')
  end
  
  def big_photo_tag_for(user)
    image_tag(user.try(:big_photo_url) || 'default.png')
  end
  
  ##
  # Create a font-awesome icon
  def icon( kind = :blank, options = {} )
    kind = ICONS.fetch(kind, kind.to_s.gsub(/_/, '-'))
    
    # Convert options into a hash and move option value into the :class key
    options = { class: options } if options.is_a?(String) || options.is_a?(Array)

    options[:class] = [ 'fa', "fa-#{kind}", options[:class] ].compact
    content_tag(:i, '', options)
  end  
  
  ##
  # Prefix a string with an icon
  def iconify(label, icon, options = {})
    contents = "#{ icon(icon, options) }&nbsp;#{ label }".strip.html_safe
    content_tag(:span, contents, {style: 'white-space:nowrap;'})
  end

  def label2(text, label, *classes)
    "<span class=\"label label-#{ label } #{ Array(classes).join(' ') }\">#{ text }</span>".html_safe
  end
  
  def field_error_icon(errors)
    return nil unless errors.try(:any?)
    %(
      <span rel="popover" class="field_error_icon" data-container="body" data-content="#{ errors.join(',') }" data-placement="top" data-toggle="popover" data-trigger="hover">
        <span class="fa fa-info-circle"></span>
      </span>
    ).html_safe
  end
  
  def listing_status_label(listing, *classes)
    case
    when listing.for_sale? then label2('for sale', :buy, *classes)
    when listing.to_let?   then label2('to let', :let, *classes)
    else
      label2(listing.status, :default, *classes)
    end
  end
  
  def badge(text, label, *classes)
    "<span class=\"badge badge-#{ label } #{ Array(classes).join(' ') }\">#{ text }</span>".html_safe
  end
  
  def map_tag(search, options={})
    options.reverse_merge!(src: map_url('place', search), frameborder: 0)
    content_tag(:iframe, '', options)
  end
  
  def map_url(mode, search, params={})
    params.reverse_merge!( q: search, key: Rails.application.secrets.google_maps_embed_api_key )
    "https://www.google.com/maps/embed/v1/#{ mode }?#{ params.to_query }"
  end
  
  def results_count(search)
    Zoopla::CachedListings.new.search(search, {}, {allow_query: false}).count
  end
  
  def format_zoopla_description(description)
    return nil if description.blank?
    
    # Insert section breaks where appropriate
    description.gsub!(/([a-z])([A-Z])/,'\1<br/>\2')

    # Insert paragraph breaks where appropriate
    description.gsub!(/([.!?*-])([A-Z"])/, '\1<br/><br/>\2')
    
    # Convert all new lines to BRs
    description.gsub!(/\n/, '<br/>')

    description.html_safe
  end

  def link_to_add_fields(name=nil, f=nil, association=nil, &block)
    f, association = name, f if block_given?
  
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    
    html_options = { onclick: "add_section(this, \"#{association}\", \"#{escape_javascript(fields)}\"); return false;", class: 'btn btn-default btn-sm' }
    
    if block_given?
      link_to('#', html_options, &block)
    else
      link_to(name, '#', html_options)
    end
  end

  def link_to_add_fields_with_type(name=nil, f=nil, association=nil, type_class=nil, &block)
    f, association, type_class = name, f, association if block_given?
  
    new_object = type_class.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(partial: type_class.to_s.singularize.underscore + "_fields", locals: {f: builder}, layout: 'layouts/criterium')
    end
    
    html_options = { onclick: "add_section(this, \"#{association}\", \"#{escape_javascript(fields)}\"); return false;", class: 'btn btn-default btn-sm' }
    
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
  
  def price_for(listing)
    price = number_to_price(listing.to_let? ? listing.price_per_calendar_month : listing.price, listing.to_let?)

    case listing.price_modifier
    when 'poa'                 then 'POA'
    when 'price_on_request'    then 'POR'
    when 'offers_over'         then "over #{price}"
    when 'from'                then "from #{price}"
    when 'offers_in_region_of' then "in region of #{price}"
    when 'part_buy_part_rent'  then "#{price} (part buy part rent)"
    when 'shared_equity'       then "#{price} (shared equity)"
    when 'shared_ownership'    then "#{price} (shared ownership)"
    when 'guide_price'         then "#{price} (guide)"
    when 'sale_by_tender'      then "#{price} by tender"
    else
      price
    end.html_safe
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
    whole_baths = baths.truncate
    half_baths = (baths - whole_baths).round(1) == 0.5 ? '&frac12;' : nil
    "#{ whole_baths }#{ half_baths } #{ 'bath'.pluralize(baths) }"
  end
  
  def receptions_for(receptions)
    receptions = receptions.try(:receptions) || receptions
    pluralize(receptions, 'reception')
  end

end
