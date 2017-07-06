require 'ostruct'

describe Rsbe::Client::SearchResults do
  let(:valid_params) {  { 
      params: { 
        digi_id: 'foo_quux_cuid370'
      },
      required_params: [],
      scope: "ses"
    }
  }
  let(:response) { Rsbe::Client::Search.search(valid_params) }
  let(:sut) { Rsbe::Client::SearchResults.new(response) }

  describe '.new' do
    it 'should return the correct class' do
      expect(sut.class).to eq(Rsbe::Client::SearchResults)
    end
  end

#  context "with valid search parameters" , vcr: {cassette_name: 'search_results/valid-search-params'} do
  context "when searching by digi_id" do
    describe '#success?' do
      it 'should return true' do
        expect(sut.success?).to eq(true)
      end
    end

    describe '#num_found' do
      it 'should return the correct count' do
        expect(sut.num_found).to eq(1)
      end
    end

    describe '#results' do
      it 'should return the correct count' do
        expect(sut.results.length).to eq(1)
      end

      it 'should return the correct object type' do
        expect(sut.results.first.class).to eq(Rsbe::Client::Se)
      end

      it 'should return the object with the expected id' do
        expect(sut.results.first.id).to eq('f903ee1f-83e3-4ba2-8234-0d0b85793705')
      end

      it 'should return the object with the expected digi_id' do
        expect(sut.results.first.digi_id).to eq('foo_quux_cuid370')
      end
    end

    describe 'PRIVATE METHOD: #docs' do
      it 'should return the correct count' do
        expect(sut.send(:docs).size).to eq(1)
      end
    end

    describe 'PRIVATE METHOD: #urls' do
      it 'should return the correct URL' do
        expected = "http://localhost:3000/api/v0/ses/f903ee1f-83e3-4ba2-8234-0d0b85793705" 
        expect(sut.send(:urls)[0]).to eq(expected)
      end
    end
  end
end
