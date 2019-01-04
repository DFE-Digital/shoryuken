module Shoryuken
  module Azure
    class Queue
      include ::Shoryuken::Util

      FIFO_ATTR               = 'FifoQueue'.freeze
      MESSAGE_GROUP_ID        = 'ShoryukenMessage'.freeze
      VISIBILITY_TIMEOUT_ATTR = 'VisibilityTimeout'.freeze

      QUEUE_NAME_VALIDATOR = /\A[a-zA-Z0-9]+\z/.freeze

      attr_reader :name, :api_client, :service_bus, :url

      def initialize(service_bus, queue_name)
        @service_bus = service_bus
        @api_client = @service_bus.api_client
        set_by_name(queue_name.to_s)
      end

      def visibility_timeout
        # NOT SURE IF NEEDED
      end

      def delete_messages(options = {})
        raise "Not yet implemented"
        # YES NEEDED
      end

      def send_message(options = {})
        message = MessageBuilder.new(options)

        api_client.send_queue_message(name, message)
      end

      def send_messages(options = {})
        raise "Not yet implemented"
        # yes but options needs to come from better source than being passed in
      end

      def receive_messages(options = {})
        raise "Not yet implemented"
        # yes but options needs to come from better source than being passed in
      end

      def fifo?
        false # FIXME investigate whether this is something we should be supporting
      end

      private

      def set_by_name(queue_name)
        unless queue_name =~ QUEUE_NAME_VALIDATOR
          raise InvalidQueueName
        end

        @name = queue_name
        #@url  = api_client.get_queue_url(queue_name: queue_name).queue_url # TBD
      end

      def prepare_message(options)
        message = Message.new(options)

        options = { message_body: options } if options.is_a?(String)

        if options[:message_body].is_a?(Hash)
          options[:message_body] = JSON.dump(body)
        end

        Azure::ServiceBus::BrokeredMessage.new(message.serialize)
      end

      class InvalidQueueName < RuntimeError; end
    end
  end
end