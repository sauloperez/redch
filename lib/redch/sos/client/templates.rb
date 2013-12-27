require 'slim/logic_less'

module Redch::SOS
  module Client

    module Templates
      class Settings
        attr_accessor :templates_folder, :extension

        def initialize
          @extension = "slim"
          @templates_folder = File.join(File.expand_path(File.dirname(__FILE__)), "templates")
        end
      end

      module InstanceMethods
        def settings
          @settings ||= Settings.new
        end

        def render(template_name, data = nil)
          begin
            template_name = template_name.to_sym
          rescue
            raise ArgumentError, "String or Symbol expected"
          end

          raise ArgumentError, "Hash expected" if !data.nil? and !data.is_a?(Hash)

          find_template(settings.templates_folder, template_name) do |file|
            template = compile_template(file)
            template.render(data)
          end
        end

        def find_template(folder, name)
          yield File.join(folder, "#{name}.#{settings.extension}")
        end

        def compile_template(file)
          fd = File.open(file, "r").read
          template = Slim::Template.new { fd }
          template
        end
      end

      def self.included(receiver)
        receiver.send :include, InstanceMethods
      end
    end

  end
end