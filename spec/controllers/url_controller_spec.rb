require 'rails_helper'
require 'spec_helper'


RSpec.describe UrlController, type: :controller do

  describe '#show' do
    context 'when valid short_url is given' do
      let(:short_url) { 'ldkjfdsl' }
      let(:full_url) {' www.klarna.com' }

      before do
        allow(Url).to receive(:lookup_by_short_url).with(short_url).and_return(full_url)
      end

      it 'should redirect to the correct page' do
        get :show, params: { short_url: short_url }
        expect(response).to have_http_status(302)
        expect(assigns[:full_url]).to eq(full_url)
      end
    end


    context 'when given a short url that is not valid' do
      let(:invalid_short_url) {'klarnaaaa' }

      before do
        allow(Url).to receive(:lookup).and_raise(Errors::InvalidUrl)
      end

      it 'returns 404' do
        get :show, params: { short_url: invalid_short_url }
        expect(response).to have_http_status(:not_found)
      end

      it 'does not save to the db' do
        get :show, params: { short_url: invalid_short_url }
        expect(Url.where(short_url: invalid_short_url)).to be_empty
      end
    end
  end

  describe '#new' do
    it 'should load the form' do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    context 'when given a valid url' do
      let(:valid_url) {' www.klarna.com' }
      let(:url) { double('url') }
      let(:short_url) {'lalalalal'}

      before do
        allow(Url).to receive(:lookup).and_return(url)
        allow(url).to receive(:short_url).and_return(short_url)
      end

      it 'returns a short_url' do
        get :create, params: { url: valid_url }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:create)
        expect(assigns(:short_url)).to eq(short_url)
      end
    end

    context 'when given a url that is not valid' do
      let(:invalid_url) {'klarna' }

      before do
        allow(Url).to receive(:lookup).and_raise(Errors::InvalidUrl)
      end

      it 'returns 404' do
        get :create, params: { url: invalid_url }
        expect(response).to have_http_status(:not_found)
      end

      it 'does not save to the db' do
        get :create, params: { url: invalid_url }
        expect(Url.where(full_url: invalid_url)).to be_empty
      end
    end
  end
end
