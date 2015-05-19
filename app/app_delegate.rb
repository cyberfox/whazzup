class AppDelegate < PM::Delegate
  include CDQ # Remove this if you aren't using CDQ

  status_bar true, animation: :fade

  attr_accessor :notification

  PROMPTS = ["What're you working on?",
             "What'cha up to?",
             "What's going on?",
             "How goes it?",
             "What's the plan?",
             "Where are you at?",
             "What's next?",
             "What've you been up to?",
             "Status:",
             "Anything I can help with?",
             "What's happening?",
             "What's on your mind?",
             "What'cha up to?"]

  def on_load(app, options)
    cdq.setup # Remove this if you aren't using CDQ

# if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
#    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
#                                                                                                          categories:nil]];
# }
    UIApplication.sharedApplication.registerUserNotificationSettings(UIUserNotificationSettings.settingsForTypes(UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge, categories:nil))

    schedule(app)

    open SnippetFormScreen.new(nav_bar: true)
  end

  # Remove this if you are only supporting portrait
  def application(application, willChangeStatusBarOrientation: new_orientation, duration: duration)
    # Manually set RMQ's orientation before the device is actually oriented
    # So that we can do stuff like style views before the rotation begins
    device.orientation = new_orientation
  end

  def schedule(app)
    self.notification = UILocalNotification.new.tap do |n|
      n.fireDate = Time.now + (((rand*10).to_i-5)+20)*60
      n.timeZone = NSTimeZone.defaultTimeZone
      n.alertBody = PROMPTS[rand*PROMPTS.length]
      n.alertAction = "Return to app"
      n.soundName = UILocalNotificationDefaultSoundName
      n.applicationIconBadgeNumber = 1
    end
    app.scheduleLocalNotification(self.notification)
  end

  def application(application, didReceiveLocalNotification:notification)
    schedule(application)
  end
end
