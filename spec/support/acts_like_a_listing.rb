shared_examples 'a listing' do

  %w( id status kind address street city county country price beds baths listing_url thumbnail_url image_url caption description summary latitude longitude created_at updated_at agent_name agent_logo_url ).each do |attribute|
    it "responds to #{ attribute }" do
      expect( subject.respond_to?(attribute) ).to be_true
    end
  end

end
