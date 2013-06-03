# -*- coding: utf-8 -*-
require 'test_helper'
require 'capybara'
require 'capybara/dsl'
require 'database_cleaner'

Capybara.app = Agility::Application
Capybara.default_driver = :rack_test
DatabaseCleaner.strategy = :truncation

class CreateAccountTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    #DatabaseCleaner.clean
  end

  test "create account" do
    Capybara.current_driver = :selenium
    visit root_path

    # create administrator
    fill_in "user_name", :with => "Admin User"
    fill_in "user_email_address", :with => "admin@example.com"
    fill_in "user_password", :with => "test123"
    fill_in "user_password_confirmation", :with => "test123"
    click_button "Register Administrator"
    assert has_content?("You are now the site administrator")
    click_link "Log out"

    # signup
    click_link "Signup"
    fill_in "user_name", :with => "Test User"
    fill_in "user_email_address", :with => "test@example.com"
    fill_in "user_password", :with => "test123"
    fill_in "user_password_confirmation", :with => "test123"
    click_button "Signup"
    assert has_content?("Thanks for signing up!")
    find("#activation-link").click
    click_button "Activate"

    # log in
    click_link "Login"
    fill_in "login", :with => "test@example.com"
    fill_in "password", :with => "test123"
    click_button "Login"
    assert has_content?("You have logged in.")

    # create First Project/Story/Task
    click_link "New Project"
    fill_in "project_name", :with => "First Project"
    click_button "Create Project"
    assert has_content?("The Project was created successfully")

    click_link "New Story"
    fill_in "story_title", :with => "First Story"
    fill_in "story[body]", :with => "First Story"
    click_button "Create Story"
    assert has_content?("The Story was created successfully")

    fill_in "task_description", :with => "First Task"
    find("div.task-users select").select("Test User")
    click_button "Add"
    assert has_content?("The Task was created successfully")

    # create Second User
    click_link "Log out"
    click_link "Signup"
    fill_in "user_name", :with => "Second User"
    fill_in "user_email_address", :with => "second@example.com"
    fill_in "user_password", :with => "second2"
    fill_in "user_password_confirmation", :with => "second2"
    click_button "Signup"
    assert has_content?("Thanks for signing up!")
    click_link "activation-link"
    click_button "Activate"
    click_link "Login"
    fill_in "login", :with => "second@example.com"
    fill_in "password", :with => "second2"
    click_button "Login"
    assert has_content?("You have logged in.")
    assert has_content?("New Project")

    #click_link "New Project"
    #fill_in "project_name", :with => "Second Project"
    #click_button "Create Project"

    # switch to Test User
    click_link "Log out"
    click_link "Login"
    fill_in "login", :with => "test@example.com"
    fill_in "password", :with => "test123"
    click_button "Login"
    assert has_content?("Logged in as Test User")

    # add Second User to First Task
    click_link "First Project"
    click_link "First Story"
    click_link "Edit Task"
    find("div.task-users select").select("Second User")
    click_button "Save Task"
    assert has_content?("Assigned users: Test User, Second User")

    # log in as Administrator
    click_link "Log out"
    click_link "Login"
    fill_in "login", :with => "admin@example.com"
    fill_in "password", :with => "test123"
    click_button "Login"
    assert has_content?("Logged in as Admin User")

    # define statuses
    visit "/story_statuses"
    click_link "New Story status"
    fill_in "story_status_name", :with => "discussion"
    click_button "Create Story status"
    assert has_content?("There is one Story status")
    click_link "New Story status"
    fill_in "story_status_name", :with => "documentation"
    click_button "Create Story status"
    assert has_content?("There are 2 Story statuses")

    # log in as Test User
    click_link "Log out"
    click_link "Login"
    fill_in "login", :with => "test@example.com"
    fill_in "password", :with => "test123"
    click_button "Login"
    assert has_content?("Logged in as Test User")

    # add status to First Story
    click_link "Home"
    click_link "First Project"
    click_link "First Story"
    find("select.story_status").select("discussion")
    #wait_for_visible "css=div.ajax-progress"
    #wait_for_not_visible "css=div.ajax-progress"

    click_link "« Back to Project First Project"
    assert_equal "discussion", find("span.story-status-name").text

    # check filtering
    select "documentation", :from => "status"
    assert has_content?("No stories match your criteria")

  end
end