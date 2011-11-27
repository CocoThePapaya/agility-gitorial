# -*- coding: utf-8 -*-
require 'test_helper'
require 'capybara'
require 'capybara/dsl'
require 'database_cleaner'

Capybara.app = Agility::Application
Capybara.default_driver = :rack_test
DatabaseCleaner.strategy = :truncation

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

class EditorsTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
    @admin = create(:admin)
    @verify_list = []
  end

  teardown do
    DatabaseCleaner.clean
  end

  def use_editor(selector, value, text_value=nil)
    text_value ||= value
    assert find("#{selector} .in-place-edit").has_no_text?(text_value)
    find("#{selector} .in-place-edit").click
    find("#{selector} input[type=text],#{selector} textarea").set(value)
    find("h2").click # just to get a blur
    find("h2").click # just to get a blur
    assert find("#{selector} .in-place-edit").has_text?(text_value)
    @verify_list << { :selector => selector, :value => text_value }
  end

  test "editors" do
    Capybara.current_driver = :webkit
    Capybara.default_wait_time = 5
    visit root_path

    # log in as Administrator
    click_link "Login"
    fill_in "login", :with => "admin@example.com"
    fill_in "password", :with => "test123"
    click_button "Login"
    assert has_content?("Logged in as Admin User")

    visit "/foos/new"

    click_button "Create Foo"
    click_link "editors"


    use_editor ".i-view", "17"
    use_editor ".f-view", "3.14159"
    use_editor ".dec-view", "12.34"
    use_editor ".s-view", "hello"
    use_editor ".tt-view", "plain text"
    use_editor ".d-view", Date.new(1973,4,8).to_s(:default)
#    use_editor ".dt-view", DateTime.new(1975,5,13,7,7).strftime(I18n.t(:"time.formats.default"))

    use_editor ".tl-view", "_this_ is *textile*", "this is textile"
    use_editor ".md-view", "*this* is **markdown**", "this is markdown"
    use_editor ".hh-view", "<i>this</i> is <b>HTML</b>", "this is HTML"

    find(".bool1-view input").click
    @verify_list << { :selector => ".bool1-view", :value => "Yes" }

    find(".bool2-view input").click
    find(".bool2-view input").click
    @verify_list << { :selector => ".bool2-view", :value => "No" }

    find(".es-view select").select("C")
    @verify_list << { :selector => ".es-view", :value => "c" }

    fill_in "foo[i]", :with => "192"
    click_button "reload editors"

    assert find(".i-view .in-place-edit").has_text?("192")

    find(".i-view .in-place-edit").click
    sleep 1
    find(".i-view input[type=text]").set('17')
    find("h2").click # just to get a blur
    find("h2").click # just to get a blur
    assert find(".i-view .in-place-edit").has_text?('17')

    click_link "exit editors"

    @verify_list.each {|v|
      assert_equal v[:value], find(v[:selector]).text
    }

  end
end
