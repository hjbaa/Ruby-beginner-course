# frozen_string_literal: true

require 'rspec'

require_relative 'test_classes'

describe 'Accessors' do
  describe TestAccessorWithHistory do
    before { @test_object = TestAccessorWithHistory.new }

    it 'should check if setters works for two variables as well' do
      @test_object.dummy1 = 123
      @test_object.dummy2 = 'abc'

      expect(@test_object.instance_variable_get('@dummy1')).to eq(123)
      expect(@test_object.instance_variable_get('@dummy2')).to eq('abc')
    end

    it 'should check if getters works for two variables as well' do
      @test_object.dummy1 = 123
      @test_object.dummy2 = 'abc'

      expect(@test_object.dummy1).to eq(123)
      expect(@test_object.dummy2).to eq('abc')
    end

    it 'should check if variable history works for two variables as well' do
      @test_object.dummy1 = 123
      @test_object.dummy2 = 'abc'

      @test_object.dummy1 = 1234
      @test_object.dummy2 = 'abcd'

      expect(@test_object.dummy1_history).to eq([123, 1234])
      expect(@test_object.dummy2_history).to eq(%w[abc abcd])
    end
  end

  describe TestStrongAttrAccessor do
    before { @test_object = TestStrongAttrAccessor.new }

    it 'should check if setter method works' do
      @test_object.strong_accessor_test = 123

      expect(@test_object.instance_variable_get('@strong_accessor_test')).to eq(123)
    end

    it 'should check if setter method raises exception when wrong type hand over' do
      expect { @test_object.strong_accessor_test = 'abcd' }.to raise_exception(RuntimeError)
    end

    it 'should check if getter method works' do
      @test_object.strong_accessor_test = 123

      expect(@test_object.strong_accessor_test).to eq(123)
    end
  end
end

describe 'Validations' do
  describe TestPresenceValidation do
    before { @test_object = TestPresenceValidation.new }

    it "should show that variable @presence_test isn't present" do
      expect(@test_object.valid?).to be_falsey
      expect(@test_object.errors).to eq(['@presence_test is empty or nil'])
    end

    it 'should show that variable @presence_test is present' do
      @test_object.presence_test = 12
      expect(@test_object.valid?).to be_truthy
      expect(@test_object.errors).to eq([])
    end
  end

  describe TestTypeValidation do
    before { @test_object = TestTypeValidation.new }

    it "should show that @type_integer_test isn't instance of required class" do
      expected_errors = ['Wrong type of variable @type_integer_test, expected: Integer']

      @test_object.type_integer_test = 'abcd'

      expect(@test_object.valid?).to be_falsey
      expect(@test_object.errors).to eq(expected_errors)
    end

    it 'should show that @type_integer_test is instance of required class' do
      @test_object.type_integer_test = 12
      expect(@test_object.valid?).to be_truthy
      expect(@test_object.errors).to eq([])
    end
  end

  describe TestFormatValidation do
    before { @test_object = TestFormatValidation.new }

    it 'should show that @format_test does not match the format' do
      @test_object.format_test = 'abcd'
      expect(@test_object.valid?).to be_falsey
      expect(@test_object.errors).to eq(['Wrong format of variable @format_test'])
    end

    it 'should show that @format_test does match the format' do
      @test_object.format_test = '123'
      expect(@test_object.valid?).to be_truthy
      expect(@test_object.errors).to eq([])
    end
  end

  describe TestManyValidationsToOneVar do
    before { @test_object = TestManyValidationsToOneVar.new }

    it '''should show if @dummy does not pass any of validation, also
          errors method must return list of all failed validations''' do
      expected_errors = ['@dummy is empty or nil',
                         'Wrong type of variable @dummy, expected: String',
                         'Wrong format of variable @dummy']

      expect(@test_object.valid?).to be_falsey
      expect(@test_object.errors).to eq(expected_errors)
    end

    it 'should show if @dummy is valid' do
      @test_object.dummy = '123'

      expect(@test_object.valid?).to be_truthy
      expect(@test_object.errors).to eq([])
    end
  end
end
