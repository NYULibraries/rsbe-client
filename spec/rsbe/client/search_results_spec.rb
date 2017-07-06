require 'ostruct'

describe Rsbe::Client::SearchResults do
  context "when searching by digi_id", vcr: {cassette_name: 'search_results/search-by-digi_id'} do
    let(:search_params) {  { 
        params: { 
          digi_id: 'foo_quux_cuid370'
        },
        required_params: [],
        scope: "ses"
      }
    }
    let(:response) { Rsbe::Client::Search.search(search_params) }
    let(:sut) { Rsbe::Client::SearchResults.new(response) }

    describe '.new' do
      it 'should return the correct class' do
        expect(sut.class).to eq(Rsbe::Client::SearchResults)
      end
    end
    
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

  context "when searching by step", vcr: {cassette_name: 'search_results/search-by-step'} do
    let(:search_params) {  { 
        params: { 
          step: 'qc'
        },
        required_params: [],
        scope: "ses"
      }
    }

    let(:response) { Rsbe::Client::Search.search(search_params) }
    let(:sut) { Rsbe::Client::SearchResults.new(response) }

    describe '#results' do
      it 'should return the correct count' do
        expect(sut.results.length).to eq(3)
      end

      it 'should return the correct object type' do
        expect(sut.results[0].class).to eq(Rsbe::Client::Se)
        expect(sut.results[1].class).to eq(Rsbe::Client::Se)
        expect(sut.results[2].class).to eq(Rsbe::Client::Se)
      end

      it 'should return the objects with the expected ids' do
        expect(sut.results[0].id).to eq('80354e46-1f07-47bf-9093-035000b85b7c')
        expect(sut.results[1].id).to eq('6549aeb6-05e9-48a9-91dd-266afd4d53ed')
        expect(sut.results[2].id).to eq('68472925-c271-4643-b90a-ee2da34e8c69')
      end

      it 'should return the object with the expected step' do
        expect(sut.results[0].step).to eq('qc')
        expect(sut.results[1].step).to eq('qc')
        expect(sut.results[2].step).to eq('qc')
      end
    end
  end
end
