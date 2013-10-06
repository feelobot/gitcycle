class Gitcycle < Thor
  module Subcommands
    class Assist < Thor

      desc "assign <request #> <user>", "Assign assistance request to user"
      def assign
      end

      desc "cancel", "Give up any assistance requests you have taken responsibility for"
      def cancel
      end

      desc "complete", "Complete any assistance requests you have taken responsibility for"
      def complete
      end

      desc "list", "List assistance requests"
      def list
      end

      desc "me", "Ask for assistance"
      def me
      end

      desc "take <request #>", "Take responsibility for assistance request"
      def take
      end
    end
  end
end