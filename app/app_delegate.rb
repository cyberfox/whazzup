class AppDelegate
  PREFS_DEFAULTS = {
    'AskInterval' => 20,
    'TakePictures' => NSOnState
  }

  PROMPTS = ["What\'re you working on?",
             "What\'cha up to?",
             "What\'s going on?",
             "How goes it?",
             "What\'s the plan?",
             "Where are you at?",
             "What\'s next?",
             "What\'ve you been up to?",
             "Status:",
             "Anything I can help with?",
             "What\'s happening?",
             "What\'s on your mind?"]

  def applicationDidFinishLaunching(notification)
    NSUserDefaults.standardUserDefaults.registerDefaults PREFS_DEFAULTS
    @snap_path = File.join(NSBundle.mainBundle.resourcePath, 'imagesnap')
    application_support = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true).first
    @snippet_path = File.join(application_support, 'Whazzup', 'snippets')
    Motion::FileUtils.mkdir_p(@snippet_path) unless File.exist?(@snippet_path)

    @last5 = []
    prep_log
    buildMenu
    ask_and_schedule
  end

  def openPreferences(sender)
    @prefs_controller = PrefsWindowController.alloc.init
    @prefs_controller.showWindow(self)
    @prefs_controller.window.orderFrontRegardless
  end


  def ask_early
    if @timer
      @timer.fire
    else
      alert = NSAlert.alertWithMessageText('The prompt is already being displayed',
                      defaultButton: "OK", alternateButton: nil,
                      otherButton: nil, informativeTextWithFormat: "")
      alert.runModal
    end
  end

  def ask_and_schedule
    old_app = NSWorkspace.sharedWorkspace.frontmostApplication
    @timer = nil
    begin
      ask
    rescue => e
      alert = NSAlert.alertWithMessageText('Problem asking for input: ' + e.message,
                      defaultButton: "OK", alternateButton: nil,
                      otherButton: nil, informativeTextWithFormat: "")
      alert.runModal
    end
    # -5..5 + 20 yields a range of 15-25 minutes.

    interval = NSUserDefaults.standardUserDefaults.integerForKey('AskInterval')

    wait_time = (((rand*10).to_i-5)+interval)*60
    @timer = NSTimer.scheduledTimerWithTimeInterval(wait_time, target: self, selector: 'ask_and_schedule', userInfo: nil, repeats: false)
    old_app.activateWithOptions(NSApplicationActivateIgnoringOtherApps)
  end

  FMT = NSDateFormatter.new
  FMT.setDateFormat "ddMMYYYY-HHmmss"

  def ask
    suffix = FMT.stringFromDate Time.now

    if NSUserDefaults.standardUserDefaults.objectForKey('TakePictures') == NSOnState
      image = File.join(@snippet_path, "snippet-#{suffix}.png")
      system("#{@snap_path.inspect} -w 0.5 #{image.inspect}")
    end

    picked = PROMPTS[rand*PROMPTS.length]
    answer = input(picked)
    log(answer)
  end

  def prep_log(file = File.join(@snippet_path, 'snippets.txt'))
    @logfile = file
    @snippets ||= open(file, 'ab')
    log('[Starting up (rubymotion)]')
  end

  def log(msg)
    @snippets << Time.now.to_s << ': ' << msg << "\n"
    @snippets.flush
  end

  def tasks(n=5)
    @hitlist.todayList.tasks.select do |task|
      !task.properties['completed'] && !task.properties['canceled']
    end.sort_by(&:priority)[0...n]
  end

  def input(prompt, default_value="")
    alert = NSAlert.alertWithMessageText(prompt, defaultButton: "OK", alternateButton: "Cancel", otherButton: nil, informativeTextWithFormat: "")

    combo = NSComboBox.alloc.initWithFrame(NSMakeRect(0, 0, 200, 26))
    combo.stringValue = default_value
    @last5.each { |entry| combo.addItemWithObjectValue(entry) }

    @hitlist = SBApplication.applicationWithBundleIdentifier("com.potionfactory.TheHitList")
    tasks.each { |entry| combo.addItemWithObjectValue(entry.title) } unless @hitlist.nil?
    combo.editable = true

    alert.accessoryView = combo
    alert.window.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces
    alert.window.level = NSFloatingWindowLevel
    alert.window.setInitialFirstResponder(combo)
    alert.window.makeFirstResponder(combo)
    button = alert.runModal

    answer = combo.stringValue if button == 1
    ((answer.nil? || answer.empty?) ? '...' : answer).tap do |entered|
      if entered != '...'
        idx = @last5.index(entered)
        @last5.insert(0, entered)
        @last5.delete_at(idx+1) if idx != nil
        @last5 = @last5[0...5]
      end
    end
  end

  # Deprecated
  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless
    input("What are you up to?")
  end

  def finderView
    files = [NSURL.fileURLWithPath(@logfile)]
    NSWorkspace.sharedWorkspace.activateFileViewerSelectingURLs(files)
  end
end
