class AppDelegate
  PREFS_DEFAULTS = {
    'AskInterval' => 20,
    'TakePictures' => NSOnState
  }

  def applicationDidFinishLaunching(notification)
    NSUserDefaults.standardUserDefaults.registerDefaults PREFS_DEFAULTS
    @tasks = Tasks.new
    @prompter = Prompter.new(@tasks)

    buildMenu
  end

  def openPreferences(sender)
    @prefs_controller = PrefsWindowController.alloc.init
    @prefs_controller.showWindow(self)
    @prefs_controller.window.orderFrontRegardless
  end

  def finderView
    files = [NSURL.fileURLWithPath(@prompter.logfile)]
    NSWorkspace.sharedWorkspace.activateFileViewerSelectingURLs(files)
  end

  def askEarly
    @prompter.ask_early
  end
end
