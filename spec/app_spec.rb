require_relative '../app'

describe App do
  subject(:app) { described_class.new }
  users_json = JSON.parse(File.read("./spec/users.json"))
  purchases_json = JSON.parse(File.read("./spec/purchases.json"))
  
  let(:api_request) { double :api_request, users: users_json, purchases: purchases_json }

    describe 'find_email' do
        it 'finds an email from a requested id' do
            allow(api_request).to receive(:api_request_enumerator).and_return(users_json)
            expect(app.find_email("S27G-8UMJ-LDSL-UOPN")).to eq ("terry_henry@doyle.io")
        end
    end 
end 

