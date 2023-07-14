# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsQuery, type: :query do
  describe '#call' do
    context 'given user has keyword' do
      context 'given ads_top_urls contain a word vpn' do
        it 'returns 2 keywords' do
          user = Fabricate(:user)
          ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
          Fabricate.times(2, :keyword, ads_top_urls: ads_top_urls, user: user)
          filter_params = { adwords_url_contains: 'vpn' }
          keywords = described_class.new(Keyword, filter_params).call

          expect(keywords.count).to eq 2
        end
      end

      context 'given ads_top_urls does not contain a word apple' do
        it 'returns an empty array' do
          user = Fabricate(:user)
          ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
          Fabricate.times(2, :keyword, ads_top_urls: ads_top_urls, user: user)
          filter_params = { adwords_url_contains: 'apple' }
          keywords = described_class.new(Keyword, filter_params).call

          expect(keywords).to be_empty
        end
      end
    end
  end
end
