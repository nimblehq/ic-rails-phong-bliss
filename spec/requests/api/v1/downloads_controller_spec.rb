# frzone_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DownloadsController, type: :request do
  include ActiveJob::TestHelper

  describe 'GET#index' do
    context 'when a guest try to download the pdf' do
      it 'returns unauthorized' do
        get api_v1_downloads_path

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'given a logged in user' do
      context 'given a user has keywords' do
        it 'returns success' do
          user = Fabricate(:user)
          html = '<h1>Hello There!</h1>'
          keyword = Fabricate(:keyword, html: html, user: user)

          get api_v1_downloads_path, params: { keyword_id: keyword.id }, headers: create_token_header(user)

          expect(response).to have_http_status(:success)
        end

        it 'returns an attachement with content-type is application/pdf and filename is vpn.pdf' do
          user = Fabricate(:user)
          html = '<h1>Hello There!</h1>'
          keyword = Fabricate(:keyword, name: 'vpn', html: html, user: user)

          get api_v1_downloads_path, params: { keyword_id: keyword.id }, headers: create_token_header(user)
          response_headers = response.headers
          expect(response_headers['content-type']).to eq('application/pdf')
          expect(response_headers['content-disposition']).to eq("attachment; filename=\"vpn.pdf\"; filename*=UTF-8''vpn.pdf")
        end
      end

      context 'given a user does not have keywords' do
        it 'returns not found' do
          user = Fabricate(:user)
          html = '<h1>Hello There!</h1>'
          keyword = Fabricate(:keyword, html: html, user: user)

          get api_v1_downloads_path, params: { keyword_id: keyword.id }, headers: create_token_header

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
