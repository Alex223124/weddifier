require 'rails_helper'

describe 'PlusOnes controller request', type: :request do
  context 'GET new' do
    context 'When no leader registered beforehand' do
      it_behaves_like 'trying to register a plus one without a leader' do
        let(:action) { get new_guest_plus_one_path(1) }
      end
    end

    context 'When previous leader has registered' do
      before do
        post_valid_guest_with_plus_one_option
        follow_redirect!
      end

      it 'shows a form for registering a guest' do
        expect(response.body).to include('<form')
      end
    end

    context 'When a leader and a plus one have already been registered' do
      it_behaves_like 'trying to register a plus one twice' do
        let(:action) { get new_guest_plus_one_path(1) }
      end
    end
  end

  context 'POST create' do
    context 'When no leader registered beforehand' do
      it_behaves_like 'trying to register a plus one without a leader' do
        let(:action) { post guest_plus_one_index_path(1) }
      end
    end

    context 'When a previous leader has registered' do
      context 'with valid inputs' do
        before do
          leader = post_valid_guest_with_plus_one_option
          post_valid_plus_one(leader)
        end

        it 'has a leader id session set' do
          expect(session[:guest_id]).to eq(Guest.first.id)
        end

        it 'flashes a success message' do
          expect(flash[:success]).to be_present
        end

        it 'redirects to thank you path' do
          expect(response).to redirect_to thank_you_path
        end

        it 'sets the plus one id to the session' do
          expect(session[:plus_one_id]).to eq(Guest.last.id)
        end
      end

      context 'with invalid inputs'
    end

    context 'When a leader and a plus one have already been registered' do
      it_behaves_like 'trying to register a plus one twice' do
        let(:action) { post guest_plus_one_index_path(1) }
      end
    end
  end
end
