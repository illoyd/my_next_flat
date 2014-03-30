require 'spec_helper'

describe Location do

  describe '#blank?' do
    it 'is blank with 0 radius and nil area' do
      ll = Location.new( area: nil, radius: 0.0 )
      expect(ll).to be_blank
    end

    it 'is blank with nil radius and nil area' do
      ll = Location.new( area: nil, radius: nil )
      expect(ll).to be_blank
    end

    it 'is not blank with blank radius' do
      ll = Location.new( area: 'Test', radius: nil )
      expect(ll).not_to be_blank
    end

    it 'is not blank with 0 radius' do
      ll = Location.new( area: 'Test', radius: 0.0 )
      expect(ll).not_to be_blank
    end

    it 'is not blank with positive radius' do
      ll = Location.new( area: 'Test', radius: 0.25 )
      expect(ll).not_to be_blank
    end
  end

end
