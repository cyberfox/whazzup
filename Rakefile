# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Prompter'
  app.identifier = 'com.cyberfox.Prompter'
  app.codesign_certificate = "3rd Party Mac Developer Application: CyberFOX Software, Inc. (S4CH5TG222)"
end
