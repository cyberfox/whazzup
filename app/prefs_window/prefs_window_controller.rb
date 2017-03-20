class PrefsWindowController < NSWindowController

  def layout
    @layout ||= PrefsWindowLayout.new
  end

  def init
    super.tap do
      self.window = layout.window

      @button_take_picture = @layout.get(:button_take_picture)
      @button_take_picture.target = self
      @button_take_picture.action = 'checkboxClick:'

      @time_interval = @layout.get(:time_interval)
      @time_interval.delegate = self
    end
  end

  def checkboxClick(sender)
    if sender.tag == 2
      NSUserDefaults.standardUserDefaults.setObject( sender.state, forKey:'TakePictures')
    end
  end

  def controlTextDidChange(notification)
    textField = notification.object
    if textField.tag == 1
      NSUserDefaults.standardUserDefaults.setObject(textField.stringValue,forKey:'AskInterval')
    end
  end

end
