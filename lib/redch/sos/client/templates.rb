require 'slim/logic_less'

module Redch::SOS
  module Client

    module Templates

      def render(template_name, data = nil)
        begin
          template_name = template_name.to_sym
        rescue
          raise ArgumentError, "string or symbol expected"
        end

        raise ArgumentError, "Hash expected" if !data.nil? and !data.is_a?(Hash)

        find_template(templates_folder, template_name) do |file|
          fd = File.open(file, "r").read
          template = Slim::Template.new { fd }
          template.render(data)
        end
      end 

      def find_template(folder, name)
        yield File.join(folder, "#{name}.#{extension}")
      end

      def extension
        "slim"
      end

      def templates_folder
        File.join(File.expand_path(File.dirname(__FILE__)), "templates")
      end
    end

  end
end