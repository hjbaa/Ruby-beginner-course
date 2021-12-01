require 'rspec'

require_relative 'test'

describe 'All tests' do
  describe 'test1' do
    it 'should return false' do
      temp = Test1.new
      expect(temp.valid?).to eq(false)
    end

    it 'should return true' do
      temp = Test1.new
      temp.a = 12
      expect(temp.valid?).to eq(true)
    end
  end

  describe 'Test2' do
    it 'should return false' do
      temp = Test2.new
      temp.a = 'abcd'
      expect(temp.valid?).to eq(false)
    end

    it 'should return true' do
      temp = Test2.new
      temp.a = 12
      expect(temp.valid?).to eq(true)
    end
  end

  describe 'Test3' do
    it 'should return false' do
      temp = Test3.new
      temp.a = 'abcd'
      expect(temp.valid?).to eq(false)
    end

    it 'should return true' do
      temp = Test3.new
      temp.a = '123'
      expect(temp.valid?).to eq(true)
    end
  end

  describe 'Test4' do
    it 'should return false' do
      temp = Test4.new
      expect(temp.valid?).to eq(false)
      temp.a = 123
      expect(temp.valid?).to eq(false)
      temp.a = 'abcd'
      expect(temp.valid?).to eq(false)
    end

    it 'should return true' do
      temp = Test4.new
      temp.a = '123'
      expect(temp.valid?).to eq(true)
    end
  end


  describe Test5 do
    it 'should work correctly' do
      temp = Test5.new
      expect(temp.a).to eq(nil)
      expect(temp.b).to eq(nil)
      temp.a = 12
      temp.b = 'abcd'
      expect(temp.a).to eq(12)
      expect(temp.b).to eq('abcd')
      temp.a = 'abc'
      temp.b = 123
      expect(temp.a_history).to eq([12, 'abc'])
      expect(temp.b_history).to eq(['abcd', 123])
      expect(temp.c).to eq(nil)
      expect { temp.c = 'abcd' }.to raise_exception(RuntimeError)
    end
  end
end
