require 'spec_helper'

RSpec.describe Shoryuken::Azure::MessageBuilder do

  describe '.serialize' do

    context 'with string message' do
      before { @msg = Shoryuken::Azure::MessageBuilder.new('foobar') }

      it 'returns hash with message_body' do
        expect(@msg.serialize).to eql({message_body: 'foobar'})
      end
    end

    context 'with hash message' do
      before do
        @data = {first:'foo', second:'bar'}
        @msg = Shoryuken::Azure::MessageBuilder.new(@data)
      end

      it 'returns hash with message_body' do
        expect(@msg.serialize).to eql({message_body: JSON.dump(@data)})
      end
    end

    context 'with options hash containing string message' do
      before { @msg = Shoryuken::Azure::MessageBuilder.new(message_body: 'foobar') }

      it 'returns hash with message_body' do
        expect(@msg.serialize).to eql({message_body: 'foobar'})
      end
    end

    context 'with options hash containing hash message' do
      before do
        @data = {first:'foo', second:'bar'}
        @msg = Shoryuken::Azure::MessageBuilder.new({message_body: @data})
      end

      it 'returns hash with message_body' do
        expect(@msg.serialize).to eql({message_body: JSON.dump(@data)})
      end
    end

  end

  describe '.to_h' do
    before do
      @data = {first:'foo', second:'bar'}
      @msg = Shoryuken::Azure::MessageBuilder.new(@data)
    end

    it 'will be aliased to serialize' do
      expect(@msg.serialize).to eql({message_body: JSON.dump(@data)})
    end
  end

  describe '.azure_message' do
    before do
      @data = {first:'foo', second:'bar'}
      @msg = Shoryuken::Azure::MessageBuilder.new(@data)
      @azure_msg = @msg.to_brokered_message
    end

    it 'will return an Azure Brokered Message' do
      expect(@azure_msg).to be_instance_of Azure::ServiceBus::BrokeredMessage
    end

    it 'will assign message data in brokered message' do
      expect(@azure_msg.body).to eql(JSON.dump(@data))
    end
  end

end