RSpec.describe Api::V0::ArticlesController, type: :request do
  let(:headers) { {HTTP_ACCEPT: "application/json"} }
  let(:research_group) { create(:user, role: :research_group) }

  describe 'GET /api/v0/articles' do
    before do
      5.times { create(:article, author: research_group) }
      get '/api/v0/articles', headers: headers
    end

    it 'returns collection of articles' do    
      expect(response_json.count). to eq 5
    end

    it 'returns 200 response' do
      expect(response.status).to eq 200
    end
    
  end
  
end
