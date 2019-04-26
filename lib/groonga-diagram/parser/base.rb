module GroongaDiagram
  module Parser
    class BaseParser
      def select?(command)
        [
          "select",
          "logical_select"
        ].include?(command.command_name)
      end
    end
  end
end
