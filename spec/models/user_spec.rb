RSpec.describe User, type: :model do
  it 'should have valid Factory' do
    expect(create(:user)).to be_valid
  end

  describe 'Database table' do
    it { is_expected.to have_db_column :id }
    it { is_expected.to have_db_column :provider }
    it { is_expected.to have_db_column :uid }
    it { is_expected.to have_db_column :encrypted_password }
    it { is_expected.to have_db_column :reset_password_token }
    it { is_expected.to have_db_column :reset_password_sent_at }
    it { is_expected.to have_db_column :remember_created_at }
    it { is_expected.to have_db_column :sign_in_count }
    it { is_expected.to have_db_column :current_sign_in_at }
    it { is_expected.to have_db_column :last_sign_in_at }
    it { is_expected.to have_db_column :current_sign_in_ip }
    it { is_expected.to have_db_column :last_sign_in_ip }
    it { is_expected.to have_db_column :confirmation_token }
    it { is_expected.to have_db_column :confirmed_at }
    it { is_expected.to have_db_column :confirmation_sent_at }
    it { is_expected.to have_db_column :unconfirmed_email }
    it { is_expected.to have_db_column :nickname }
    it { is_expected.to have_db_column :image }
    it { is_expected.to have_db_column :email }
    it { is_expected.to have_db_column :tokens }
    it { is_expected.to have_db_column :created_at }
    it { is_expected.to have_db_column :updated_at }
  end

  describe 'Association' do
    it { is_expected.to have_many :registration_keys }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_confirmation_of(:password) }

    context 'should not have an invalid email address' do
      emails = [
        'asdf@ ds.com',
        '@example.com',
        'test me @yahoo.com',
        'asdf@example',
        'ddd@.d. .d',
        'ddd@.d'
      ]

      emails.each do |email|
        it { is_expected.not_to allow_value(email).for(:email) }
      end
    end

    context 'should have a valid email address' do
      emails = %w[
        asdf@ds.com
        hello@example.uk
        test1234@yahoo.si
        asdf@example.eu
      ]

      emails.each do |email|
        it { is_expected.to allow_value(email).for(:email) }
      end
    end

    describe 'User can have a University Role' do
      let(:user) { create :user, email: 'harvard@harvard.edu', role: :university }

      it '#University? responds true if user role is university' do
        expect(user.university?).to be true
      end
    end

    describe 'User can have a Research Group Role' do
      let(:user) do
        create :user, email: 'climate_research@harvard.edu', role: :research_group
      end

      it '#Research_group? responds true if user role is reseach_group' do
        expect(user.research_group?).to be true
      end
    end

    describe 'Default User role is Reader' do
      let(:user) { create :user, email: 'reader1@mail.com' }

      it '#Reader? responds true if newly created user has a default role of reader' do
        expect(user.reader?).to be true
      end
    end

    describe 'User can be a subscriber' do
      let(:user) { create :user, email: 'reader1@mail.com', subscriber: true }

      it '#subscriber? responds true if user is subscribed' do
        expect(user.subscriber?).to be true
      end
    end

    describe 'Default User subscriber status is false' do
      let(:user) { create :user, email: 'reader2@mail.com' }

      it '#Subscriber? responds false if newly created user has a default subscriber status of false' do
        expect(user.subscriber?).to be false
      end
    end
  end
end
