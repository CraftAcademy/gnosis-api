RSpec.describe 'Visitor can retrieve articles based on location', type: :request do
  let(:user) { create(:user, role: :reader) }
  #  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }}

  describe 'registration keys are returned for subscribed user' do
    before do
      5.times { Article.create(user: reader, city: Stockholm) }
      5.times { Article.create(user: reader, city: Barcelona) }
      get "/api/v0/articles/#{city}", headers: headers
    end

    it 'returns a 200 response' do
      expect(response.status).to eq 200
    end
    
    it 'returns 5 articles from Stockholm' do
      expect(response_json.count).to eq 5
    end
  end
end