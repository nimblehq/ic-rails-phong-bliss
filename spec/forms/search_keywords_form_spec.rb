# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchKeywordsForm, type: :form do
  describe '#seach_keywords' do
    context 'given user does not have keyword' do
      it 'returns an empty array' do
        Fabricate(:keyword)
        user = Fabricate(:user)
        filter_params = { adwords_url_contains: 'vpn' }
        pagination_params = { page: 1, items: 2 }
        _pagination, keywords = described_class.new(user.keywords, filter_params, pagination_params).search_keywords

        expect(keywords).to be_empty
      end
    end

    context 'when user has keyword' do
      context 'when there are urls contain the word vpn' do
        it 'returns 2 keywords' do
          user = Fabricate(:user)
          ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
          Fabricate.times(2, :keyword, ads_top_urls: ads_top_urls, user: user)
          filter_params = { adwords_url_contains: 'vpn' }
          pagination_params = { page: 1, items: 2 }
          _pagination, keywords = described_class.new(user.keywords, filter_params, pagination_params).search_keywords

          expect(keywords.count).to eq 2
        end

        it 'returns pagination with page = 1, items = 2 and count = 2' do
          user = Fabricate(:user)
          ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
          Fabricate.times(2, :keyword, ads_top_urls: ads_top_urls, user: user)
          filter_params = { adwords_url_contains: 'vpn' }
          pagination_params = { page: 1, items: 2 }
          pagination, _keywords = described_class.new(user.keywords, filter_params, pagination_params).search_keywords

          expect(pagination.page).to eq 1
          expect(pagination.items).to eq 2
          expect(pagination.count).to eq 2
        end
      end

      context 'when there is no urls contain the word vpn' do
        it 'returns empty array for keywords' do
          user = Fabricate(:user)
          ads_top_urls = ['https://www.thetop.com', 'https://www.nord.com', 'https://www.vnexpress.net']
          Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)
          filter_params = { adwords_url_contains: 'vpn' }
          pagination_params = { page: 1, items: 2 }
          _pagination, keywords = described_class.new(user.keywords, filter_params, pagination_params).search_keywords

          expect(keywords).to be_empty
        end

        it 'returns pagination with page = 1, items = 2 and count = 0' do
          user = Fabricate(:user)
          ads_top_urls = ['https://www.thetop.com', 'https://www.nord.com', 'https://www.vnexpress.net']
          Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)
          filter_params = { adwords_url_contains: 'vpn' }
          pagination_params = { page: 1, items: 2 }
          pagination, _keywords = described_class.new(user.keywords, filter_params, pagination_params).search_keywords

          expect(pagination.page).to eq 1
          expect(pagination.items).to eq 2
          expect(pagination.count).to eq 0
        end
      end
    end
  end
end
