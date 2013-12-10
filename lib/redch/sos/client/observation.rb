module Redch::SOS
  module Client

    class Observation < Resource
      resource '/observations'

      TIME_FORMAT = "%Y-%m-%dT%H:%M:%S%:z"

      def create(options)
        @id = post_observation observation(options)
      end

      private
      def observation(options)
        foi = "#{Client.configuration.namespace}featureOfInterest/#{options[:sensor_id]}"
        offering = "#{Client.configuration.namespace}offering/#{options[:sensor_id]}"
        {
          sensor: options[:sensor_id],
          samplingPoint: options[:location].join(' '),
          observedProperty: options[:observed_prop],
          featureOfInterest: foi,
          result: options[:result],
          phenomenonTime: options[:time].strftime(TIME_FORMAT).to_s,
          resultTime: options[:time].strftime(TIME_FORMAT).to_s,
          offering: offering
        }
      end

      def post_observation(observation)
        http_post(observation) do |body|
          return observation[:sensor]
        end
      rescue Exception => e
        raise e
      end
    end

  end
end
