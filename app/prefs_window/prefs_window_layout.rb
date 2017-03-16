class PrefsWindowLayout < MK::WindowLayout
  PREFS_WINDOW_IDENTIFIER = 'PREFSWINDOW'

  def layout
      frame from_center(size:[380, 220])
      title "Whazzup Preferences"
      style_mask (style_mask & ~NSResizableWindowMask)
      add NSButton, :button_take_picture
      add NSTextField, :button_take_picture_label
      add NSTextField, :time_interval_label
      add NSTextField, :time_interval
  end

  def time_interval_label_style
    constraints do
      width 80
      height 20
      left.equals(:superview, :left).plus(20)
      top.equals(:superview, :top).plus(20)
    end

    editable false
    selectable false
    bordered false
    bezeled false

    cell do
      alignment NSRightTextAlignment
      scrollable false
      drawsBackground false
    end

    string_value 'Ask interval time'
  end

  def time_interval_style
    constraints do
      width 40
      height 20
      left.equals(:time_interval_label, :right).plus(10)
      top.equals(:superview, :top).plus(20)
    end

    editable true
    selectable true
    bordered true
    bezeled true

    tag 1

    string_value NSUserDefaults.standardUserDefaults.stringForKey('AskInterval')
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
    constraints do
      width 80
      height 20
      left.equals(:superview, :left).plus(20)
      top.equals(:time_interval_label, :bottom).plus(20)
    end

    editable false
    selectable false
    bordered false
    bezeled false

    cell do
      alignment NSRightTextAlignment
      scrollable false
      drawsBackground false
    end

    string_value 'Take selfie Pictures'
  end


end
