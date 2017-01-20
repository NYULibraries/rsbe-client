describe Rsbe::Client do
  PARTNER_URL    = 'http://localhost:3000/api/v0/partners/977e659b-886a-4626-8799-8979426ad2b3'
  COLLECTION_URL = 'http://localhost:3000/api/v0/colls/ea85c776-a79b-4603-b307-d6760a400281'
  PROVIDER_URL   = 'http://localhost:3000/api/v0/providers/51213be7-c8de-4e06-8cc2-06bfc82cdd68'
  SE_URL         = 'http://localhost:3000/api/v0/ses/acf51ef2-8bf3-4f05-9042-0bfCB6860560'
  NO_OBJECT_URL  = 'http://localhost:3000/api/v0/fluffy_bunnies/4bf6daf0-e065-46e2-af30-3f74b1f7478e' # does not exist

  describe '.find' do
    context 'when object exists' do
      context 'and URL points to a Partner', vcr: { cassette_name: 'client/find_partner' }  do
        subject { Rsbe::Client.find(PARTNER_URL) }
        it { should be_a(Rsbe::Client::Partner) }
        its(:id) { should == '977e659b-886a-4626-8799-8979426ad2b3' }
        its(:code) { should == 'foo' }
      end

      context 'and URL points to a Collection', vcr: { cassette_name: 'client/find_collection' } do
        subject { Rsbe::Client.find(COLLECTION_URL) }
        it { should be_a(Rsbe::Client::Collection) }
        its(:id) { should == 'ea85c776-a79b-4603-b307-d6760a400281' }
        its(:code) { should == 'quux' }
      end

      context 'and URL points to a Provider', vcr: { cassette_name: 'client/find_provider' } do
        subject { Rsbe::Client.find(PROVIDER_URL) }
        it { should be_a(Rsbe::Client::Provider) }
        its(:id) { should == '51213be7-c8de-4e06-8cc2-06bfc82cdd68' }
        its(:name) { should == 'Calpurnia' }
      end

      context 'and URL points to an Se', vcr: { cassette_name: 'client/find_se' } do
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

