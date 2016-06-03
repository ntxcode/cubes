require 'spec_helper'

describe Cubes::Client do
  let(:base_url) { 'http://localhost:5000' }

  subject { described_class.new(base_url: base_url) }

  describe '#info' do
    let(:info) do
      {
        'json_record_limit' => 5000,
        'cubes_version' => '1.0.1',
        'timezone' => 'UTC',
        'first_weekday' => 0,
        'api_version' => 2,
        'authentication' => {
          'type' => 'none'
        }
      }
    end

    before { stub_request(:get, "#{base_url}/info").to_return(body: info.to_json) }

    it { expect(subject.info).to eq(info) }
  end

  describe '#version' do
    let(:version) do
      {
        'version' => '1.0.1',
        'api_version' => 2,
        'server_version' => '1.0.1'
      }
    end

    before { stub_request(:get, "#{base_url}/version").to_return(body: version.to_json) }

    it { expect(subject.version).to eq(version) }
  end

  describe '#cubes' do
    let(:cubes) do
      [
        {
          'info' => {},
          'name' => 'sales',
          'label' => 'Sales'
        },
        {
            'info' => {},
            'name' => 'consumers',
            'label' => 'Consumers'
        }
      ]
    end

    before do
      stub_request(:get, "#{base_url}/cubes").to_return(body: cubes.to_json)
      cubes.each do |cube|
        stub_request(:get, "#{base_url}/cube/#{cube['name']}/model").to_return(body: cube.to_json)
      end
    end

    it { expect(subject.cubes).to be_a Array }
    it { expect(subject.cubes).to all(be_a Cubes::Cube)  }
    it { expect(subject.cubes.map(&:model)).to eq(cubes) }
  end

  describe '#cube' do
    let(:cube) do
      {
        'name' => 'sales',
        'label' => 'Sales',
        'info' => {}
      }
    end

    before { stub_request(:get, "#{base_url}/cube/sales/model").to_return(body: cube.to_json) }

    it { expect(subject.cube('sales')).to be_a Cubes::Cube }

    context "when the cube doesn't exists" do
      let(:unknown) do
        {
          'message' => 'The requested URL was not found on the server.',
          'hint' => 'If you entered the URL manually please check your spelling and try again.',
          'error' => 'not_found'
        }
      end

      before { stub_request(:get, "#{base_url}/cube/unknown/model").to_return(body: unknown.to_json) }

      it { expect { subject.cube('unknown') }.to raise_error(Cubes::Error::ResourceNotFound) }
    end
  end
end
