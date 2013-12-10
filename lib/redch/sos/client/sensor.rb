module Redch::SOS
  module Client

    class Sensor < Resource
      resource '/sensors'

      DATE_FORMAT = "%Y-%m-%d"

      def create(options)
        @id = post_sensor sensor(options)
      end

      private
      def sensor(options)
        foi = "#{Client.configuration.namespace}featureOfInterest/#{options[:id]}"
        current_date = Time.now.strftime(DATE_FORMAT)
        {
          uniqueID: options[:id],
          intendedApplication: Client.configuration.intended_app,
          sensorType: options[:sensor_type],
          beginPosition: current_date,
          # endPosition: '2009-01-20',
          featureOfInterestID: foi,
          observationType: options[:observation_type],
          featureOfInterest: foi,
          featureOfInterestType: options[:foi_type],
          observablePropertyName: options[:observable_prop_name],
          observableProperty: options[:observable_prop]
        }
      end

      def post_sensor(sensor)
        http_post(sensor) do |body|
          return sensor[:uniqueID]
        end
      rescue Exception => e
        raise e
      end
    end

  end
end
