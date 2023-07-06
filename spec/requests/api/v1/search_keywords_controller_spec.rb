# frozen_string_literal: true

require 'byebug'
require 'rails_helper'

RSpec.describe Api::V1::SearchKeywordsController, type: :request do
  describe 'GET#index' do
    context 'given a logged in user' do
      context 'given the user has keywords' do
        it 'returns success status' do
          user = Fabricate(:user)
          ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
          Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

          params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
          get api_v1_search_keywords_path, params: params, headers: create_token_header(user)

          expect(response).to have_http_status(:success)
        end

        context 'given there are adword urls contain the keyword VPN' do
          it 'returns 2 keywords contains the matched urls' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
            Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

            params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
            get api_v1_search_keywords_path, params: params, headers: create_token_header(user)

            response_body = JSON.parse(response.body, symbolize_names: true)
            expect(response_body[:data][0][:attributes][:ads_top_urls]).to eq(['https://www.thetopvpn.com', 'https://www.nordvpn.com'])
          end

          it 'returns metadata with page = 1, per_page = 1 and total_item = 1' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
            Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

            params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
            get api_v1_search_keywords_path, params: params, headers: create_token_header(user)

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
            get api_v1_search_keywords_path, params: params, headers: create_token_header(user)

            response_body = JSON.parse(response.body, symbolize_names: true)
            expect(response_body[:data]).to be_empty
          end

          it 'returns metadata with page = 1, per_page = 1 and total_items = 0' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.google.com', 'https://www.bing.com', 'https://www.vnexpress.net']
            Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

            params = { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 1 }
            get api_v1_search_keywords_path, params: params, headers: create_token_header(user)

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

          get api_v1_search_keywords_path, params: params, headers: create_token_header(user)
          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body[:data]).to be_empty
        end

        it 'returns metadata with page = 1, per_page = 2 and total_items = 0' do
          Fabricate(:keyword)
          get api_v1_search_keywords_path,
              params: { filter: { adwords_url_contains: 'VPN' }, page: 1, per_page: 2 },
              headers: create_token_header
          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body[:meta]).to eq(page: 1, per_page: 2, total_items: 0)
        end
      end
    end

    context 'given a non-logged in user' do
      it 'returns an unauthorized error' do
        get api_v1_search_keywords_path

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
