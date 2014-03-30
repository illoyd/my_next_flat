require 'spec_helper'

describe "searches/new" do
  before(:each) do
    assign(:search, stub_model(Search,
      :name => "MyString",
      :user => nil
    ).as_new_record)
  end

  it "renders new search form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", searches_path, "post" do
      assert_select "input#search_name[name=?]", "search[name]"
      assert_select "input#search_user[name=?]", "search[user]"
    end
  end
end
