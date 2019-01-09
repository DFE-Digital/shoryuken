require 'azure'
require 'shoryuken/azure/client_extension'
require 'shoryuken/azure/options'
require 'shoryuken/azure/service_bus'
require 'shoryuken/azure/queue'
require 'shoryuken/azure/message_builder'
require 'shoryuken/azure/message'

module Shoryuken
  module Azure
    extend SingleForwardable

    def_delegators(
      :'Shoryuken::Azure::Options',
      :service_bus,
      :register_service_bus
    )

    class << self

      def register_queue(queue_name)
        service_bus.register_queue(queue_name)
      end

      def register_bus_and_queue(namespace, *queue_names)
        if service_bus.nil?
          register_service_bus(namespace)
        elsif service_bus.namespace != namespace.to_s
          raise ServiceBusAlreadyRegistered
        end

        queue_names.each do |queue_name|
          register_queue(queue_name)
        end
      end
      alias_method :register_bus_and_queues, :register_bus_and_queue

    end

    class ServiceBusAlreadyRegistered < RuntimeError; end
  end
end
