module Redch::SOS
  module Client

    class Sensor < Resource
      resource '/sensors'

      DATE_FORMAT = "%Y-%m-%d"

      def create(options)
        id = post sensor(options)
        @id = id.to_i
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

      def post(sensor)
        http_post(sensor) do |body|
          body['sosREST:Sensor']['sosREST:link'].each do |link|
            return last_segment(link['@href']) if last_segment(link['@rel']) == 'self'
          end
        end
      end
    end

  end
end
