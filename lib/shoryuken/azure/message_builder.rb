require 'azure/service_bus/brokered_message'

module Shoryuken
  module Azure

    class MessageBuilder
      attr_reader :body, :options

      def initialize(msg_or_options)
        if msg_or_options.is_a?(Hash) && msg_or_options.has_key?(:message_body)
          @options = msg_or_options.dup
          @body = msg_or_options.delete(:message_body)
        else
          @options = {}
          @body = msg_or_options
        end
      end

      def serialized_body
        body.is_a?(Hash) ? JSON.dump(body) : body
      end

      def serialize
        options.merge(message_body: serialized_body)
      end
      alias_method :to_h, :serialize

      def to_brokered_message
        msg = ::Azure::ServiceBus::BrokeredMessage.new(serialized_body)
        msg.correlation_id = "test-correlation-id" # FIXME need to find what correlation-id controls
        msg
      end
    end

  end
end