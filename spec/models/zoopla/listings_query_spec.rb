require 'spec_helper'

describe Zoopla::ListingsQuery, :vcr do

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
    
    describe '#params_for' do
      it 'provides the search params for a location' do
        expected_location.reject!{ |k,v| v.nil? }
        expect( subject.params_for(location) ).to eq(expected_location)
      end      

      it 'provides the search params for a criteria' do
        expected_criteria.reject!{ |k,v| v.nil? }
        expect( subject.params_for(criteria) ).to eq(expected_criteria)
      end

      it 'raises error on object' do
        expect{ subject.params_for(Object.new) }.to raise_error(Zoopla::Error)
      end
    end
    
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
  
  describe '#execute' do
    let(:location) { build(:location, area: 'SE10', search: nil) }
    let(:criteria) { build(:buy_criteria, :with_prices, search: nil) }

    context 'with only location' do
      let(:location) { build(:location, area: 'SE10', search: nil) }
      it 'finds for location' do
        expect( subject.where(location).execute ).to be_a(Enumerable)
      end
      it 'finds for 2 locations' do
        expect( subject.where(location, location).execute ).to be_a(Enumerable)
      end
    end
    
    context 'with only criteria' do
      let(:criteria) { build(:buy_criteria, :with_prices, search: nil) }
      it 'finds for criteria' do
        expect{ subject.where(criteria).execute }.to raise_error(Zoopla::UnknownLocationError)
      end
      it 'finds for 2 criterias' do
        expect{ subject.where(criteria, criteria).execute }.to raise_error(Zoopla::UnknownLocationError)
      end
    end

    context 'with both location and criteria' do
      it 'finds for [location, criteria]' do
        expect( subject.where(location, criteria).execute ).to be_a(Enumerable)
      end
      it 'finds for [criteria, location]' do
        expect( subject.where(criteria, location).execute ).to be_a(Enumerable)
      end
    end

  end #search

end
