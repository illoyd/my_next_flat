require 'spec_helper'

describe Zoopla::CachedListings, :vcr, :focus do

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

    let(:expected_location)     { zoopla_location_params(location) }
    let(:expected_criteria)     { zoopla_criteria_params(criteria) }

    let(:expected_query)        { merge_params(expected_location, expected_criteria) }
    let(:expected_queries)      { [expected_query] }

    let(:expected_combination)  { [location, criteria] }
    let(:expected_combinations) { [expected_combination] }

    describe '#where' do
      it 'builds query for location' do
        expected_location.reject!{ |k,v| v.nil? }
        expect( subject.where(location) ).to be_hash_matching(expected_location)
      end
      it 'builds query for criteria' do
        expected_criteria.reject!{ |k,v| v.nil? }
        expect( subject.where(criteria) ).to be_hash_matching(expected_criteria)
      end
      it 'builds query for 2 locations' do
        expected_location.reject!{ |k,v| v.nil? }
        expect( subject.where(location, location) ).to be_hash_matching(expected_location)
      end
      it 'builds query for 2 criterias' do
        expected_criteria.reject!{ |k,v| v.nil? }
        expect( subject.where(criteria, criteria) ).to be_hash_matching(expected_criteria)
      end
      it 'builds query for [criteria, location]' do
        expect( subject.where(location, criteria) ).to be_hash_matching(expected_query)
      end
      it 'builds query for [criteria, location]' do
        expect( subject.where(criteria, location) ).to be_hash_matching(expected_query)
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
      let(:search1)    { build(:search, locations: [location1], criterias: [criteria]) }
      let(:search2)    { build(:search, locations: [location2], criterias: [criteria]) }

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
        expect( subject.search(search, page_size: 2).map { |listing| listing.address } ).to match_array(expected_results)
      end
    end

  end #search

#   reload!
#   FactoryGirl.search_definitions
#   location = FactoryGirl.build(:location, area: 'S', search: nil)
#   criteria = FactoryGirl.build(:buy_criteria, :with_prices, search: nil)
#   search = FactoryGirl.build(:search, user: nil, locations: [location], criterias: [criteria])
#   Zoopla::Service.new.search(search)
  
end
