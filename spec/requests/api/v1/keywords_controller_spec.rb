# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::KeywordsController, type: :request do
  include ActiveJob::TestHelper

  describe 'GET#index' do
    context 'given a logged in user' do
      context 'given the user has keywords' do
        it 'returns success status' do
          user = Fabricate(:user)
          Fabricate.times(3, :keyword, user: user)

          get api_v1_keywords_path, headers: create_token_header(user)

          expect(response).to have_http_status(:success)
        end

        it 'returns three items' do
          user = Fabricate(:user)
          Fabricate.times(3, :keyword, user: user)

          get api_v1_keywords_path, headers: create_token_header(user)

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:data].count).to eq 3
        end

        it 'returns metadata with page = 1, per_page = 2 and total_items = 3' do
          user = Fabricate(:user)
          Fabricate.times(3, :keyword, user: user)
          get api_v1_keywords_path, params: { page: 1, per_page: 2 }, headers: create_token_header(user)
          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body[:meta]).to eq(page: 1, per_page: 2, total_items: 3)
        end
      end

      context 'given the user has no keyword' do
        it 'returns success status' do
          Fabricate(:keyword)

          get api_v1_keywords_path, headers: create_token_header

          expect(response).to have_http_status(:success)
        end

        it 'returns an empty array' do
          Fabricate(:keyword)

          get api_v1_keywords_path, headers: create_token_header

          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:data].count).to eq 0
        end

        it 'returns metadata with page = 1, per_page = 2 and total_items = 0' do
          Fabricate(:keyword)
          get api_v1_keywords_path, params: { page: 1, per_page: 2 }, headers: create_token_header
          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body[:meta]).to eq(page: 1, per_page: 2, total_items: 0)
        end
      end
    end

    context 'given a non-logged in user' do
      it 'returns an unauthorized error' do
        get api_v1_keywords_path

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST#index' do
    context 'when CSV file is valid' do
      it 'returns success status' do
        params = { 'file' => fixture_file_upload('csv/valid.csv') }
        post api_v1_keywords_path, params: params, headers: create_token_header

        expect(response).to have_http_status(:success)
      end

      it 'saves 10 keywords to the DB' do
        params = { 'file' => fixture_file_upload('csv/valid.csv') }
        post api_v1_keywords_path, params: params, headers: create_token_header

        expect { post api_v1_keywords_path, params: params, headers: create_token_header }.to change(Keyword, :count).by(10)
      end

      it 'returns the upload_success meta message' do
        params = { 'file' => fixture_file_upload('csv/valid.csv') }
        post api_v1_keywords_path, params: params, headers: create_token_header

        expect(JSON.parse(response.body)['meta']).to eq(I18n.t('csv.upload_success'))
      end

      context 'when Google search is successfully fetched' do
        it 'saves keyword "Apple" with top ads count as 3' do
          stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
          params = { 'file' => fixture_file_upload('csv/valid.csv') }
          perform_enqueued_jobs do
            post api_v1_keywords_path, params: params, headers: create_token_header
          end

          expect(Keyword.where(name: 'Apple').first[:ads_top_count]).to eq(3)
        end
      end

      context 'when Google search returns too many attemps status 422' do
        it 'does not saves information for "Apple"' do
          stub_request(:get, %r{google.com/search}).to_return(status: 422)
          params = { 'file' => fixture_file_upload('csv/valid.csv') }
          perform_enqueued_jobs do
            post api_v1_keywords_path, params: params, headers: create_token_header
          end

          expect(Keyword.where(name: 'Apple').first[:ads_top_count]).to eq(0)
        end
      end
    end

    context 'when CSV file is missing' do
      it 'returns unprocessable_entity status' do
        post api_v1_keywords_path, headers: create_token_header

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a invalid_file error' do
        post api_v1_keywords_path, headers: create_token_header

        expect(JSON.parse(response.body)['errors']['code']).to eq('invalid_file')
      end
    end

    context 'when CSV file is in the wrong type' do
      it 'returns unprocessable_entity status' do
        params = { 'file' => fixture_file_upload('csv/wrong_type.txt') }
        post api_v1_keywords_path, params: params, headers: create_token_header

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the wrong_type error' do
        params = { 'file' => fixture_file_upload('csv/wrong_type.txt') }
        post api_v1_keywords_path, params: params, headers: create_token_header

        expect(JSON.parse(response.body)['errors']['details']).to include(I18n.t('csv.validation.wrong_type'))
      end
    end

    context 'when user is not signed in' do
      it 'returns unauthorized status' do
        params = { 'file' => fixture_file_upload('csv/valid.csv') }
        post api_v1_keywords_path, params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
