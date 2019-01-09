require 'azure/service_bus/brokered_message'

module Shoryuken
  module Azure

    class MessageBuilder
      attr_reader :body, :options

      def initialize(msg_or_options)
        if msg_or_options.is_a?(Hash) && msg_or_options.has_key?(:message_body)
          @body = msg_or_options[:message_body]
          @options = msg_or_options.except(:message_body)
        else
          @options = {}
          @body = msg_or_options
        end
      end

      def serialized_body
        body.is_a?(Hash) ? JSON.dump(body) : body
      end

      def to_h
        options.merge(message_body: body).tap do |m|
          puts "SENDING: "; puts m.to_yaml
        end
      end

      def serialize
        JSON.dump(to_h)
      end

      def to_brokered_message
        msg = ::Azure::ServiceBus::BrokeredMessage.new(serialize)
        msg.correlation_id = "test-correlation-id" # FIXME need to find what correlation-id controls
        msg
      end
    end

  end
end