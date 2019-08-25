require 'stripe_mock'

RSpec.describe Api::V0::SubscriptionsController, type: :request do
  let(:stripe_helper) { StripeMock.create_test_helper }

  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }
  let(:university) { create(:user, role: :university) }
  let(:credentials) { university.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'Payment posts successfully (Happy Path)' do
    
    before do
      post '/api/v0/subscriptions',
          headers: headers,
          params: { stripeToken: StripeMock.generate_card_token }
    end

    it 'return a 200 status' do
      expect(response.status).to eq 200
    end

    it 'returns a success message' do
      expect(response_json['message']).to eq 'Payment successful'
    end
  end

  describe 'payment is declined' do
    describe 'when payment request has no stripe token' do
      before do
        post '/api/v0/subscriptions',
          params: { stripeToken: nil },
          headers: headers
      end

      it 'returns 402' do
        expect(response.status).to eq 402
      end

      it 'returns stripe error message' do
        expect(response_json['errors']).to eq 'No stripe token detected'
      end
    end

    describe 'when payment request has invalid stripe token' do
      before do
        post '/api/v0/subscriptions',
          params: { stripeToken: 'invalid_token' },
          headers: headers
      end
  
      it 'returns 402' do
        expect(response.status).to eq 402
      end
  
      it 'returns stripe error message' do
        expect(response_json['errors']).to eq 'Invalid token id: id'
      end
    end
  end
end