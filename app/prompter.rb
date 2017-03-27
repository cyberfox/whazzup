class Prompter
  FMT = NSDateFormatter.new
  FMT.setDateFormat "ddMMYYYY-HHmmss"

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

  attr_reader :logfile
  def initialize(tasks)
    @tasks = tasks

    @snap_path = File.join(NSBundle.mainBundle.resourcePath, 'imagesnap')

    application_support = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true).first
    @snippet_path = File.join(application_support, 'Whazzup', 'snippets')
    Motion::FileUtils.mkdir_p(@snippet_path) unless File.exist?(@snippet_path)

    @logfile = File.join(@snippet_path, 'snippets.txt')
    @snippets ||= open(@logfile, 'ab')
    log('[Starting up (rubymotion)]')
    ask_and_schedule
  end

  def ask
    suffix = FMT.stringFromDate Time.now

    if NSUserDefaults.standardUserDefaults.objectForKey('TakePictures') == NSOnState
      image = File.join(@snippet_path, "snippet-#{suffix}.png")
      system("#{@snap_path.inspect} -w 0.5 #{image.inspect}")
    end

    picked = PROMPTS[rand*PROMPTS.length]
    answer = input(picked)
    @tasks.refresh(answer) if answer != '...'
    log(answer)
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

  private
  def ask_and_schedule
    old_app = NSWorkspace.sharedWorkspace.frontmostApplication
    @timer = nil
    begin
      ask
    rescue => e
      alert = NSAlert.alertWithMessageText('Problem asking for input: ' + e.reason,
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

  def log(msg)
    @snippets << Time.now.to_s << ': ' << msg << "\n"
    @snippets.flush
  end

  def input(prompt, default_value="")
    alert = NSAlert.alertWithMessageText(prompt, defaultButton: "OK", alternateButton: "Cancel", otherButton: nil, informativeTextWithFormat: "")

    combo = NSComboBox.alloc.initWithFrame(NSMakeRect(0, 0, 200, 26))
    combo.stringValue = default_value
    @tasks.top(10).each { |title| combo.addItemWithObjectValue(title) }
    combo.editable = true

    alert.accessoryView = combo
    alert.window.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces
    alert.window.level = NSFloatingWindowLevel
    alert.window.setInitialFirstResponder(combo)
    alert.window.makeFirstResponder(combo)
    button = alert.runModal

    answer = combo.stringValue if button == 1
    (answer.nil? || answer.empty?) ? '...' : answer
  end
end
