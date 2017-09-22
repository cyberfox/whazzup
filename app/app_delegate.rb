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
    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init.tap do |statusbar|
      statusbar.setMenu @appmenu
      statusbar.setImage(NSImage.imageNamed('179-notebook.png'))
      statusbar.setHighlightMode(true)
    end
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
