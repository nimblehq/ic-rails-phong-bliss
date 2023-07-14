# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::KeywordsController, type: :request do
  include ActiveJob::TestHelper

  describe 'GET#index' do
    context 'given a logged in user' do
      context 'given the user retrives all of their keywords' do
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

      context 'given the user search for a specific keyword in adwords urls' do
        context 'given the user has keywords' do
          it 'returns success status' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
            Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

            params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
            get api_v1_keywords_path, params: params, headers: create_token_header(user)

            expect(response).to have_http_status(:success)
          end

          context 'given there are adword urls contain the keyword VPN' do
            it 'returns 2 keywords contains the matched urls' do
              user = Fabricate(:user)
              ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
              Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

              params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
              get api_v1_keywords_path, params: params, headers: create_token_header(user)

              response_body = JSON.parse(response.body, symbolize_names: true)
              expect(response_body[:data][0][:attributes][:matching_adword_urls]).to eq(['https://www.thetopvpn.com', 'https://www.nordvpn.com'])
            end

            it 'returns metadata with page = 1, per_page = 1 and total_item = 1' do
              user = Fabricate(:user)
              ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
              Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

              params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
              get api_v1_keywords_path, params: params, headers: create_token_header(user)

              response_body = JSON.parse(response.body, symbolize_names: true)

              expect(response_body[:meta]).to eq(page: 1, per_page: 1, total_items: 1)
            end
          end

          context 'given there is no adword url contains the keyword VPN' do
            it 'returns an empty array' do
              user = Fabricate(:user)
              ads_top_urls = ['https://www.google.com', 'https://www.bing.com', 'https://www.vnexpress.net']
              Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

              params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
              get api_v1_keywords_path, params: params, headers: create_token_header(user)

              response_body = JSON.parse(response.body, symbolize_names: true)
              expect(response_body[:data]).to be_empty
            end

            it 'returns metadata with page = 1, per_page = 1 and total_items = 0' do
              user = Fabricate(:user)
              ads_top_urls = ['https://www.google.com', 'https://www.bing.com', 'https://www.vnexpress.net']
              Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

              params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
              get api_v1_keywords_path, params: params, headers: create_token_header(user)

              response_body = JSON.parse(response.body, symbolize_names: true)

              expect(response_body[:meta]).to eq(page: 1, per_page: 1, total_items: 0)
            end
          end
        end

        context 'given the user does not have any keyword' do
          it 'returns an empty array' do
            user = Fabricate(:user)
            Fabricate(:keyword)
            params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }

            get api_v1_keywords_path, params: params, headers: create_token_header(user)
            response_body = JSON.parse(response.body, symbolize_names: true)

            expect(response_body[:data]).to be_empty
          end

          it 'returns metadata with page = 1, per_page = 2 and total_items = 0' do
            Fabricate(:keyword)
            get api_v1_keywords_path,
                params: { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 2 },
                headers: create_token_header
            response_body = JSON.parse(response.body, symbolize_names: true)

            expect(response_body[:meta]).to eq(page: 1, per_page: 2, total_items: 0)
          end
        end
      end
    end

    context 'given no token headers' do
      it 'returns an unauthorized error' do
        get api_v1_keywords_path

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST#index' do
    context 'when search engine is Google' do
      context 'when CSV file is valid' do
        it 'returns success status' do
          params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'google' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect(response).to have_http_status(:success)
        end

        it 'saves 11 keywords to the DB' do
          params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'google' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect { post api_v1_keywords_path, params: params, headers: create_token_header }.to change(Keyword, :count).by(11)
        end

        it 'returns the upload_success meta message' do
          params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'google' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect(JSON.parse(response.body)['meta']).to eq(I18n.t('csv.upload_success'))
        end

        context 'when Google search is successfully fetched' do
          it 'saves keyword "Apple" with top ads count as 3' do
            stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
            params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'google' }
            perform_enqueued_jobs do
              post api_v1_keywords_path, params: params, headers: create_token_header
            end

            expect(Keyword.where(name: 'Apple').first[:ads_top_count]).to eq(3)
          end
        end

        context 'when Google search returns too many attemps status 422' do
          it 'does not saves information for "Apple"' do
            stub_request(:get, %r{google.com/search}).to_return(status: 422)
            params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'google' }
          rescue Errors::SearchKeywordError
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

        it 'returns an invalid_file error' do
          post api_v1_keywords_path, headers: create_token_header

          expect(JSON.parse(response.body)['errors']['code']).to eq('invalid_file')
        end
      end

      context 'when CSV file is in the wrong type' do
        it 'returns unprocessable_entity status' do
          params = { 'file' => fixture_file_upload('csv/wrong_type.txt'), 'source' => 'google' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the wrong_type error' do
          params = { 'file' => fixture_file_upload('csv/wrong_type.txt'), 'source' => 'google' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect(JSON.parse(response.body)['errors']['details']).to include(I18n.t('csv.validation.wrong_type'))
        end
      end

      context 'when user is not signed in' do
        it 'returns unauthorized status' do
          params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'google' }
          post api_v1_keywords_path, params: params

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when search engine is Bing' do
      context 'when CSV file is valid' do
        it 'returns success status' do
          params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'bing' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect(response).to have_http_status(:success)
        end

        it 'saves 11 keywords to the DB' do
          params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'bing' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect { post api_v1_keywords_path, params: params, headers: create_token_header }.to change(Keyword, :count).by(11)
        end

        it 'returns the upload_success meta message' do
          params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'bing' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect(JSON.parse(response.body)['meta']).to eq(I18n.t('csv.upload_success'))
        end

        context 'when Bing search is successfully fetched' do
          it 'saves keyword "VPN" with top ads count as 2' do
            stub_request(:get, %r{bing.com/search}).to_return(body: file_fixture('html/valid_bing.html').read)
            params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'bing' }
            perform_enqueued_jobs do
              post api_v1_keywords_path, params: params, headers: create_token_header
            end

            expect(Keyword.where(name: 'VPN').first[:ads_top_count]).to eq(2)
          end
        end

        context 'when Bing search returns too many attemps status 422' do
          it 'does not saves information for "VPN"' do
            stub_request(:get, %r{bing.com/search}).to_return(status: 422)
            params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'bing' }
          rescue Errors::SearchKeywordError
            perform_enqueued_jobs do
              post api_v1_keywords_path, params: params, headers: create_token_header
            end

            expect(Keyword.where(name: 'VPN').first[:ads_top_count]).to eq(0)
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
          params = { 'file' => fixture_file_upload('csv/wrong_type.txt'), 'source' => 'bing' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the wrong_type error' do
          params = { 'file' => fixture_file_upload('csv/wrong_type.txt'), 'source' => 'bing' }
          post api_v1_keywords_path, params: params, headers: create_token_header

          expect(JSON.parse(response.body)['errors']['details']).to include(I18n.t('csv.validation.wrong_type'))
        end
      end

      context 'when user is not signed in' do
        it 'returns unauthorized status' do
          params = { 'file' => fixture_file_upload('csv/valid.csv'), 'source' => 'bing' }
          post api_v1_keywords_path, params: params

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe 'GET#show' do
      context 'when CSV file is valid' do
        it 'returns success status' do
          keyword = Fabricate(:keyword_parsed)
          user = keyword.user

          get api_v1_keyword_path(keyword.id), headers: create_token_header(user)

          expect(response).to have_http_status(:success)
        end

        it 'returns same ads_page_count as the keyword' do
          keyword = Fabricate(:keyword_parsed)
          user = keyword.user

          get api_v1_keyword_path(keyword.id), headers: create_token_header(user)

          expect(JSON.parse(response.body)['data']['attributes']['ads_page_count']).to eq(keyword.reload.ads_page_count)
        end

        it 'returns json with source as an included relationship' do
          keyword = Fabricate(:keyword_parsed)
          user = keyword.user

          get api_v1_keyword_path(keyword.id), headers: create_token_header(user)

          expect(JSON.parse(response.body)['included'].find { |included| included['type'] == 'source' }['attributes']['name']).to eq(keyword.reload.source.name)
        end
      end

      context 'when keyword does not belonged to the user' do
        it 'returns not found status' do
          keyword = Fabricate(:keyword_parsed)

          get api_v1_keyword_path(keyword.id), headers: create_token_header

          expect(response).to have_http_status(:not_found)
        end

        it 'returns the api.errors.not_found error' do
          keyword = Fabricate(:keyword_parsed)

          get api_v1_keyword_path(keyword.id), headers: create_token_header

          expect(JSON.parse(response.body)['errors']['details']).to include(I18n.t('api.errors.not_found'))
        end
      end

      context 'when there is no keyword' do
        it 'returns not found status' do
          get api_v1_keyword_path(0), headers: create_token_header

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'given no token headers' do
        it 'returns an unauthorized error' do
          get api_v1_keyword_path(0)

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
