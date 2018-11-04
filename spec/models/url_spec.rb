require 'rails_helper'
require 'spec_helper'


RSpec.describe Url, type: :model do

  describe '.lookup' do
    context 'when url is in the db' do
      let(:full_url) { 'www.hm.com' }
      let(:short_url) { 'dlskfj23f' }
      let(:url) { create :url, full_url: full_url, short_url: short_url }

      before do
        url # put url into the db
      end

      it 'should return the same Url object' do
        response = Url.lookup(full_url)
        expect(response).to be_kind_of(Url)
        expect(response.id).to eq(url.id)
      end
    end

    context 'when url is not in the db' do
      let(:full_url) { 'www.hm.com' }

      it 'should create a new one' do
        before_count = Url.count
        Url.lookup(full_url)
        expect(Url.count).to be > before_count
      end
    end
  end

  describe '.lookup_by_short_url' do
    context 'when short_url is in the db' do
      let(:short_url) { 'dlskfj23f' }
      let(:url) { create :url, full_url: full_url, short_url: short_url }
      before do
        url # put url into the db
      end

      context 'when full_url has http:// in the prefix' do
        let(:full_url) { 'http://www.hm.com' }

        it 'should return the full_url' do
          response = Url.lookup_by_short_url(short_url)
          expect(response).to be_kind_of(String)
          expect(response).to eq(full_url)
        end
      end

      context 'when full_url has https:// in the prefix' do
        let(:full_url) { 'https://www.hm.com' }

        it 'should return the full_url' do
          response = Url.lookup_by_short_url(short_url)
          expect(response).to eq(full_url)
        end
      end

      context 'when full_url does not have http:// or https:// in prefix' do
        # redirecting to outside websites only works if the protocol is included
        let(:full_url) { 'hm.com' }

        it 'should return the full_url with http in front' do
          response = Url.lookup_by_short_url(short_url)
          expect(response).to eq('http://' << full_url)
        end
      end
    end

    context 'when short_url is not in the db' do
      let(:short_url) { 'dlskfj23f' }

      it 'should raise an error' do
        expect{ Url.lookup_by_short_url(short_url) }.to raise_error(Errors::InvalidUrl)
      end
    end
  end

  describe '#validate' do
    let(:url) { build :url, full_url: full_url }

    context 'when url is valid' do
      let(:full_url) { 'anythingwitha.period' }

      it 'should not raise an error' do
        expect{ url.validate }.to_not raise_error(Errors::InvalidUrl)
      end
    end

    context 'when url is not valid' do
      let(:full_url) { 'doesnthaveaperiod' }

      it 'should raise an error' do
        expect{ url.validate }.to raise_error(Errors::InvalidUrl)
      end
    end
  end

end
