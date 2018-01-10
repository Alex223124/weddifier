require 'rails_helper'
require 'sucker_punch/testing/inline'

describe 'Admin::Admins controller request', type: :request do
  context 'when admin is not logged in' do
    context 'GET index' do
      it_behaves_like 'a logged out admin' do
        let(:action) { get admin_path }
      end
    end

    context 'GET search' do
      it_behaves_like 'a logged out admin' do
        let(:action) { get admin_search_path }
      end
    end
  end

  context 'when admin is logged in' do
    before { admin_login }

    context 'GET index' do
      it 'shows all guests' do
        guest1 = Fabricate(:guest)
        guest2 = Fabricate(:guest)
        get admin_path
        expect(response.body).to include(guest1.first_name)
        expect(response.body).to include(guest2.first_name)
      end
    end

    context 'GET search' do
      let!(:gracie) { Fabricate(:guest, first_name: 'Gracie') }
      let!(:john) { Fabricate(:guest, first_name: 'John') }

      it 'displays search results' do
        get admin_path
        expect(response.body).to include(gracie.first_name)
        expect(response.body).to include(john.first_name)

        get admin_search_path(search: 'gracie')
        expect(response.body).to include(gracie.first_name)
        expect(response.body).not_to include(john.first_name)
      end
    end
  end
end
