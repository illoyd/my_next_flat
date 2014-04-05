require 'spec_helper'

describe 'Zoopla::Service', :vcr, :skip do
  it_behaves_like 'a listing service'

  def zoopla_location_params(location)
    {
      area:    location.area,
      country: location.country,
      radius:  location.radius
    }
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
    }
  end
  
  def merge_params(left, right)
    trim_params(left.merge(right))
  end
  
  def trim_params(params)
    return params.map{ |item| trim_params(item) } if params.is_a?(Array)
    params.reject{ |k,v| v.nil? }
  end

  context 'with simple search' do
    let(:search)                { build(:search) }
    let(:location)              { search.locations.first }
    let(:criteria)              { search.criterias.first }

    let(:expected_location)     { zoopla_location_params(location) }
    let(:expected_criteria)     { zoopla_criteria_params(criteria) }

    let(:expected_query)        { merge_params(expected_location, expected_criteria) }
    let(:expected_queries)      { [expected_query] }

    let(:expected_combination)  { [location, criteria] }
    let(:expected_combinations) { [expected_combination] }
    
    describe '#build_location_params' do
      it 'provides the search params' do
        expect( subject.send(:build_location_params, location) ).to eq(expected_location)
      end      
    end

    describe '#build_criteria_params' do
      it 'provides the search params' do
        expect( subject.send(:build_criteria_params, criteria) ).to eq(expected_criteria)
      end      
    end

    describe '#build_params' do
      it 'provides the search params for a location' do
        expected_location.reject!{ |k,v| v.nil? }
        expect( subject.send(:build_params, location) ).to eq(expected_location)
      end      

      it 'provides the search params for a criteria' do
        expected_criteria.reject!{ |k,v| v.nil? }
        expect( subject.send(:build_params, criteria) ).to eq(expected_criteria)
      end

      it 'raises error on object' do
        expect{ subject.send(:build_params, Object.new) }.to raise_error(Zoopla::Error)
      end
    end
    
    describe '#build_query' do
      it 'builds query for location' do
        expected_location.reject!{ |k,v| v.nil? }
        expect( subject.send(:build_query, location) ).to eq(expected_location)
      end
      it 'builds query for criteria' do
        expected_criteria.reject!{ |k,v| v.nil? }
        expect( subject.send(:build_query, criteria) ).to eq(expected_criteria)
      end
      it 'builds query for 2 locations' do
        expected_location.reject!{ |k,v| v.nil? }
        expect( subject.send(:build_query, [location, location]) ).to eq(expected_location)
      end
      it 'builds query for 2 criterias' do
        expected_criteria.reject!{ |k,v| v.nil? }
        expect( subject.send(:build_query, [criteria, criteria]) ).to eq(expected_criteria)
      end
      it 'builds query for [criteria, location]' do
        expect( subject.send(:build_query, [location, criteria]) ).to eq(expected_query)
      end
      it 'builds query for [criteria, location]' do
        expect( subject.send(:build_query, [criteria, location]) ).to eq(expected_query)
      end
    end
    
    describe '#query_combinations' do
      it 'assembles one query' do
        expect( subject.send(:query_combinations, search) ).to match_array(expected_combinations)
      end
    end
    
    describe '#build_queries' do
      it 'assembles one query' do
        expect( subject.send(:build_queries, search) ).to match_array(expected_queries)
      end
    end

  end
  
  context 'with two locations and two criterias' do
    let(:search)           { build(:search, :random, location_count: 2, criteria_count: 2) }
    let(:expected_query_1) { merge_params( zoopla_location_params(search.locations[0]), zoopla_criteria_params(search.criterias[0]) ) }
    let(:expected_query_2) { merge_params( zoopla_location_params(search.locations[0]), zoopla_criteria_params(search.criterias[1]) ) }
    let(:expected_query_3) { merge_params( zoopla_location_params(search.locations[1]), zoopla_criteria_params(search.criterias[0]) ) }
    let(:expected_query_4) { merge_params( zoopla_location_params(search.locations[1]), zoopla_criteria_params(search.criterias[1]) ) }
    let(:expected_queries) { [expected_query_1, expected_query_2, expected_query_3, expected_query_4] }

    it 'provides four queries' do
      expect( subject.send(:build_queries, search) ).to have(4).queries
    end

    it 'assembles four queries' do
      expect( subject.send(:build_queries, search) ).to match_array(expected_queries)
    end
  end

  context 'with three locations and two criterias' do
    let(:search)           { build(:search, :random, location_count: 3, criteria_count: 2) }
    let(:expected_query_1) { merge_params( zoopla_location_params(search.locations[0]), zoopla_criteria_params(search.criterias[0]) ) }
    let(:expected_query_2) { merge_params( zoopla_location_params(search.locations[0]), zoopla_criteria_params(search.criterias[1]) ) }
    let(:expected_query_3) { merge_params( zoopla_location_params(search.locations[1]), zoopla_criteria_params(search.criterias[0]) ) }
    let(:expected_query_4) { merge_params( zoopla_location_params(search.locations[1]), zoopla_criteria_params(search.criterias[1]) ) }
    let(:expected_query_5) { merge_params( zoopla_location_params(search.locations[2]), zoopla_criteria_params(search.criterias[0]) ) }
    let(:expected_query_6) { merge_params( zoopla_location_params(search.locations[2]), zoopla_criteria_params(search.criterias[1]) ) }
    let(:expected_queries) { [expected_query_1, expected_query_2, expected_query_3, expected_query_4, expected_query_5, expected_query_6] }

    it 'provides six queries' do
      expect( subject.send(:build_queries, search) ).to have(6).queries
    end

    it 'assembles six queries' do
      expect( subject.send(:build_queries, search) ).to match_array(expected_queries)
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
      let(:location) { build(:location, area: 'S', search: nil) }
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
        results1 = subject.search(search1)
        results2 = subject.search(search2)
        expect( subject.search(search) ).to match_array(results1 + results2)
      end
    end

  end #search

#   reload!
#   FactoryGirl.find_definitions
#   location = FactoryGirl.build(:location, area: 'S', search: nil)
#   criteria = FactoryGirl.build(:buy_criteria, :with_prices, search: nil)
#   search = FactoryGirl.build(:search, user: nil, locations: [location], criterias: [criteria])
#   Zoopla::Service.new.search(search)
  
end
