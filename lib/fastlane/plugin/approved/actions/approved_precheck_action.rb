require 'fastlane/action'
require_relative '../helper/approved_helper'

module Fastlane
  module Actions
    class ApprovedPrecheckAction < Action
      def self.run(params)
        repo_path = Dir.getwd
        repo_pathname = Pathname.new(repo_path)
        UI.message("Performing Approved Pre-check!")
        git_dirty_files = Actions.sh("git -C #{repo_path} diff --name-only HEAD").split("\n") + Actions.sh("git -C #{repo_path} ls-files --other --exclude-standard").split("\n")

        approved_folder_path = params[:approval_folder]
        approved_folder_name = File.basename(approved_folder_path)
        git_dirty_files.delete_if {|path| 
          path.start_with?(approved_folder_name) 
        }

        unless git_dirty_files.empty?
          error = [
            "Your workspace is not clean. Please clean up your workspace before running approved",
            "Found the following uncommitted files:",
            "  #{git_dirty_files.join("\n  ")}",
          ]
          UI.user_error!("#{error.join("\n")}")
        end
        UI.message("Good. Approved Pre-check passed!!!")
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
          FastlaneCore::ConfigItem.new(key: :approval_folder,
                                  env_name: "APPROVED_FOLDER",
                               description: "Folder to store approval file",
                                  optional: true,
                                      type: String,
                             default_value: ".approved")
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
