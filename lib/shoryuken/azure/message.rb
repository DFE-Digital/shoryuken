module Shoryuken
  module Azure

    class Message
      attr_reader :azure_message, :azure_body, :message_body

      def initialize(queue, message)
        @queue = queue
        @azure_message = message
        @azure_body = JSON.parse(message.body)
        @message_body = azure_body['message_body']
        @message_attributes = parse_message_attributes
      end

      def message_id
        # FIXME stubbed for now
        Time.now.to_f.to_s
      end

      def change_visibility(*args)
        # FIXME stubbed to do nothing
        true
      end

      def receipt_handle
        # FIXME stubbed for now
        message_id
      end

      def delete
        raise "SOMETHING CALLED DELETE"
      end

      def message_attributes
        @_message_attributes ||= parse_message_attributes
      end

      private

      def parse_message_attributes
        attrs = azure_body['message_attributes']

        if attrs['shoryuken_class']
          attrs['shoryuken_class'] = attrs['shoryuken_class'].symbolize_keys
        end

        attrs
      end

    end

  end
end
