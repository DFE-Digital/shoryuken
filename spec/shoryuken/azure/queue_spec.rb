require 'spec_helper'

RSpec.describe Shoryuken::Azure::Queue do

  describe 'instantiation' do
    let(:api_client) { Shoryuken::Azure::ServiceBus.new('testing').api_client }

    describe 'with valid queue name' do
      subject { Shoryuken::Azure::Queue.new(api_client, 'foobar') }
      it 'instatiates correctly' do
        should be_instance_of Shoryuken::Azure::Queue
      end
    end

    describe 'with invalid queue name' do
      it 'will raise error' do
        expect do
          Shoryuken::Azure::Queue.new(api_client, 'foo/bar')
        end.to raise_exception Shoryuken::Azure::Queue::InvalidQueueName
      end
    end

  end

end