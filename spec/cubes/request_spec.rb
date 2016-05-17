require 'spec_helper'

describe Cubes::Request do
  let(:base_url) { 'http://localhost:5000' }

  let(:conn) { Faraday.new(url: base_url) }
  let(:with_params) { { 'message' => 'with params' } }
  let(:without_params) { { 'message' => 'without params' } }
  let(:prefix) { '/' }

  subject { described_class.new(conn, prefix: prefix) }

  describe '#get' do
    before do
      stub_request(:get, "#{base_url}").to_return(body: without_params.to_json)
      stub_request(:get, "#{base_url}").with(query: { q: 'success' }).to_return(body: with_params.to_json)
    end

    it { expect(subject.get('/')).to eq(without_params) }
    it { expect(subject.get('/')).to be_a(Hash) }
    it { expect(subject.get('/', q: 'success')).to eq(with_params) }

    context 'with other prefix' do
      let(:other_prefix) { { 'message' => 'other prefix' } }
      let(:prefix) { '/other' }

      before do
        stub_request(:get, "#{base_url}/other/prefix").to_return(body: other_prefix.to_json)
      end

      it { expect(subject.get('prefix')).to eq(other_prefix) }
    end
  end

  describe '#post' do
    let(:data) { { action: 'get_message' } }

    before do
      stub_request(:post, "#{base_url}").to_return(body: without_params.to_json)
    end

    it { expect(subject.post('/')).to eq(without_params) }

    context 'with body filled' do
      before do
        stub_request(:post, "#{base_url}").with(body: data.to_json).to_return(body: without_params.to_json)
        stub_request(:post, "#{base_url}").with(query: { q: 'success' }, body: data).to_return(body: with_params.to_json)
      end

      it { expect(subject.post('/', data)).to eq(without_params) }
      it { expect(subject.post('/', data, q: 'success')).to eq(with_params) }
    end

    context 'with other prefix' do
      let(:other_prefix) { { 'message' => 'other prefix' } }
      let(:prefix) { '/other' }

      before do
        stub_request(:post, "#{base_url}/other/prefix").with(body: data.to_json).to_return(body: other_prefix.to_json)
      end

      it { expect(subject.post('prefix', data)).to eq(other_prefix) }
    end
  end
end