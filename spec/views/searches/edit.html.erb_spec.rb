require 'spec_helper'

describe "searches/edit" do
  before(:each) do
    @search = assign(:search, stub_model(Search,
      :name => "MyString",
      :user => nil
    ))
  end

  it "renders the edit search form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", search_path(@search), "post" do
      assert_select "input#search_name[name=?]", "search[name]"
    end
  end
end
