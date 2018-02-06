require 'ostruct'

class Email
    def self.send(params)
        puts "Sending the email"
    end
end

class DiscountAPI
    def self.call
        puts "Calling the discount API"
        OpenStruct.new(amount: 10)
    end
end

class User
    attr_reader :status

    def initialize
        @status = 'not_registered'
        @discount = false
    end

    def register
        @status = 'registered'
        #...
        Email.send({subject: 'Some title', body: 'Some body'})
        discount_response = DiscountAPI.call
        if discount_response.amount > 0
            @discount = true
        end
    end
end

RSpec.describe User do
    let(:my_double) { double(call: nil) }

    before do
        allow(Email).to receive(:send).and_return(nil)
        # Double
        allow(DiscountAPI).to receive(:call).and_return(double(amount: 10))
    end

    describe '#register' do 
        it 'does change the status of the user' do
            # expect(subject.status).to eq('not_registered')
            # subject.register
            # expect(subject.status).to eq('registered')

            expect { subject.register }.to change { subject.status }.from('not_registered').to('registered')
        end
    
        it 'sends an email' do
            expect(Email).to receive(:send)
            
            subject.register
        end

        it 'checks for a discount' do
            # Mock
            expect(DiscountAPI).to receive(:call).and_return(double(amount: 10))
            
            subject.register
        end

        it 'calls my double' do
            expect(my_double).to receive(:call)

            subject.register
        end
    end
end