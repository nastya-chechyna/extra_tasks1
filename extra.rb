require 'selenium-webdriver'
require 'test/unit'

class TestExtra < Test::Unit::TestCase

def setup
  @driver = Selenium::WebDriver.for :firefox
end

def test_hover

  @driver.navigate.to 'https://the-internet.herokuapp.com/'
  @driver.find_element(:css, "a[href='/hovers']").click
  hover_avatar=@driver.find_element(:class, 'figure')
  @driver.action.move_to(hover_avatar).perform

  hover_descr=@driver.find_element(:class, 'figcaption')
  assert(hover_descr.displayed?)
end

def test_drag_and_drop

  @driver.navigate.to 'https://the-internet.herokuapp.com/'
  @driver.find_element(:css, "a[href='/drag_and_drop']").click

  first_element=@driver.find_element(:id, 'column-a')
  second_element=@driver.find_element(:id, 'column-b')

  @driver.action.drag_and_drop(first_element,second_element).perform
  assert(first_element.displayed?)
end

def test_select_list

  @driver.navigate.to 'https://the-internet.herokuapp.com/'
  @driver.find_element(:css, "a[href='/dropdown']").click
  @driver.find_element(:css, "option[value='1']").click
  option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, 'dropdown'))
  option.select_by(:text, 'Option 1')
  assert(@driver.find_element(id: 'dropdown').text.include? 'Option 1')
end

def test_iframe

  @driver.navigate.to 'https://the-internet.herokuapp.com/'
  @driver.find_element(:css, "a[href='/frames']").click
  @driver.find_element(:css, "a[href='/iframe']").click
  @driver.switch_to.frame('mce_0_ifr')

  editor=@driver.find_element(:id, 'tinymce')
  default_text=editor.text

  editor.clear

  editor.send_keys 'iframe test'
  new_text=editor.text

  assert_not_equal(default_text,new_text)

end

def test_key_presses

  @driver.navigate.to 'https://the-internet.herokuapp.com/'
  @driver.find_element(:css, "a[href='/key_presses']").click
  @driver.find_element(:class, 'example').send_keys :escape
  expected_text='You entered: ESCAPE'
  actual_text=@driver.find_element(:id, 'result').text

  assert_equal(expected_text, actual_text)
end

def test_javascript_alerts

  @driver.navigate.to 'https://the-internet.herokuapp.com/javascript_alerts'
  @driver.find_element(:css, "button[onclick='jsConfirm()']").click

  popup = @driver.switch_to.alert
  popup.accept

  exp_text='You clicked: Ok'
  act_text=@driver.find_element(:id, 'result').text
  assert_equal(exp_text, act_text)

end

def test_JQueryUI_menu
  @driver.navigate.to 'https://the-internet.herokuapp.com/jqueryui/menu'
  element=@driver.find_element(:id, 'ui-id-3')
  @driver.action.move_to(element).perform
  sleep(3)
  @driver.find_element(:id, 'ui-id-8').click
  menu_item=@driver.find_element(:link, 'Menu')

  assert(menu_item.displayed?)
end

def test_multiple_window
  @driver.navigate.to 'https://the-internet.herokuapp.com/windows'
  first_window = @driver.window_handle
  @driver.find_element(:link, 'Click Here').click
  all_windows = @driver.window_handles
  second_window = all_windows.select { |this_window| this_window != first_window }

  @driver.switch_to.window(first_window)
  assert(@driver.find_element(:class, 'example').text.include? 'Opening a new window')

  @driver.switch_to.window(second_window)
  assert(@driver.find_element(:class, 'example').text.include? 'New Window')
end


def teardown
  @driver.quit
end


 end