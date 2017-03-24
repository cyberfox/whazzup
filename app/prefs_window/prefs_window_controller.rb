module EscCloseWindow
  def cancelOperation(sender)
    self.close
  end
end

class PrefsWindowController < NSWindowController
  def layout
    @layout ||= PrefsWindowLayout.new
  end

  def init
    super.tap do
      self.window = layout.window
      self.window.extend(EscCloseWindow)

      @button_take_picture = @layout.get(:button_take_picture)
      @button_take_picture.target = self
      @button_take_picture.action = 'checkboxClick:'

      @button_close = @layout.get(:button_close)
      @button_close.target = self
      @button_close.action = 'closeWindow:'

      @time_interval = @layout.get(:time_interval)
      @time_interval.delegate = self
    end
  end

  def performKeyEquivalent(theEvent)
    puts "theEvent: "
    NSLog "%@", theEvent
  end

  def closeWindow(sender)
    window.close
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
