require 'azure'
require 'shoryuken/azure/client_extension'
require 'shoryuken/azure/options'
require 'shoryuken/azure/service_bus'

module Shoryuken
  module Azure
    extend SingleForwardable

    def_delegators(
      :'Shoryuken::Azure::Options',
      :service_bus,
      :register_service_bus
    )
  end
end
