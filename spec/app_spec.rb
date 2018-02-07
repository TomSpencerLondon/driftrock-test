require_relative '../lib/app'

describe App do

  subject(:app) { described_class.new }

  users_json = File.read("./spec/users.json")
  purchases_json = File.read("./spec/purchases.json")
  
  describe 'find_email' do
    it 'finds an email from a requested id' do
      allow(HTTParty).to receive(:get)
        .with("https://driftrock-dev-test-2.herokuapp.com/users",  {:query=>{:page=>1, :per_page=>2000}})
        .and_return(double(body: users_json))
      expect(app.find_email("S27G-8UMJ-LDSL-UOPN")).to eq ("terry_henry@doyle.io")
    end
  end 

  describe 'find_id' do 
    it 'finds an id from a requested email' do 
      allow(HTTParty).to receive(:get)
        .with("https://driftrock-dev-test-2.herokuapp.com/users",  {:query=>{:page=>1, :per_page=>2000}})
        .and_return(double(body: users_json))
      expect(app.find_id("jack_lakin@rodriguezschuppe.io")).to eq("ZZLB-4HCN-OA3N-LGWB")
    end 
  end 

  describe 'most_sold' do 
    it 'finds the item that has been sold the most' do 
      allow(HTTParty).to receive(:get)
        .with("https://driftrock-dev-test-2.herokuapp.com/purchases",  {:query=>{:page=>1, :per_page=>2000}})
        .and_return(double(body: purchases_json))
      array = JSON.parse(purchases_json)['data']
      output = Hash.new(0)
      array.each do |hash|
        output[hash['item']] += 1 
      end 
      allow(app).to receive(:total_sales_of_each_product).and_return(output)
      expect(app.most_sold).to eq("Enormous Linen Plate")
    end 
  end 

  describe 'most_loyal' do 
    it 'finds the most loyal customer' do 
      allow(HTTParty).to receive(:get)
        .with("https://driftrock-dev-test-2.herokuapp.com/purchases",  {:query=>{:page=>1, :per_page=>2000}})
        .and_return(double(body: purchases_json))
      allow(HTTParty).to receive(:get)
        .with("https://driftrock-dev-test-2.herokuapp.com/users",  {:query=>{:page=>1, :per_page=>2000}})
        .and_return(double(body: users_json))
      expect(app.most_loyal).to eq("bogisich_judah@hilperttromp.biz")
    end 
  end 

end 

