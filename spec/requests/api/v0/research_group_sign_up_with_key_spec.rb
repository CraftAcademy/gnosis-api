RSpec.describe 'Registration', type: :request do
  let(:headers) { { HTTP_ACCEPT: 'application/json' } }
  let(:university) { create(:user, role: 'university') }
  let(:reg_key) { university.registration_keys.create }

  describe 'of User with Research Group role with valid Registration Key' do
    before 'post new User info' do
      post '/api/v0/auth', params: { email: 'example@craftacademy.se',
                                    name: 'Research Group Alpha',
                                    role: 'research_group',
                                    password: 'password',
                                    password_confirmation: 'password',
                                    registration_key: reg_key.combination },
                                    headers: headers
    end

    it 'returns a 200 response if post request was successful' do
      expect(response.status).to eq 200
      binding.pry
    end

    it 'verifies that User with Research Group role is created' do
      expect(response_json["data"]["name"]).to eq 'Research Group Alpha'
    end

    it 'verifes that Research group are associated with the University thats created the reg-key' do
      expect(response_json["data"]["university_id"]).to eq reg_key.user_id
    end

    it 'it does not create registration key for research group user' do
      expect(response_json["data"]["registration_keys"].count).to eq 0
    end
    
  end

  describe 'of User with Research Group role without Registration Key' do
    before 'post new User info' do
      post '/api/v0/auth', params: { email: 'maria@craftacademy.se',
                                     name: 'Fat Jesus',
                                     role: 'research_group',
                                     password: 'password',
                                     password_confirmation: 'password',
                                     registration_key: nil },
                                     headers: headers
    end

    it 'returns a 422 response' do
      expect(response.status).to eq 422
    end

    it 'returns error message' do
      expect(response_json["errors"]).to eq 'Registration key is required for Sign up'
    end

    it 'checks for research group saved in db, but fails' do
      expect(User.find_by(email: 'maria@craftacademy.se')).to eq nil
    end

  end

  describe 'of User with Research Group role incorrect Registration Key' do
    before 'post new User info' do
      post '/api/v0/auth', params: { email: 'sam@craftacademy.se',
                                     name: 'Fat Jesus',
                                     role: 'research_group',
                                     password: 'password',
                                     password_confirmation: 'password',
                                     registration_key: 'o7A8pJcuvzhv7fih9Paerror' },
                                     headers: headers
    end

    it 'returns a 422 response' do
      expect(response.status).to eq 422
    end

    it 'returns error message' do
      expect(response_json["errors"]).to eq 'Invalid registration key'
    end

    it 'checks for research group saved in db, but fails' do
      expect(User.find_by(email: 'sam@craftacademy.se')).to eq nil
    end

  end

  describe 'of User with University role trying to use Registration Key' do
    before 'post new User info' do
      post '/api/v0/auth', params: { email: 'tate@craftacademy.se',
                                     name: 'Fat Jesus',
                                     role: 'university',
                                     password: 'password',
                                     password_confirmation: 'password',
                                     registration_key: reg_key.combination },
                                     headers: headers
    end

    it '(hack) tries to associate new User with university role with the University thats created, but fails' do
      expect(User.find_by(email: 'tate@craftacademy.se').university_id).to eq nil
    end

  end

end