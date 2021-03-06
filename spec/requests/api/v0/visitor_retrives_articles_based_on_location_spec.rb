RSpec.describe 'Visitor can retrieve articles based on location', type: :request do
  let(:research_group) { create(:user) }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }}
  let!(:stockholm_articles) { 5.times { create(:article, author: research_group, city: "Stockholm") }}
  let!(:barcelona_articles) { 5.times { create(:article, author: research_group, city: "Barcelona") }}
  
  describe 'Article based on city matched with user city are returned for user' do
    before do  
      get "/api/v0/articles", params: {city: 'Stockholm'}, headers: headers
    end

    it 'returns a 200 response' do
      expect(response.status).to eq 200
    end
    
    it 'returns 5 articles from Stockholm' do
      expect(response_json.size).to eq 5
    end
  end
end