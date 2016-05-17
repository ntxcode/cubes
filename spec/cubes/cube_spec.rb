require 'spec_helper'

describe Cubes::Cube do
  let(:base_url) { 'http://localhost:5000/cube/sales' }

  let(:conn) do
    Faraday.new(url: 'http://localhost:5000')
  end

  let(:model) do
    {
      'name' => 'sales',
      'info' => {},
      'label' => 'Sales',
      'aggregates' => [],
      'measures' => [],
      'details' => [],
      'dimensions' => []
    }
  end

  let(:facts) do
    [
      {
        'id' => 1,
        'amount' => 25.0,
        'date.year' => 2015
      },
      {
        'id' => 2,
        'amount' => 52.2,
        'date.year' => 2016
      }
    ]
  end

  subject { described_class.new('sales', conn) }

  before do
    stub_request(:get, "#{base_url}/model").to_return(body: model.to_json)
  end

  describe '#aggregate' do
    let(:aggregate) do
      {
        'summary' => {
          'amount' => 21062
        },
        'remainder' => {},
        'cells' => [],
        'aggregates' => [
          'amount'
        ],
        'cell' => []
      }
    end

    let!(:aggregate_with_params) do
      with_params = aggregate.clone
      with_params['cell'] << {
        'type' => 'point',
        'dimension' => 'date',
        'hierarchy' => 'default',
        'level_depth' => 1,
        'invert' => false,
        'hidden' => false,
        'path' => [
          '2014'
        ]
      }
      with_params
    end

    before do
      stub_request(:get, "#{base_url}/aggregate").to_return(body: aggregate.to_json)
      stub_request(:get, "#{base_url}/aggregate?cut=date:2014").to_return(body: aggregate_with_params.to_json)
    end

    it { expect(subject.aggregate).to eq(aggregate) }
    it { expect(subject.aggregate(cut: 'date:2014')).to eq(aggregate_with_params) }
  end

  describe '#model' do
    it { expect(subject.model).to eq(model) }
  end

  describe '#facts' do
    let(:facts_with_params) { [facts.first] }

    before do
      stub_request(:get, "#{base_url}/facts").to_return(body: facts.to_json)
      stub_request(:get, "#{base_url}/facts?cut=date:2015").to_return(body: facts_with_params.to_json)
    end

    it { expect(subject.facts).to eq(facts) }
    it { expect(subject.facts(cut: 'date:2015')).to eq(facts_with_params) }
  end

  describe '#fact' do
    let(:fact) { facts.first }

    before { stub_request(:get, "#{base_url}/fact/#{fact['id']}").to_return(body: fact.to_json) }

    it { expect(subject.fact(fact['id'])).to eq(fact) }
  end

  describe '#members' do
    let(:member) do
      {
        'dimension' => 'date',
        'depth' => 1,
        'hierarchy' => 'default',
        'data' => [
          {
            'date.year' => '2016',
            'date.month' => '05'
          },
          {
            'date.year' => '2015',
            'date.month' => '06'
          }
        ]
      }
    end

    let(:member_depth) { member.merge('depth' => 2) }

    before do
      stub_request(:get, "#{base_url}/members/#{member['dimension']}").to_return(body: member.to_json)
      stub_request(:get, "#{base_url}/members/#{member['dimension']}")
          .with(query: { depth: member_depth['depth'] })
          .to_return(body: member_depth.to_json)
    end

    it { expect(subject.members(member['dimension'])).to eq(member) }
    it { expect(subject.members(member_depth['dimension'], depth: member_depth['depth'])).to eq(member_depth) }
  end
end