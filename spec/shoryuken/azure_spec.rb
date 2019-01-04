require 'spec_helper'

RSpec.describe Shoryuken::Azure do
  before do
    Shoryuken::Azure::Options.class_variable_set('@@service_bus', nil)
  end

  describe '.register_service_bus' do
    context 'with valid namespace' do
      let(:bus) { described_class.register_service_bus('testing') }

      it 'will return service bus' do
        expect(bus).to be_instance_of Shoryuken::Azure::ServiceBus
      end
    end

    context 'with invalid namespace' do
      it 'will raise' do
        expect do
          described_class.register_service_bus('with_underscore')
        end.to raise_exception Shoryuken::Azure::ServiceBus::InvalidNamespace
      end
    end

    context 'with blank namespace' do
      it 'will raise' do
        expect do
          described_class.register_service_bus('')
        end.to raise_exception Shoryuken::Azure::ServiceBus::InvalidNamespace
      end
    end
  end

  describe '.service_bus' do
    context 'with no bus registered' do
      it 'should raise' do
        expect(described_class.service_bus).to be_nil
      end
    end

    context 'with bus registered' do
      before { bus = described_class.register_service_bus('testing') }

      it 'return bus' do
        expect(described_class.service_bus).to be_instance_of(::Shoryuken::Azure::ServiceBus)
      end
    end
  end

  describe '.register_queue' do
    before { Shoryuken::Client.class_variable_set('@@queues', {}) }

    context 'with no service bus registered' do
      it 'will raise NoMethodError' do
        expect do
          Shoryuken::Azure.register_queue('foobar')
        end.to raise_exception NoMethodError
      end
    end

    context 'with service bus registered' do
      before do
        Shoryuken::Azure.register_service_bus 'test'
        Shoryuken::Azure.register_queue('foobar')
      end

      it 'will register the queue' do
        test_queue = Shoryuken::Client.queues('foobar')
        expect(test_queue).to be_instance_of(Shoryuken::Azure::Queue)
      end
    end
  end

  describe '.register_bus_and_queue' do
    before { Shoryuken::Client.class_variable_set('@@queues', {}) }

    context 'with single queue' do
      before { Shoryuken::Azure.register_bus_and_queue('test', 'foobar') }

      it 'will register the bus' do
        expect(Shoryuken::Azure.service_bus).to be_instance_of Shoryuken::Azure::ServiceBus
      end

      it 'will register the queue' do
        test_queue = Shoryuken::Client.queues('foobar')
        expect(test_queue).to be_instance_of(Shoryuken::Azure::Queue)
      end
    end

    context 'with no queue' do
      before { Shoryuken::Azure.register_bus_and_queue('test') }

      it 'will register the bus' do
        expect(Shoryuken::Azure.service_bus).to be_instance_of Shoryuken::Azure::ServiceBus
      end

      it 'will not register a queue' do
        expect(Shoryuken::Client.class_variable_get('@@queues')).to eql({})
      end
    end

    context 'with multiple queues' do
      before { Shoryuken::Azure.register_bus_and_queue('test', 'foo', 'bar') }

      it 'will register the bus' do
        expect(Shoryuken::Azure.service_bus).to be_instance_of Shoryuken::Azure::ServiceBus
      end

      it 'will register the foo queue' do
        test_queue = Shoryuken::Client.queues('foo')
        expect(test_queue).to be_instance_of(Shoryuken::Azure::Queue)
      end

      it 'will register the bar queue' do
        test_queue = Shoryuken::Client.queues('bar')
        expect(test_queue).to be_instance_of(Shoryuken::Azure::Queue)
      end
    end

    context 'with same bus already registered' do
      before do
        @bus = Shoryuken::Azure.register_service_bus('test')
        Shoryuken::Azure.register_bus_and_queue('test', 'foobar')
      end

      it 'will reuse existing bus' do
        expect(Shoryuken::Azure.service_bus).to eql @bus
      end

      it 'will register the queue' do
        test_queue = Shoryuken::Client.queues('foobar')
        expect(test_queue).to be_instance_of(Shoryuken::Azure::Queue)
      end
    end

    context 'with different bus already registered' do
      before { Shoryuken::Azure.register_service_bus('test2') }

      it 'will raise an exception' do
        expect do
          Shoryuken::Azure.register_bus_and_queue('test', 'foo', 'bar')
        end.to raise_exception Shoryuken::Azure::ServiceBusAlreadyRegistered
      end
    end
  end

end