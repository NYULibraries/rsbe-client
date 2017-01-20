describe Rsbe::Client do
  PARTNER_URL    = 'http://localhost:3000/api/v0/partners/2f096796-c685-444f-a4fe-5971346b159d'
  COLLECTION_URL = 'http://localhost:3000/api/v0/colls/06347ad0-1bdb-433e-849b-f3744a4f2eed'
  PROVIDER_URL   = 'http://localhost:3000/api/v0/providers/51213be7-c8de-4e06-8cc2-06bfc82cdd68'
  SE_URL         = 'http://localhost:3000/api/v0/ses/acf51ef2-8bf3-4f05-9042-0bfCB6860560'
  NO_OBJECT_URL  = 'http://localhost:3000/api/v0/fluffy_bunnies/4bf6daf0-e065-46e2-af30-3f74b1f7478e' # does not exist

  describe '.find' do
    context 'when object exists' do
      context 'and URL points to a Partner' do
        subject { Rsbe::Client.find(PARTNER_URL) }
        it { should be_a(Rsbe::Client::Partner) }
        its(:id) { should == '2f096796-c685-444f-a4fe-5971346b159d' }
        its(:code) { should == 'fales' }
      end

      context 'and URL points to a Collection' do
        subject { Rsbe::Client.find(COLLECTION_URL) }
        it { should be_a(Rsbe::Client::Collection) }
        its(:id) { should == '06347ad0-1bdb-433e-849b-f3744a4f2eed' }
        its(:code) { should == 'alba_audio018' }
      end

      context 'and URL points to a Provider' do
        subject { Rsbe::Client.find(PROVIDER_URL) }
        it { should be_a(Rsbe::Client::Provider) }
        its(:id) { should == '51213be7-c8de-4e06-8cc2-06bfc82cdd68' }
        its(:name) { should == 'Calpurnia' }
      end

      context 'and URL points to an Se' do
        subject { Rsbe::Client.find(SE_URL) }
        it { should be_a(Rsbe::Client::Se) }
        its(:id) { should == 'acf51ef2-8bf3-4f05-9042-0bfcb6860560' }
        its(:digi_id) { should == 'foo_quux_cuid01234' }
      end
    end

    context 'when URL does not match an existing rsbe resource' do
      it 'should raise an exception' do
        expect { Rsbe::Client.find(NO_OBJECT_URL) }.to raise_error Rsbe::Client::UnrecognizedResourceError
      end
    end

    context 'when URL origin does not match the current connection configuration' do
      it 'should raise an exception' do
        expect { Rsbe::Client.find('some-bogus-url') }.to raise_error Rsbe::Client::WrongOriginError
      end
    end
  end
end

