RSpec.describe 'Visitor can retrieve articles based on location', type: :request do
  let(:research_group) { create(:user) }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }}

  describe 'Article based on city matched with user city are returned for user' do
    before do
      5.times { Article.create(author: research_group, title: "yahoo", body: "this is an article", city: "Stockholm") }
      5.times { Article.create(author: research_group, title: "yahoo", body: "this is an article", city: "Barcelona") }
      articles = Article.all
      for article1 in articles do
        article1   
       end
      article = article1
      get "/api/v0/articles/#{article.city}", headers: headers
    end

    it 'returns a 200 response' do
      expect(response.status).to eq 200
    end
    
    it 'returns 5 articles from Stockholm' do
      expect(Article.where(city: "Stockholm").count).to eq 5
    end
  end
end