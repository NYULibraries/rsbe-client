describe Search do
  describe ".search" do
    context "with valid params", vcr: {cassette_name: 'search/search-with-existing-se'} do
      let(:valid_params) {    {:params=>{:coll_id=>"ea85c776-a79b-4603-b307-d6760a400281", :digi_id=>"AD-MT-0123"},
 :required_params=>[:coll_id, :digi_id],
 :scope=>"ses"}}
      let(:rsp) { Search.search(valid_params) }
      it "should have a response status of 200" do
        expect(rsp.status).to eq(200)
      end
    end
    context "with invalid params" do
      it "raises an error if params are empty" do
        expect{ Search.search }.to raise_error(ArgumentError)
      end
      it "raises an error if a string param is sent" do
        expect{ Search.search("foo") }.to raise_error(ArgumentError)
      end
      it "raises an error if param with incorrect keys is sent" do
        expect{ Search.search({foo: "foo"}) }.to raise_error(ArgumentError)
      end
      it "raises an error if param with valid but string keys are sent" do
        string_hsh = { "params" => "params", "required_params" => %w(foo bar), "scope" => "scope"}
        expect{ Search.search(string_hsh) }.to raise_error(ArgumentError)
      end
      it "raises an error if params has differing keys from the required params array" do
        bad_keys = {:params=>{:collection_id=>"ea85c776-a79b-4603-b307-d6760a400281", :digi_id=>"AD-MT-0123"},
   :required_params=>[:coll_id, :digi_id],
   :scope=>"ses"}
        expect{ Search.search(bad_keys) }.to raise_error(ArgumentError)
      end
    end
  end
end
