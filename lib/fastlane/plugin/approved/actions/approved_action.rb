require 'fastlane/action'
require_relative '../helper/approved_helper'

module Fastlane
  module Actions
    class ApprovedAction < Action
      def self.run(params)
        UI.message("The approved plugin is working! #{Dir.getwd}")
        git_dirty_files = Actions.sh("git -C #{Dir.getwd} diff --name-only HEAD").split("\n") + Actions.sh("git -C #{repo_path} ls-files --other --exclude-standard").split("\n")
        UI.message("#{git_dirty_files.join("\n")}.")
      end

      def self.description
        "Approval helper"
      end

      def self.authors
        ["Chalermpong Satayavibul"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "I will fill it later"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "APPROVED_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
