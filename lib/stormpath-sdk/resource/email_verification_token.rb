require "stormpath-sdk/resource/instance_resource"

module Stormpath

  module Resource

    class EmailVerificationToken < InstanceResource

      def initialize dataStore, properties
        super dataStore, properties
      end
    end

  end

end
