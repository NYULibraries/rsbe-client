require 'ostruct'

describe Rsbe::Client::SearchResults do
  describe '.new' do
    it 'should return the correct class' do
      expect(Rsbe::Client::SearchResults.new({}).class).to eq(Rsbe::Client::SearchResults)
    end
  end

  context "with valid search parameters" do
    valid_params = { params: { 
        coll_id: "ea85c776-a79b-4603-b307-d6760a400281",
        digi_id: "foo_quux_cuid370"
      },
      required_params: [],
      scope: "ses"
    }

    let(:response) { Rsbe::Client::Search.search(valid_params) }
    describe '.success?' do
      let(:sut) { Rsbe::Client::SearchResults.new(response) }
    
      it 'should return true for a valid search' do
        expect(sut.success?).to eq(true)
      end
    end
  end
end
