module Shoryuken
  module Azure
    class Queue
      include ::Shoryuken::Util

      FIFO_ATTR               = 'FifoQueue'.freeze
      MESSAGE_GROUP_ID        = 'ShoryukenMessage'.freeze
      VISIBILITY_TIMEOUT_ATTR = 'VisibilityTimeout'.freeze

      QUEUE_NAME_VALIDATOR = /\A[a-zA-Z0-9]+\z/.freeze

      attr_reader :name, :api_client, :url

      def initialize(api_client, queue_name)
        @api_client = api_client
        set_by_name(queue_name.to_s)
      end

      def visibility_timeout
        # NOT SURE IF NEEDED
      end

      def delete_messages(options = {})
        # YES NEEDED
      end

      def send_message(options)
        # would like to see a less opaque method prototype
      end

      def send_messages(options)
        # yes but options needs to come from better source than being passed in
      end

      def receive_messages(options)
        # yes but options needs to come from better source than being passed in
      end

      private

      def set_by_name(queue_name)
        unless queue_name =~ QUEUE_NAME_VALIDATOR
          raise InvalidQueueName
        end

        @name = queue_name
        #@url  = api_client.get_queue_url(queue_name: queue_name).queue_url # TBD
      end

      class InvalidQueueName < RuntimeError; end
    end
  end
end