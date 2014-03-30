shared_examples 'a listing service' do

  %w( search ).each do |attribute|
    it "responds to #{ attribute }" do
      expect( subject.respond_to?(attribute) ).to be_true
    end
  end

end
