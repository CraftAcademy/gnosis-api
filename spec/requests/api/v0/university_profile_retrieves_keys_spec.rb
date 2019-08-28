RSpec.describe 'University Profile retrieves registration keys', type: :request do
  let(:university) { create(:user, role: :university, subscriber: true) }
  let(:credentials) { university.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'registration keys are returned for subscribed user' do
    before do
      5.times { RegistrationKey.create(user: university) }
      get "/api/v0/users/#{university.id}", headers: headers
    end

    it 'returns a 200 response' do
      expect(response.status).to eq 200
    end
    
    it 'returns 5 registration keys' do
      expect(response_json.count).to eq 5
    end
  end
end
