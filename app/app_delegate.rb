class AppDelegate
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
    prep_log
    buildMenu
    ask_and_schedule
    @bundle = NSBundle.mainBundle
    @bundle_path = @bundle.bundlePath
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
    @timer = nil
    ask

    # -5..5 + 20 yields a range of 15-25 minutes.
    wait_time = (((rand*10).to_i-5)+20)*60
    @timer = NSTimer.scheduledTimerWithTimeInterval(wait_time, target: self, selector: 'ask_and_schedule', userInfo: nil, repeats: false)
  end

  FMT = NSDateFormatter.new
  FMT.setDateFormat "ddMMYYYY-HHmmss"

  def ask
    suffix = FMT.stringFromDate Time.now
    NSLog "%@", @bundle_path
    system("imagesnap ~/snippet-#{suffix}.png")
    picked = PROMPTS[rand*PROMPTS.length]
    answer = input(picked)
    log(answer)
  end

  def prep_log(file = "#{ENV['HOME']}/snippets.txt")
    @snippets ||= open(file, 'ab')
    log('[Starting up (rubymotion)]')
  end

  def log(msg)
    @snippets << Time.now.to_s << ': ' << msg << "\n"
    @snippets.flush
  end

  def input(prompt, default_value="")
    alert = NSAlert.alertWithMessageText(prompt, defaultButton: "OK", alternateButton: "Cancel", otherButton: nil, informativeTextWithFormat: "")
    input_field = NSTextField.alloc.initWithFrame(NSMakeRect(0, 0, 200, 24))
    input_field.stringValue = default_value
    alert.accessoryView = input_field
    alert.window.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces
    alert.window.level = NSFloatingWindowLevel
    button = alert.runModal

    answer = input_field.stringValue if button == 1
    (answer.nil? || answer.empty?) ? '...' : answer
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
end
