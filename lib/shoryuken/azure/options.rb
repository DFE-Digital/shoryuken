module Shoryuken
  module Azure
    class Options
      @@service_bus = nil

      class << self
        def service_bus
          @@service_bus
        end

        def register_service_bus(namespace)
          @@service_bus = ServiceBus.new(namespace)
        end
      end
    end
  end
end