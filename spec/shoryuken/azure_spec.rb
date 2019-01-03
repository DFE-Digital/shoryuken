require 'spec_helper'

describe Shoryuken::Azure do
  before do
    Shoryuken::Azure::Options.class_variable_set('@@service_bus', nil)
  end

  describe 'registering service_bus' do
    describe 'with valid namespace' do
      let(:bus) { described_class.register_service_bus('testing') }

      it 'will return service bus' do
        expect(bus).to be_instance_of Shoryuken::Azure::ServiceBus
      end
    end

    describe 'with invalid namespace' do
      it 'will raise' do
        expect do
          described_class.register_service_bus('with_underscore')
        end.to raise_exception Shoryuken::Azure::ServiceBus::InvalidNamespace
      end
    end

    describe 'with blank namespace' do
      it 'will raise' do
        expect do
          described_class.register_service_bus('')
        end.to raise_exception Shoryuken::Azure::ServiceBus::InvalidNamespace
      end
    end
  end

  describe 'retrieving service_bus' do
    describe 'with no bus registered' do
      it 'should raise' do
        expect(described_class.service_bus).to be_nil
      end
    end

    describe 'with bus registered' do
      before { bus = described_class.register_service_bus('testing') }

      it 'return bus' do
        expect(described_class.service_bus).to be_instance_of(::Shoryuken::Azure::ServiceBus)
      end
    end
  end

end