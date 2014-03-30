require 'spec_helper'

describe Search do
  subject { build(:search, :with_daily_schedule) }
  
  describe "#save!" do
    it 'does not raise error' do
      expect{ build(:search).save! }.not_to raise_error
    end
  end
  
  describe '#update_next_run_at' do
    it 'updates next run at' do
      expect{ subject.send(:update_next_run_at) }.to change(subject, :next_run_at).from(nil)
    end
  end

  describe 'serializers' do
    before { subject.save! } 
    it 'has a schedule' do
      expect( Search.find(subject.id).schedule ).not_to be_nil
    end
    it 'serializes and deserializes schedule' do
      expect( Search.find(subject.id).schedule ).to be_a(IceCube::Schedule)
    end
  end

end
