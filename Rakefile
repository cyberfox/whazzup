$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'
require 'motion-fileutils'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Whazzup'
  app.icon = "AppIcon.icns"
  app.identifier = 'com.cyberfox.whazzup'
  app.frameworks += %w(ScriptingBridge)

  gitversion = `git describe --long`.chomp
  tagversion = gitversion[0...(gitversion.index('-'))]

  app.version = gitversion
  app.short_version = tagversion

  app.codesign_for_release = false

  app.info_plist['LSUIElement'] = true # Prevent this app from showing up in ALT-TAB and the dock
end
