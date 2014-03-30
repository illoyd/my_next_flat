require 'spec_helper'

describe Zoopla::Listing do
  let(:attributes) do
    JSON.parse('{"image_caption":"","status":"for_sale","num_floors":"0","listing_status":"sale","num_bedrooms":"1","agent_name":"Ludlowthompson.com - Lewisham / Greenwich","latitude":51.49395,"agent_address":"258 Lewisham High Street","num_recepts":"0","property_type":"Flat","country":"England","longitude":0.012081,"first_published_date":"2014-03-27 23:17:57","displayable_address":"Greenroof Way, London SE10","street_name":"Greenroof Way","num_bathrooms":"0","thumbnail_url":"http://li.zoocdn.com/f29a227b30600042f8079c8196c28251d7e4a1cb_80_60.jpg","description":"Stunning apartment situated in the highly sought after millenium village in SE10..This property has A larger than average square footage and A private terrace, secure parking, concierge service, stunning finish throughout, modern bathroom, kitchen, spacious living/dining room, spacious bedroom. This must be viewed immediately as there is no forward chain! Offers invited call us now!","post_town":"London","details_url":"http://www.zoopla.co.uk/for-sale/details/32485643?utm_source=v1:--LHAS6eGhbT-0queK8yvT78PEI0zbqB&utm_medium=api","agent_logo":"http://st.zoocdn.com/zoopla_static_agent_logo_(48990).gif","price_change":[{"date":"2014-03-27 22:24:39","price":"309995"}],"short_description":"Stunning apartment situated in the highly sought after millenium village in SE10..This property has A larger than average square footage and A private terrace, secure parking, concierge service, st...","agent_phone":"020 3463 0354","outcode":"SE10","image_url":"http://li.zoocdn.com/f29a227b30600042f8079c8196c28251d7e4a1cb_354_255.jpg","last_published_date":"2014-03-27 23:42:41","county":"London","price":"309995","listing_id":"32485643"}')
  end
  let(:json_string) { subject.to_json }
  let(:json_object) { JSON.parse(json_string) }
  subject           { Zoopla::Listing.new(attributes) }

  it_behaves_like 'a listing'
  
  it 'serializes to JSON' do
    expect{ subject.to_json }.not_to raise_error
  end

  it 'can deserialize from JSON' do
    expect( described_class.new(json_object) ).to be_a(described_class)
  end
end
