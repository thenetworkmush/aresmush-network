$:.unshift File.dirname(__FILE__)
load "pose_api.rb"
load "lib/autospace_cmd.rb"
load "lib/event_handlers.rb"
load "lib/helpers.rb"
load "lib/nospoof_cmd.rb"
load "lib/pemit_cmd.rb"
load "lib/pose_catcher_cmd.rb"
load "lib/pose_cmd.rb"
load "lib/pose_model.rb"
load "lib/repose_cmd.rb"
load "lib/repose_clear_cmd.rb"
load "lib/repose_order_cmd.rb"
load "lib/repose_set_cmd.rb"

module AresMUSH
  module Pose
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("pose", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/autospace.md", "help/ooc.md", "help/posing.md", "help/repose.md" ]
    end
 
    def self.config_files
      [ "config_pose.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
      case cmd.root
      when "autospace"
        return AutospaceCmd
      when "nospoof"
        return NospoofCmd
      when "pemit"
        return Pemit
      when "ooc"
        # ooc by itself is an alias for offstage
        if (cmd.args)
          return PoseCmd
        end
      when "emit", "pose", "say"        
        return PoseCmd
      when "repose"
        case cmd.switch
        when nil
          return ReposeCmd
        when "clear"
          return ReposeClearCmd
        when "on", "off"
          return ReposeSetCmd
        when "order"
          return ReposeOrderCmd
        end
      end
      
      if (cmd.raw.start_with?("\"") ||
          cmd.raw.start_with?("\\") ||
          cmd.raw.start_with?(":") ||
          cmd.raw.start_with?(";"))
        return PoseCatcherCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
  end
end