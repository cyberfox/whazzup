class HomeScreenStylesheet < ApplicationStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def hello_world(st)
    st.frame = {t: 100, w: 200, h: 18, centered: :horizontal}
    st.text_alignment = :center
    st.color = color.battleship_gray
    st.font = font.medium
    st.text = 'What\'cha up to?'
  end

  def text_area(st)
    st.frame = {below_prev: 20, w: 200, h: 75, centered: :horizontal}
    st.editable = true
    st.tint_color = color.blue
    st.layer.cornerRadius = 5
    st.color = color.black
    st.font = font.small
    st.scroll_enabled = true
    st.background_color = color.light_gray
  end
end
