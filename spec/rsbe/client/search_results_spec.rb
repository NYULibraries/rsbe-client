require 'ostruct'

describe Rsbe::Client::SearchResults do
  let(:response) { OpenStruct.new(status: 200) }
  let(:sut) { Rsbe::Client::SearchResults.new(response) }

  describe '.new' do
    it 'should return the correct class' do
      expect(sut.class).to eq(Rsbe::Client::SearchResults)
    end
  end

  describe '.success?' do
    it 'should return true for a valid search' do
      expect(sut.success?).to eq(true)
    end
  end
end
