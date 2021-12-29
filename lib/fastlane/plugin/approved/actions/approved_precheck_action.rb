require 'fastlane/action'
require_relative '../helper/approved_helper'

module Fastlane
  module Actions
    class ApprovedPrecheckAction < Action
      def self.run(params)
        repo_path = Dir.getwd
        UI.message("The approved plugin is working! #{repo_path}")
        git_dirty_files = Actions.sh("git -C #{repo_path} diff --name-only HEAD").split("\n") + Actions.sh("git -C #{repo_path} ls-files --other --exclude-standard").split("\n")
        unless git_dirty_files.empty?
          error = [
            "Your workspace is not clean. Please clean up your workspace before running approved",
            "Found the following uncommitted files:",
            "  #{git_dirty_files.join("\n  ")}",
          ]
          UI.user_error!("#{error.join("\n")}")  
        end
        
      end

      def self.description
        "Approval pre-check helper"
      end

      def self.authors
        ["Chalermpong Satayavibul"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "This action checks if there is any uncommitted change in the workspace."
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
