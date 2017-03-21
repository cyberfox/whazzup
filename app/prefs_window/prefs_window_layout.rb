class PrefsWindowLayout < MK::WindowLayout
  PREFS_WINDOW_IDENTIFIER = 'PREFSWINDOW'

  def layout
      frame from_center(size:[380, 220])
      title "Whazzup Preferences"
      style_mask (style_mask & ~NSResizableWindowMask)

      add NSButton, :button_close
      add NSButton, :button_take_picture
      add NSTextField, :button_take_picture_label
      add NSTextField, :time_interval_label
      add NSTextField, :time_interval
  end

  def time_interval_label_style
    configure_as_label_with_title('Ask interval time')

    constraints do
      width 80
      height 20
      left.equals(:superview, :left).plus(20)
      top.equals(:superview, :top).plus(20)
    end
  end


  def time_interval_style
    configure_as_textinput_with_value NSUserDefaults.standardUserDefaults.stringForKey('AskInterval')
    tag 1

    constraints do
      width 40
      height 20
      left.equals(:time_interval_label, :right).plus(10)
      top.equals(:superview, :top).plus(20)
    end
  end

  def button_close_style
    bezel_style NSRoundedBezelStyle
    key_equivalent "\r"

    constraints do
      width 100
      height 20
      right.equals(:superview, :right).minus(20)
      bottom.equals(:superview, :bottom).minus(20)
    end

    title "OK"

  end

  def button_take_picture_style
    button_type NSSwitchButton
    bezel_style 0
    constraints do
      left.equals(:time_interval_label, :right).plus(10)
      top.equals(:time_interval_label, :bottom).plus(20)
    end
    tag 2
    title ""
    state NSUserDefaults.standardUserDefaults.stringForKey('TakePictures')
  end

  def button_take_picture_label_style
    configure_as_label_with_title 'Take selfie Pictures'

    constraints do
      width 80
      height 20
      left.equals(:superview, :left).plus(20)
      top.equals(:time_interval_label, :bottom).plus(20)
    end
  end

  private

  def configure_as_textinput_with_value value
    editable true
    selectable true
    bordered true
    bezeled true
    string_value value
  end

  def configure_as_label_with_title title
    editable false
    selectable false
    bordered false
    bezeled false
    string_value title

    cell do
      alignment NSRightTextAlignment
      scrollable false
      drawsBackground false
    end
  end

end
