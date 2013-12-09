module Redch::SOS
  module Client

    class Observation < Resource
      TIME_FORMAT = "%Y-%m-%dT%H:%M:%S%:z"

      def initialize(options = {})
        super(options)
      end

      def create(options)
        @id = post_observation observation(options)
      end

      private
      def observation(options)
        foi = "#{params[:namespace]}featureOfInterest/#{options[:sensor_id]}"
        offering = "#{params[:namespace]}offering/#{options[:sensor_id]}"
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
        observation[:sensor] + Time.now.to_s
      end
    end

  end
end