require 'asot/rest/connector'
require 'asot/rest/data_transformer'

RSpec.describe Asot::Rest::DataTransformer do
  include Asot::Rest::DataTransformer

  describe 'transform_delete_batch' do
    let(:data) do
      d = []
      d.push(Asot::Rest::DataTransformer::Target.new('obj1', 'id1'))
      d.push(Asot::Rest::DataTransformer::Target.new('obj2', 'id2'))
      d
    end
    subject { transform_delete_batch(data) }

    it 'return data to post batch' do
      expect(subject.length).to eq(2)
      expect(subject[0]).to eq(method: 'DELETE', url: '/v38.0/sobjects/obj1/id1')
      expect(subject[1]).to eq(method: 'DELETE', url: '/v38.0/sobjects/obj2/id2')
    end
  end
end
