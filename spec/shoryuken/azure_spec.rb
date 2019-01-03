require 'spec_helper'

describe Shoryuken::Azure do
  before do
    Shoryuken::Azure::Options.class_variable_set('@@service_bus_namespace', nil)
  end

  describe '.service_bus_namespace' do
    it 'will default to nil' do
      expect(described_class.service_bus_namespace).to be_nil
    end
  end

  describe 'assigning service_bus_namespace' do
    describe 'with valid name' do
      before do
        described_class.service_bus_namespace = 'testing'
      end

      it 'with valid' do
        expect(described_class.service_bus_namespace).to eql 'testing'
      end
    end

    describe 'with invalid name' do
      it 'will raise' do
        expect do
          described_class.service_bus_namespace = 'with_underscore'
        end.to raise_exception Shoryuken::Azure::Options::InvalidServiceBusNamespace
      end
    end
  end

  describe 'retrieving service_bus_client' do
    describe 'with no namespace set' do
      it 'should raise' do
        expect { described_class.service_bus_client }.
          to raise_exception(Shoryuken::Azure::Options::InvalidServiceBusNamespace)
      end
    end

    describe 'with namespace set' do
      before { described_class.service_bus_namespace = 'testing' }

      it 'should contatenate' do
        expect(described_class.service_bus_client).to be_instance_of(::Azure::ServiceBus::ServiceBusService)
      end
    end
  end

end