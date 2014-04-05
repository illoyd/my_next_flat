require 'spec_helper'

describe Zoopla::CachedListings, :vcr do

  def zoopla_location_params(location)
    {
      area:    location.area,
      country: location.country,
      radius:  location.radius
    }.with_indifferent_access
  end

  def zoopla_criteria_params(criteria)
    {
      listing_status: (criteria.class == BuyCriteria ? 'sale' : 'rent'),
      minimum_price:  criteria.min_price,
      maximum_price:  criteria.max_price,
      minimum_beds:   criteria.min_beds,
      maximum_beds:   criteria.max_beds,
      minimum_baths:  criteria.min_baths,
      maximum_baths:  criteria.max_baths
    }.with_indifferent_access
  end
  
  def merge_params(left, right)
    trim_params(left.merge(right))
  end
  
  def trim_params(params)
    return params.map{ |item| trim_params(item) } if params.is_a?(Array)
    params.reject{ |k,v| v.nil? }
  end
  
  context 'with simple search' do
    let(:search)   { build(:search, locations: [location], criterias: [criteria]) }
    let(:location) { build(:location, area: 'SE10', search: nil) }
    let(:criteria) { build(:buy_criteria, :with_prices, search: nil) }

    let(:location_params)     { trim_params(zoopla_location_params(location)) }
    let(:criteria_params)     { trim_params(zoopla_criteria_params(criteria)) }
    let(:query_params)        { merge_params(location_params, criteria_params) }

    let(:expected_location_cache_key) { "zoopla:listings:area=se10:radius=#{ location.radius }" }
    let(:expected_criteria_cache_key) { "zoopla:listings:listing_status=sale:maximum_price=#{ criteria.max_price }:minimum_price=#{ criteria.min_price }" }
    let(:expected_query_cache_key)    { "zoopla:listings:area=se10:listing_status=sale:maximum_price=#{ criteria.max_price }:minimum_price=#{ criteria.min_price }:radius=#{ location.radius }" }

    describe '#cache_key_for' do
      it 'builds query for location' do
        expect( subject.cache_key_for(location_params) ).to eq(expected_location_cache_key)
      end
      it 'builds query for criteria' do
        expect( subject.cache_key_for(criteria_params) ).to eq(expected_criteria_cache_key)
      end
      it 'builds query for query' do
        expect( subject.cache_key_for(query_params) ).to eq(expected_query_cache_key)
      end
    end
    
  end
  
  describe '#search' do
    let(:search)   { build(:search, locations: [location], criterias: [criteria]) }

    context 'with valid search' do
      let(:location) { build(:location, area: 'SE10', search: nil) }
      let(:criteria) { build(:buy_criteria, :with_prices, search: nil) }
      
      it 'queries service' do
        expect{ subject.search(search) }.not_to raise_error
      end
      
      it 'returns some items' do
        expect( subject.search(search) ).not_to be_empty
      end
      
      it 'returns only listings' do
        expect( subject.search(search).all?{ |item| item.is_a?(Zoopla::Listing) } ).to be_true
      end
    end # with valid search
    
    context 'with disambiguation search' do      
      let(:location) { build(:location, area: 'Whitechapel', search: nil) }
      let(:criteria) { build(:buy_criteria, :with_prices, search: nil) }
      
      it 'raises disambiguation error' do
        expect{ subject.search(search) }.to raise_error(Zoopla::DisambiguationError)
      end
    end

    context 'with unknown location search' do      
      let(:location) { build(:location, area: 'Stok', search: nil) }
      let(:criteria) { build(:buy_criteria, :with_prices, search: nil) }
      
      it 'raises unknown location error' do
        expect{ subject.search(search) }.to raise_error(Zoopla::UnknownLocationError)
      end
    end
    
    context 'with two locations' do
      let(:search)    { build(:search, locations: [location1, location2], criterias: [criteria]) }
      let(:search1)   { build(:search, locations: [location1], criterias: [criteria]) }
      let(:search2)   { build(:search, locations: [location2], criterias: [criteria]) }

      let(:location1) { build(:location, area: 'SE10', search: nil) }
      let(:location2) { build(:location, area: 'NW10', search: nil) }
      let(:criteria)  { build(:buy_criteria, :with_prices, search: nil) }
      
      it 'queries service' do
        expect{ subject.search(search) }.not_to raise_error
      end
      
      it 'combines location searches to return all results' do
        results1 = subject.search(search1, page_size: 2).map { |listing| listing.address }
        results2 = subject.search(search2, page_size: 2).map { |listing| listing.address }
        expected_results = (results1 + results2).uniq
        expect( subject.search(search, page_size: 2).map { |listing| listing.address }.to_a ).to match_array(expected_results)
      end
    end

  end #search

end
