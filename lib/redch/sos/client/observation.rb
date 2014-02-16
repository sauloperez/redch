module Redch::SOS
  module Client

    class Observation < Resource
      resource '/observations'

      TIME_FORMAT = "%Y-%m-%dT%H:%M:%S%:z"

      def create(options)
        id = post observation(options)
        @id = id.to_i
      end

      protected

      def parseTime(time)
        time.strftime(TIME_FORMAT).to_s
      end

      private

      def observation(options)
        foi = "#{Client.configuration.namespace}featureOfInterest/#{options[:sensor_id]}"
        offering = "#{Client.configuration.namespace}offering/#{options[:sensor_id]}/observations"
        {
          sensor: options[:sensor_id],
          samplingPoint: options[:location].join(' '),
          observedProperty: options[:observed_prop],
          featureOfInterest: foi,
          result: options[:result],
          beginTime: parseTime(options[:timespan][0]),
          endTime: parseTime(options[:timespan][1]),
          resultTime: parseTime(options[:time]),
          offering: offering
        }
      end

      def post(observation)
        http_post(observation) do |body|
          body['sosREST:Observation']['sosREST:link'].each do |link|
            return last_segment(link['@href']) if last_segment(link['@rel']) == 'self'
          end
        end
      end
    end

  end
end
