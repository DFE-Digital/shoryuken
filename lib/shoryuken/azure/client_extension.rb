require 'shoryuken/client'

module Shoryuken
  module Azure
    module ClientExtension

      module ClassMethods
        def register_queue(name, queue)
          queues = self.class_variable_get('@@queues')

          if queues.has_key? name.to_s
            raise "Queue already exists"
          else
            queues[name.to_s] = queue
          end

          queue
        end
      end

    end
  end
end

Shoryuken::Client.extend Shoryuken::Azure::ClientExtension::ClassMethods

