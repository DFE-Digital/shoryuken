module Shoryuken
  module Azure
    class Options

      SERVICE_BUS_NAMESPACE_VALIDATOR = '[a-zA-Z0-9]+'.freeze
      SERVICE_BUS_DOMAIN = 'servicebus.windows.net'.freeze

      @@service_bus_namespace = nil

      class << self

        def service_bus_namespace
          @@service_bus_namespace
        end

        def service_bus_namespace=(name)
          unless name.to_s =~ /\A#{SERVICE_BUS_NAMESPACE_VALIDATOR}\z/
            raise InvalidServiceBusNamespace
          end

          @@service_bus_namespace = name.to_s
        end

        def service_bus_host
          raise InvalidServiceBusNamespace unless service_bus_namespace

          "https://#{service_bus_namespace}.#{SERVICE_BUS_DOMAIN}"
        end

        def service_bus_client
          @service_bus_client ||= begin
            signer = ::Azure::ServiceBus::Auth::SharedAccessSigner.new
            ::Azure::ServiceBus::ServiceBusService.new(service_bus_host, signer: signer)
          end
        end

      end

      class InvalidServiceBusNamespace < RuntimeError; end

    end
  end
end