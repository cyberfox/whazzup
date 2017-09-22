class AppDelegate
  PREFS_DEFAULTS = {
    'AskInterval' => 20,
    'TakePictures' => NSOnState
  }

  def createMenuItem(name, action, key='', target=self)
    NSMenuItem.alloc.initWithTitle(name, action: action, keyEquivalent: key).tap do |item|
      item.target = target unless target.nil?
    end
  end

  def applicationDidFinishLaunching(notification)
    NSUserDefaults.standardUserDefaults.registerDefaults PREFS_DEFAULTS
    @tasks = Tasks.new
    @prompter = Prompter.new(@tasks)

#    buildMenu
    appName = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @appmenu ||= NSMenu.new.tap do |menu|
      menu.initWithTitle 'Whazzup!'
      menu.addItem NSMenuItem.separatorItem
      menu.addItem createMenuItem('Ask', 'askEarly', '!')
      menu.addItem createMenuItem("About #{appName}", 'orderFrontStandardAboutPanel:')
      menu.addItem NSMenuItem.separatorItem
      menu.addItem createMenuItem('Preferences', 'openPreferences:', ',')
      sparkle = createMenuItem("Check for updates...", nil)
      menu.addItem sparkle
      sparkle.setTarget SUUpdater.new
      sparkle.setAction 'checkForUpdates:'
      menu.addItem NSMenuItem.separatorItem
      menu.addItem createMenuItem('Show in Finder', 'finderView', 'i')
      menu.addItem NSMenuItem.separatorItem
      menu.addItem createMenuItem("Quit #{appName}", 'terminate:', 'q')
    end

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
