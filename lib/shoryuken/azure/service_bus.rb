module Shoryuken
  module Azure
    class ServiceBus

      NAMESPACE_VALIDATOR = /\A[a-zA-Z0-9]+\z/.freeze
      DOMAIN = 'servicebus.windows.net'.freeze

      @namespace = nil
      attr_reader :namespace

      def initialize(namespace)
        unless namespace.to_s =~ NAMESPACE_VALIDATOR
          raise InvalidNamespace
        end

        @namespace = namespace
      end

      def api_client
        @api_client ||= begin
          ::Azure::ServiceBus::ServiceBusService.new(host, signer: signer)
        end
      end

      def add_queue(queue_name)
        queue = Queue.new(api_client, queue_name.to_s)
        Shoryuken::Client.register_queue(queue_name.to_s, queue)
      end

      private

      def signer
        ::Azure::ServiceBus::Auth::SharedAccessSigner.new
      end

      def host
        raise InvalidNamespace unless namespace

        "https://#{namespace}.#{DOMAIN}"
      end

      class InvalidNamespace < RuntimeError; end
    end
  end
end
