describe Rsbe::Client::Se do
  def chk_header(valid_params,incoming_response)
    exist = []
    allowed_param = {:scope => "ses"}
    incoming_response.each_key { |k|
      s = k.to_sym
      if valid_params.key?(s) and valid_params[s] == incoming_response[k]
        exist << true
      elsif allowed_param.key?(s) and allowed_param[s] == incoming_response[k]
        exist << true
      else
        exist << false
      end
    }
    exist
  end
  describe ".new" do
    context "with valid attributes and symbol keys" do
      subject { Rsbe::Client::Se.new(coll_id: 'ea85c776-a79b-4603-b307-d6760a400281', digi_id: 'boo', do_type: 'audio', phase: 'digitization', step: 'qc', status: 'pause', label:'why label anything?', notes: 'notes') }
      it { should be_a(Rsbe::Client::Se) }
      its(:coll_id) { should eq 'ea85c776-a79b-4603-b307-d6760a400281' }
      its(:digi_id) { should eq 'boo' }
      its(:do_type) { should eq 'audio' }
      its(:phase)   { should eq 'digitization' }
      its(:step)    { should eq 'qc' }
      its(:status)  { should eq 'pause' }
      its(:label)   { should eq 'why label anything?' }
      its(:notes)   { should eq 'notes' }
    end
    context "with incorrect argument type" do
      subject { Rsbe::Client::Se.new(24) }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  describe ".base_path" do
    subject { Rsbe::Client::Se }
    its(:base_path) { should eq '/api/v0/ses' }
  end

  describe ".all" do
    subject { Rsbe::Client::Se.all }
    it 'should raise a MethodNotImplementedError' do
      expect { subject }.to raise_error Rsbe::Client::MethodNotImplementedError
    end
  end

  describe ".search" do
    describe "with valid params" do
      context "with an existing se", vcr: {cassette_name: 'se/search-with-existing-se'} do
        let(:valid_params) { {coll_id: 'ea85c776-a79b-4603-b307-d6760a400281', digi_id: 'AD-MT-0123'} }
        let(:response) { Rsbe::Client::Se.search(valid_params) }
        let(:header) { JSON.parse(response.body)['responseHeader'] }
        let(:results)  { JSON.parse(response.body)['response'] }
        it "should have a response status of 200" do
          expect(response.status).to eq(200)
        end
        it "should have a numFound of 1" do
          expect(results['numFound']).to eq(1)
        end
        it "docs array size should be 1" do
          expect(results['docs'].size).to eq(1)
        end
        it "should have a url of a certain value" do
          expect(results['docs'][0]['url']).to eq("http://localhost:3000/api/v0/ses/07998216-af0a-4262-b7f9-6a7d9c4aeae4")
        end
        it "should respond with a valid params in the responseHeader" do
          valid_header_params = chk_header(valid_params,header["params"])
          expect(valid_header_params).not_to include(false)
        end
      end
      context "with valid params but malformed uuid", vcr: {cassette_name: 'se/search-malformed-uuid'} do
        let(:bad_uuid) { {coll_id: 'ea85c0a400281', digi_id: 'AD-MT-0123'} }
        let(:response) { Rsbe::Client::Se.search(bad_uuid) }
        let(:message) { JSON.parse(response.body) }
        it "should have a response status of 400" do
          expect(response.status).to eq(400)
        end
        it "should have a hash with a key called errors" do
          expect(message.key?("errors")).to be true
        end
        it "should have an error message" do
          expect(message["errors"][0]).to eql("ERROR: coll_id value: ea85c0a400281 needs to be a valid UUID")
        end
      end
      context "with a non-existent se", vcr: {cassette_name: 'se/search-with-missing-se'} do
        let(:no_se) { {coll_id: 'ea85c776-a79b-4603-b307-d6760a400281', digi_id: 'iamnothere'} }
        let(:response) { Rsbe::Client::Se.search(no_se) }
        let(:results)  { JSON.parse(response.body)['response'] }
        it "should have a response status of 200" do
          status = response.status
          expect(status).to eq(200)
        end
        it "should have a numFound of 0" do
          expect(results['numFound']).to eq(0)
        end
        it "docs array size should be 0" do
          expect(results['docs'].size).to eq(0)
        end
      end

    end
    context "with invalid params" do
      it "raises an error if no params are sent" do
        expect { Rsbe::Client::Se.search }.to raise_error(ArgumentError)
      end
      it "raises an error if a param key is a string" do
        invalid_params = {'coll_id' => 'ea85c776-a79b-4603-b307-d6760a400281', 'digi_id' => 'AD-MT-0123'}
        expect { Rsbe::Client::Se.search(invalid_params) }.to raise_error(ArgumentError)
      end
    end
  end
  describe ".find" do
    context "with id of existing Se", vcr: {cassette_name: 'se/find-existing'} do
      subject { Rsbe::Client::Se.find('acf51ef2-8bf3-4f05-9042-0bfcb6860560') }
      its(:class) { should eq Rsbe::Client::Se }
      its(:id)    { should eq 'acf51ef2-8bf3-4f05-9042-0bfcb6860560' }
      its(:digi_id)  { should eq 'foo_quux_cuid01234' }
    end

    context "with non-existent id", vcr: {cassette_name: 'se/find-non_existent'} do
      subject { Rsbe::Client::Se.find('443d3d42-1084-4045-b618-f4358d6e8b12') }
      it 'should raise an Rsbe::Client::RecordNotFound' do
        expect { subject }.to raise_error Rsbe::Client::RecordNotFound
      end
    end
  end

  describe "#save" do
    context "when creating a new Se" do
      context "with valid attributes" do
        # TODO: implment FactoryGirl
        context "and no id", vcr: {cassette_name: 'se/save-create-unknown-id'} do
          let(:coll_id) { "ea85c776-a79b-4603-b307-d6760a400281" }
          let(:digi_id) { 'posso_dormire' }
          let(:do_type) { 'map' }
          let(:phase)   { 'upload' }
          let(:step)    { 'packaging' }
          let(:status)  { 'done' }
          let(:label)   { 'labels' }
          let(:notes)   { 'lorem ipsum dolor' }
          let(:se) { Rsbe::Client::Se.new(coll_id: coll_id,
                                          digi_id:  digi_id,
                                          do_type: do_type,
                                          phase:  phase,
                                          step: step,
                                          status: status,
                                          label: label,
                                          notes: notes) }
          subject { se }
          its(:save) { should eq true }

          context "after save" do
            before { se.save }
            its(:id)      { should_not be_nil }
            its(:coll_id) { should eq 'ea85c776-a79b-4603-b307-d6760a400281' }
            its(:digi_id) { should eq digi_id }
            its(:do_type) { should eq do_type }
            its(:phase)   { should eq phase   }
            its(:step)    { should eq step    }
            its(:status)  { should eq status  }
            its(:label)   { should eq label   }
            its(:notes)   { should eq notes   }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end

        context "and a known id", vcr: {cassette_name: 'se/save-create-known-id'} do
          let(:se) do
            Rsbe::Client::Se.new(id: 'd72359c1-ecfd-4dbf-843c-bf1ec5f4f454',
                                 coll_id: 'ea85c776-a79b-4603-b307-d6760a400281',
                                 digi_id: 'AA-MX-0143',
                                 do_type: 'map',
                                 phase: 'upload',
                                 step: 'upload',
                                 status: 'done',
                                 label: 'label',
                                 notes: 'notes')
          end
          subject { se }
          its(:save) { should eq true }

          context "after save" do
            before { se.save }
            its(:id)      { should eq 'd72359c1-ecfd-4dbf-843c-bf1ec5f4f454' }
            its(:coll_id) { should eq 'ea85c776-a79b-4603-b307-d6760a400281' }
            its(:digi_id) { should eq 'AA-MX-0143' }
            its(:do_type) { should eq 'map'      }
            its(:phase)   { should eq 'upload'   }
            its(:step)    { should eq 'upload'   }
            its(:status)  { should eq 'done'     }
            its(:label)   { should eq 'label'    }
            its(:notes)   { should eq 'notes'    }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end
      end
      context "with invalid attributes", vcr: {cassette_name: 'se/save-invalid'} do
        let(:se) do
          Rsbe::Client::Se.new(coll_id: 'ea85c776-a79b-4603-b307-d6760a400281',
                                       phase:  'new moon')
        end
        subject { se }
        its(:save) { should eq false }
      end
    end

    context "when updating a Se" do
      context "with valid attributes", vcr: {cassette_name: 'se/save-update-valid'} do
        let(:se) { Rsbe::Client::Se.find('acf51ef2-8bf3-4f05-9042-0bfcb6860560') }
        subject { se }
        context "before save-as-update" do
          its(:id)         { should eq 'acf51ef2-8bf3-4f05-9042-0bfcb6860560' }
          its(:phase)      { should eq 'digitization'  }
          its(:step)       { should eq 'qc' }
          its(:created_at) { should_not be_nil }
          its(:updated_at) { should_not be_nil }
        end
        context "on save-as-update" do
          before do
            se.phase = 'upload'
            se.step = 'packaging'
          end
          its(:save) { should eq true }
          context "after save" do
            its(:id)         { should eq 'acf51ef2-8bf3-4f05-9042-0bfcb6860560' }
            its(:phase)      { should eq 'upload'  }
            its(:step)       { should eq 'packaging' }
            its(:created_at) { should_not be_nil }
            its(:updated_at) { should_not be_nil }
          end
        end
      end
    end
  end
  describe "lazy evaluation" do
    context "when Se exists, but is populated with minimal attributes", vcr: {cassette_name: 'se/lazy-eval-exists'} do
      let(:se) { Rsbe::Client::Se.new(id: 'c415b683-0823-4da0-b108-d729957705c5') }
      it "should return values for all attributes" do
        expect(se.coll_id).to eq 'ea85c776-a79b-4603-b307-d6760a400281'
        expect(se.digi_id).to eq 'chk_this_out'
        expect(se.do_type).to eq 'map'
        expect(se.phase).to eq 'upload'
        expect(se.step).to eq 'upload'
        expect(se.status).to eq 'done'
        expect(se.lock_version).not_to be_nil
        expect(se.created_at).not_to be_nil
        expect(se.updated_at).not_to be_nil
      end
    end
    context "when Se does not exist in RSBE and does not have an id" do
      let(:se) { Rsbe::Client::Se.new }
      it "should return nil for all attributes" do
        expect(se.id).to be_nil
        expect(se.coll_id).to be_nil
        expect(se.digi_id).to be_nil
        expect(se.do_type).to be_nil
        expect(se.phase).to be_nil
        expect(se.step).to be_nil
        expect(se.status).to be_nil
        expect(se.label).to be_nil
        expect(se.notes).to be_nil
        expect(se.lock_version).to be_nil
        expect(se.created_at).to be_nil
        expect(se.updated_at).to be_nil
      end
    end
  end
end
