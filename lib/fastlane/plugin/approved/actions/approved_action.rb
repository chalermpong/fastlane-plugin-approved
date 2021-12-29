require 'fastlane/action'
require_relative '../helper/approved_helper'

module Fastlane
  module Actions
    class ApprovedAction < Action
      def self.run(params)
        require 'pathname'
        repo_path = Dir.getwd
        repo_pathname = Pathname.new(repo_path)
        other_action.approved_precheck
        
        head = Actions.sh("git -C #{repo_path} rev-parse HEAD").strip

        approved_file_path = params[:approval_file_path]
        approved_file_absolute_path = approved_file_path.replace approved_file_path.sub("#{repo_pathname}", "./")
        puts " -- updated = #{approved_file_absolute_path}".yellow
        File.expand_path(File.join(repo_pathname, approved_file_absolute_path))

        File.open(approved_file_absolute_path, "w") { |f| f.write "#{head}" }

        if params[:no_commit]
          UI.success("Approved! Your approval file has been updated!")
        else
          # then create a commit with a message
          Actions.sh("git -C #{repo_path} add #{approved_file_absolute_path}")
          begin
            commit_message = "Approved commit #{head}"
            Actions.sh("git -C #{repo_path} commit -m '#{commit_message}'")
            UI.success("Committed \"#{commit_message}\" 💾.")
          rescue => ex
              UI.error(ex)
              UI.important("Didn't commit any changes.")
          end
        end
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
          FastlaneCore::ConfigItem.new(key: :approval_file_path,
                                  env_name: "APPROVED_FILE_PATH",
                               description: "Path to approval file",
                                  optional: true,
                                      type: String,
                             default_value: ".approved"),
          FastlaneCore::ConfigItem.new(key: :no_commit,
                                  env_name: "APPROVED_NO_COMMIT",
                               description: "Update approval file but don't commit",
                                  optional: true,
                                      type: Boolean,
                             default_value: false)
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
