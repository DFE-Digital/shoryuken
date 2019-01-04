require 'spec_helper'

RSpec.describe Shoryuken::Azure::ServiceBus do

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

  describe 'retrieving api_client' do
    let(:bus) { described_class.new('testing') }

    it 'should be service bus instance' do
      expect(bus.api_client).to be_instance_of(::Azure::ServiceBus::ServiceBusService)
    end
  end

  describe 'adding a queue' do
    let(:bus) { described_class.new('testing') }
    before { @queue = bus.register_queue 'myqueue' }

    it 'returns a Shoryuken Azure Queue' do
      expect(@queue).to be_instance_of(Shoryuken::Azure::Queue)
    end

    it 'adds it to the global Shoryuken queue list' do
      q = Shoryuken::Client.queues('myqueue')
      expect(q).to be_instance_of(Shoryuken::Azure::Queue)
    end
  end

end