require 'item'

describe Item do
  subject(:item) { described_class.new 'test_string_1', 'test_string_2', 'test_string_3' }

  describe '#to_s' do
    it 'should return string delimited list of attributes' do
      expect(item.to_s).to eq 'test_string_1, test_string_2, test_string_3'
    end
  end
end
