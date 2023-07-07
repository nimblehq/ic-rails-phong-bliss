# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsQuery, type: :query do
  describe '#call' do
    context 'when querying with no parameters' do
      it 'returns an nil' do
        Fabricate(:keyword)
        user = Fabricate(:user)

        filter_params = {}
        keywords = described_class.new(user.keywords, filter_params).call

        expect(keywords).to be_nil
      end
    end

    context 'when querying with adwords_url_contains' do
      context 'given user does not have keyword' do
        it 'returns an empty array' do
          Fabricate(:keyword)
          user = Fabricate(:user)

          filter_params = { adwords_url_contains: 'vpn' }
          keywords = described_class.new(user.keywords, filter_params).call

          expect(keywords).to be_empty
        end
      end

      context 'when user has keyword' do
        context 'when there are urls containing the word vpn' do
          it 'returns 2 keywords' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
            Fabricate.times(2, :keyword, ads_top_urls: ads_top_urls, user: user)

            filter_params = { adwords_url_contains: 'vpn' }
            keywords = described_class.new(user.keywords, filter_params).call

            expect(keywords.count).to eq 2
          end
        end

        context 'when there is no urls containing the word vpn' do
          it 'returns empty array for keywords' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.thetop.com', 'https://www.nord.com', 'https://www.vnexpress.net']
            Fabricate(:keyword, ads_top_urls: ads_top_urls, user: user)

            filter_params = { adwords_url_contains: 'vpn' }
            keywords = described_class.new(user.keywords, filter_params).call

            expect(keywords).to be_empty
          end
        end
      end
    end

    context 'when querying with result_url_contains' do
      context 'given user does not have keyword' do
        it 'returns an empty array' do
          Fabricate(:keyword)
          user = Fabricate(:user)

          filter_params = { result_url_contains: 'vpn' }
          keywords = described_class.new(user.keywords, filter_params).call

          expect(keywords).to be_empty
        end
      end

      context 'when user has keyword' do
        context 'when there are search urls containing the word vpn' do
          it 'returns 2 keywords' do
            user = Fabricate(:user)
            result_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
            Fabricate.times(2, :keyword, result_urls: result_urls, user: user)

            filter_params = { result_url_contains: 'vpn' }
            keywords = described_class.new(user.keywords, filter_params).call

            expect(keywords.count).to eq 2
          end
        end

        context 'when there is no urls containing the word vpn' do
          it 'returns empty array for keywords' do
            user = Fabricate(:user)
            Fabricate(:keyword, user: user)

            filter_params = { result_url_contains: 'vpn' }
            keywords = described_class.new(user.keywords, filter_params).call

            expect(keywords).to be_empty
          end
        end
      end
    end

    context 'when querying with adwords_url_contains and result_url_contains' do
      context 'given user does not have keyword' do
        it 'returns an empty array' do
          Fabricate(:keyword)
          user = Fabricate(:user)

          filter_params = { adwords_url_contains: 'vpn', result_url_contains: 'vpn' }
          keywords = described_class.new(user.keywords, filter_params).call

          expect(keywords).to be_empty
        end
      end

      context 'when user has keyword' do
        context 'when there are urls containing the query words' do
          it 'returns 2 keywords' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.thetopvpn.com', 'https://www.nordvpn.com', 'https://www.vnexpress.net']
            result_urls = ['https://www.topgame.com']
            Fabricate.times(2, :keyword, ads_top_urls: ads_top_urls, result_urls: result_urls, user: user)

            filter_params = { adwords_url_contains: 'vpn', result_url_contains: 'game' }
            keywords = described_class.new(user.keywords, filter_params).call

            expect(keywords.count).to eq 2
          end
        end

        context 'when there is no urls containing the adwords_url_contains word' do
          it 'returns empty array for keywords' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.thetop.com', 'https://www.nord.com', 'https://www.vnexpress.net']
            result_urls = ['https://www.topgame.com']
            Fabricate(:keyword, ads_top_urls: ads_top_urls, result_urls: result_urls, user: user)

            filter_params = { adwords_url_contains: 'vpn', result_url_contains: 'game' }
            keywords = described_class.new(user.keywords, filter_params).call

            expect(keywords).to be_empty
          end
        end

        context 'when there is no urls containing the result_url_contains word' do
          it 'returns empty array for keywords' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.vpn.com']
            result_urls = ['https://www.top.com']
            Fabricate(:keyword, ads_top_urls: ads_top_urls, result_urls: result_urls, user: user)

            filter_params = { adwords_url_contains: 'vpn', result_url_contains: 'game' }
            keywords = described_class.new(user.keywords, filter_params).call

            expect(keywords).to be_empty
          end
        end

        context 'when there is no urls containing the query words' do
          it 'returns empty array for keywords' do
            user = Fabricate(:user)
            ads_top_urls = ['https://www.vvv.com']
            result_urls = ['https://www.top.com']
            Fabricate(:keyword, ads_top_urls: ads_top_urls, result_urls: result_urls, user: user)

            filter_params = { adwords_url_contains: 'vpn', result_url_contains: 'game' }
            keywords = described_class.new(user.keywords, filter_params).call

            expect(keywords).to be_empty
          end
        end
      end
    end
  end
end
