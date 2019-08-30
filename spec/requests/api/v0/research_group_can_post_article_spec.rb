RSpec.describe Api::V0::ArticlesController, type: :request do

  describe 'Research group can post article' do 
    let(:research_group) { create(:user, role: :research_group) }
    let(:credentials) { research_group.create_new_auth_token }
    let(:headers) { {HTTP_ACCEPT: "application/json"}.merge!(credentials) }

    before do
      post '/api/v0/articles' , params: {
          title: 'Test article',
          body: 'Lorum lorum lorum',
          pdf: {
            type: "application/pdf",
            encoder: "name=science_paper.pdf;base64",
            data: 'iVBORw0KGgoAAAANSUhEUgAABjAAAAOmCAYAAABFYNwHAAAgAElEQVR4XuzdB3gU1cLG8Te9EEgISQi9I71KFbBXbFixN6zfvSiIjSuKInoVFOyIDcWuiKiIol4Q6SBVOtI7IYSWBkm',
            extension: "pdf"   
          }
      }, headers: headers
    end

    it 'returns 200 response' do
      expect(response.status).to eq 200
    end

    it 'that has pdf attached' do
      article = Article.find_by(title: response.request.params['title'])
      expect(article.pdf.attached?).to eq true
    end
  end

  describe 'University cannot post article' do 
    let(:university) { create(:user, role: :university) }
    let(:credentials) { university.create_new_auth_token }
    let(:headers) { {HTTP_ACCEPT: "application/json"}.merge!(credentials) }
    
    before do
      post '/api/v0/articles' , params: {
        title: 'Test article',
        body: 'Lorum lorum lorum',
        pdf: {
          type: "application/pdf",
          encoder: "name=science_paper.pdf;base64",
          data: 'iVBORw0KGgoAAAANSUhEUgAABjAAAAOmCAYAAABFYNwHAAAgAElEQVR4XuzdB3gU1cLG8Te9EEgISQi9I71KFbBXbFixN6zfvSiIjSuKInoVFOyIDcWuiKiIol4Q6SBVOtI7IYSWBkm',
          extension: "pdf" 
        } 
      }, headers: headers
    end

    it 'returns 422 response' do
      expect(response.status).to eq 422
    end

  end

end