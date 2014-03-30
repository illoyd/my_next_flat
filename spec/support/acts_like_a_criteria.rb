shared_examples 'a criteria' do

  describe '#price_range' do
    subject { build(:buy_criteria, :with_prices) }
    it_behaves_like 'a range attribute', :price_range, :min_price, :max_price
  end

  describe '#beds_range' do
    subject { build(:buy_criteria, :with_beds) }
    it_behaves_like 'a range attribute', :beds_range, :min_beds, :max_beds
  end

  describe '#baths_range' do
    subject { build(:buy_criteria, :with_baths) }
    it_behaves_like 'a range attribute', :baths_range, :min_baths, :max_baths
  end
  
  describe '#includes?' do
    let(:other) { build(:buy_criteria) }

    context 'with prices' do
      subject { build(:buy_criteria, :with_prices) }
      include_examples 'an includeable range', :min_price, :max_price
    end

    context 'with beds' do
      subject { build(:buy_criteria, :with_beds) }
      include_examples 'an includeable range', :min_beds, :max_beds
    end

    context 'with baths' do
      subject { build(:buy_criteria, :with_baths) }
      include_examples 'an includeable range', :min_baths, :max_baths
    end
  end

end
