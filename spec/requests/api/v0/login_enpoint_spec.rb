# frozen_string_literal: true

RSpec.describe 'User Session', type: :request do
  let(:header) { { HTTP_ACCEPT: 'application/json' } }
  let!(:user) { create(:user, email: 'reader1@mail.com', password: 'password') }

  describe 'POST /api/v0/auth/sign_in' do
    context 'with valid credentials' do
      before do
        post '/api/v0/auth/sign_in', params: { email: 'reader1@mail.com',
                                               password: 'password' },
                                     headers: headers
      end

      it 'returns a 200 response' do
        expect(response.status).to eq 200
      end

      it 'returns user email' do
        expect(response_json['data']['email']).to eq 'reader1@mail.com'
      end
    end

    context 'with invalid credentials' do
      before do
        post '/api/v0/auth/sign_in', params: { email: 'reader1@mail.com',
                                               password: 'wrong_password' },
                                     headers: headers
      end

      it 'returns a 401 response' do
        expect(response.status).to eq 401
      end

      it 'returns success == false' do
        expect(response_json['success']).to eq false
      end

      it 'returns error messages' do 
        expect(response_json['errors']).to include "Invalid login credentials. Please try again."
      end
    end
  end
end
