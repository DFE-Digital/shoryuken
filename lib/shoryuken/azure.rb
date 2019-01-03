require 'azure'
require 'shoryuken/azure/client_extension'
require 'shoryuken/azure/options'

module Shoryuken
  module Azure
    extend SingleForwardable

    def_delegators(
      :'Shoryuken::Azure::Options',
      :service_bus_namespace,
      :service_bus_namespace=,
      :service_bus_client
    )
  end
end
