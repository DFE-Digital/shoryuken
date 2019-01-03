module Shoryuken
  module Azure
    class ServiceBus

      NAMESPACE_VALIDATOR = '[a-zA-Z0-9]+'.freeze
      DOMAIN = 'servicebus.windows.net'.freeze

      @namespace = nil
      attr_reader :namespace

      def initialize(namespace)
        unless namespace.to_s =~ /\A#{NAMESPACE_VALIDATOR}\z/
          raise InvalidNamespace
        end

        @namespace = namespace
      end

      def azure_client
        @azure_client ||= begin
          ::Azure::ServiceBus::ServiceBusService.new(host, signer: signer)
        end
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
