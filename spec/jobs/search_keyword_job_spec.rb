# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchKeywordJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    context 'given Google is search engine' do
      context 'given a valid request' do
        it 'saves 3 as ads_top_count' do
          stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id

          expect(keyword.reload.ads_top_count).to eq(3)
        end

        it 'saves 4 as ads_page_count' do
          stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id

          expect(keyword.reload.ads_page_count).to eq(4)
        end

        it 'saves 6 ads_top_urls' do
          stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id

          expect(keyword.reload.ads_top_urls.count).to eq(6)
        end

        it 'saves 10 as result_count' do
          stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id

          expect(keyword.reload.result_count).to eq(10)
        end

        it 'saves 10 result_urls' do
          stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id

          expect(keyword.reload.result_urls.count).to eq(10)
        end

        it 'saves 14 as total_link_count' do
          stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id

          expect(keyword.reload.total_link_count).to eq(14)
        end

        it 'saves html response as html' do
          html = file_fixture('html/valid_google.html').read
          stub_request(:get, %r{google.com/search}).to_return(body: html)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id

          expect(keyword.reload.html).to eq(html)
        end

        it 'saves keyword status as parsed' do
          stub_request(:get, %r{google.com/search}).to_return(body: file_fixture('html/valid_google.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id

          expect(keyword.reload.status).to eq('parsed')
        end
      end

      context 'given a 422 too many requests error' do
        it 'does not set any result' do
          stub_request(:get, %r{google.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id
          keyword.reload
        rescue Errors::SearchKeywordError

          keyword_urls = [keyword.ads_top_urls, keyword.result_urls, keyword.html]
          expect(keyword_urls).to all(be_nil)

          keyword_result_counts = [keyword.ads_top_count, keyword.ads_page_count, keyword.result_count, keyword.total_link_count]
          expect(keyword_result_counts).to all(eq(0))
        end

        it 'saves keyword status as failed' do
          stub_request(:get, %r{google.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id
        rescue Errors::SearchKeywordError

          expect(keyword.reload.status).to eq('failed')
        end

        it 'does not set the html attribute' do
          stub_request(:get, %r{google.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          described_class.perform_now keyword.id
        rescue Errors::SearchKeywordError

          expect(keyword.reload.html).not_to be_present
        end

        it 'performs a job with the right keyword' do
          stub_request(:get, %r{google.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))
          keyword_id = keyword.id

          allow(described_class).to receive(:perform_now)

          described_class.perform_now keyword_id
        rescue Errors::SearchKeywordError

          expect(described_class).to have_received(:perform_now).with(keyword_id).exactly(:once)
        end

        it 'raises SearchKeywordError to trigger Sidekiq retry' do
          stub_request(:get, %r{google.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Google'))

          expect do
            described_class.perform_now keyword.id
          end.to raise_error(Errors::SearchKeywordError)
        end
      end
    end

    context 'given Bing is search engine' do
      context 'given a valid request' do
        it 'saves 2 as ads_top_count' do
          stub_request(:get, %r{bing.com/search}).to_return(body: file_fixture('html/valid_bing.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id

          expect(keyword.reload.ads_top_count).to eq(2)
        end

        it 'saves 7 as ads_page_count' do
          stub_request(:get, %r{bing.com/search}).to_return(body: file_fixture('html/valid_bing.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id

          expect(keyword.reload.ads_page_count).to eq(7)
        end

        it 'saves 2 ads_top_urls' do
          stub_request(:get, %r{bing.com/search}).to_return(body: file_fixture('html/valid_bing.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id

          expect(keyword.reload.ads_top_urls.count).to eq(2)
        end

        it 'saves 4 as result_count' do
          stub_request(:get, %r{bing.com/search}).to_return(body: file_fixture('html/valid_bing.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id

          expect(keyword.reload.result_count).to eq(4)
        end

        it 'saves 4 result_urls' do
          stub_request(:get, %r{bing.com/search}).to_return(body: file_fixture('html/valid_bing.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id

          expect(keyword.reload.result_urls.count).to eq(4)
        end

        it 'saves 11 as total_link_count' do
          stub_request(:get, %r{bing.com/search}).to_return(body: file_fixture('html/valid_bing.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id

          expect(keyword.reload.total_link_count).to eq(11)
        end

        it 'saves html response as html' do
          html = file_fixture('html/valid_bing.html').read
          stub_request(:get, %r{bing.com/search}).to_return(body: html)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id

          expect(keyword.reload.html).to eq(html)
        end

        it 'saves keyword status as parsed' do
          stub_request(:get, %r{bing.com/search}).to_return(body: file_fixture('html/valid_bing.html').read)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id

          expect(keyword.reload.status).to eq('parsed')
        end
      end

      context 'given a 422 too many requests error' do
        it 'does not set any result' do
          stub_request(:get, %r{bing.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id
          keyword.reload
        rescue Errors::SearchKeywordError

          keyword_urls = [keyword.ads_top_urls, keyword.result_urls, keyword.html]
          expect(keyword_urls).to all(be_nil)

          keyword_result_counts = [keyword.ads_top_count, keyword.ads_page_count, keyword.result_count, keyword.total_link_count]
          expect(keyword_result_counts).to all(eq(0))
        end

        it 'saves keyword status as failed' do
          stub_request(:get, %r{bing.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id
        rescue Errors::SearchKeywordError

          expect(keyword.reload.status).to eq('failed')
        end

        it 'does not set the html attribute' do
          stub_request(:get, %r{bing.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          described_class.perform_now keyword.id
        rescue Errors::SearchKeywordError

          expect(keyword.reload.html).not_to be_present
        end

        it 'performs a job with the right keyword' do
          stub_request(:get, %r{bing.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))
          keyword_id = keyword.id

          allow(described_class).to receive(:perform_now)

          described_class.perform_now keyword_id
        rescue Errors::SearchKeywordError

          expect(described_class).to have_received(:perform_now).with(keyword_id).exactly(:once)
        end

        it 'raises SearchKeywordError to trigger Sidekiq retry' do
          stub_request(:get, %r{bing.com/search}).to_return(status: 422)
          keyword = Fabricate(:keyword, source: Fabricate(:source, name: 'Bing'))

          expect do
            described_class.perform_now keyword.id
          end.to raise_error(Errors::SearchKeywordError)
        end
      end
    end
  end
end
