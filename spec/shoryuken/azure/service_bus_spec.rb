require 'spec_helper'

describe Shoryuken::Azure::ServiceBus do

  describe 'instantiation' do
    describe 'with valid namespace' do
      let(:bus) { described_class.new('testing') }

      it 'will be assigned' do
        expect(bus.namespace).to eql 'testing'
      end
    end

    describe 'with invalid namespace' do
      it 'will raise' do
        expect do
          described_class.new('with_underscore')
        end.to raise_exception Shoryuken::Azure::ServiceBus::InvalidNamespace
      end
    end

    describe 'without namespace' do
      it 'will raise' do
        expect do
          described_class.new('with_underscore')
        end.to raise_exception Shoryuken::Azure::ServiceBus::InvalidNamespace
      end
    end
  end

  describe 'retrieving azure_client' do
    let(:bus) { described_class.new('testing') }

    it 'should be service bus instance' do
      expect(bus.azure_client).to be_instance_of(::Azure::ServiceBus::ServiceBusService)
    end
  end

end