describe Rsbe::Client::Search do
  describe ".search" do
    def se_valid_params
      { :params =>
        { :coll_id => "ea85c776-a79b-4603-b307-d6760a400281",
          :digi_id=>"foo_quux_cuid370"
        },
        :required_params => [:coll_id, :digi_id],
        :scope=>"ses"
      }
    end

    def chk_header(scope, incoming_params)
      exist = []
      incoming_params.each_key { |k|
        s = k.to_sym
        chk_key = k == "scope" ? se_valid_params :
                  se_valid_params[:params]
        if chk_key.has_key?(s) && chk_key[s] == incoming_params[k]
          exist << true
        else
          exist << false
        end
      }
      exist
    end

    describe "se params" do
      context "with valid params", vcr: {cassette_name: 'search/search-with-existing-se'} do
        let(:valid_params) { se_valid_params   }
        let(:rsp) { Rsbe::Client::Search.search(se_valid_params) }
        let(:header) { JSON.parse(rsp.body)['responseHeader'] }
        let(:results) { JSON.parse(rsp.body)['response'] }
        it "should have a response status of 200" do
          expect(rsp.status).to eq(200)
        end
        it "should have numFound of 1" do
          expect(results['numFound']).to eq(1)
        end
        it "should have docs array of 1" do
          expect(results['docs'].size).to eq(1)
        end
        it "should have a url of a certain value" do
          expect(results['docs'][0]['url']).to eq("http://localhost:3000/api/v0/ses/f903ee1f-83e3-4ba2-8234-0d0b85793705")
        end
        it "should respond with a valid params in the responseHeader" do
          valid_header_params = chk_header(valid_params[:scope],header["params"])
          expect(valid_header_params).not_to include(false)
        end
      end
      context "with invalid params" do
        it "raises an error if params are empty" do
          expect{ Rsbe::Client::Search.search }.to raise_error(ArgumentError)
        end
        it "raises an error if a string param is sent" do
          expect{ Rsbe::Client::Search.search("foo") }.to raise_error(ArgumentError)
        end
        it "raises an error if param with incorrect keys is sent" do
          expect{ Rsbe::Client::Search.search({foo: "foo"}) }.to raise_error(ArgumentError)
        end
        it "raises an error if param with valid but string keys are sent" do
          string_hsh = { "params" => "params", "required_params" => %w(foo bar), "scope" => "scope"}
          expect{ Rsbe::Client::Search.search(string_hsh) }.to raise_error(ArgumentError)
        end
        it "raises an error if params has differing keys from the required params array" do
          bad_keys = {:params=>{:collection_id=>"ea85c776-a79b-4603-b307-d6760a400281", :digi_id=>"AD-MT-0123"},
          :required_params=>[:coll_id, :digi_id],
          :scope=>"ses"}
          expect{ Rsbe::Client::Search.search(bad_keys) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
