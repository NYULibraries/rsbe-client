describe Rsbe::Client do
  describe '.find' do
    context 'when object exists' do
      context 'and URL points to a Partner' do
        pending 'it should return a Partner object'
        pending 'the Partner object should have the correct id'
      end

      context 'and URL points to a Collection' do
        pending 'it should return a Collection object'
        pending 'the Collection object should have the correct id'
      end

      context 'and URL points to a Provider' do
        pending 'it should return a Provider object'
        pending 'the Provider object should have the correct id'
      end

      context 'and URL points to an Se' do
        pending 'it should return an Se object'
        pending 'the Se object should have the correct id'
      end
    end

    context 'when object does not exist' do
      pending 'it should return nil'
    end

    context 'when hostname does not match RSBE_URL' do
      pending 'it should raise an exception'
    end
  end
end

