require 'rails_helper'

RSpec.describe JwtDenylist, type: :model do
  describe 'inheritance' do
    it 'includes Devise JWT Revocation Strategies Denylist' do
      expect(described_class.ancestors).to include(Devise::JWT::RevocationStrategies::Denylist)
    end
  end

  describe 'table configuration' do
    it 'uses jwt_denylist table name' do
      expect(described_class.table_name).to eq('jwt_denylist')
    end
  end
end