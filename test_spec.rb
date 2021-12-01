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
      temp = Test3.new
      expect(temp.valid?).to eq(false)
      temp.a = 123
      expect(temp.valid?).to eq(false)
      temp.a = 'abcd'
      expect(temp.valid?).to eq(false)
    end

    it 'should return true' do
      temp = Test3.new
      temp.a = '123'
      expect(temp.valid?).to eq(true)
    end
  end

end
