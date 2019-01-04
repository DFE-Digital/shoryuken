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

      def build_queue(queue_name)
        Queue.new(self, queue_name.to_s)
      end

      def register_queue(queue_name)
        Shoryuken::Client.register_queue(queue_name.to_s, build_queue(queue_name))
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
