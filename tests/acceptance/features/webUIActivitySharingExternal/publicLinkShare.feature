@webUI @insulated @disablePreviews
Feature: public link sharing file/folders activities
  As a user
  I want to be able to see history of the files and folders shared externally
  So that I know what happened in my cloud storage

  Background:
    Given user "user1" has been created with default attributes
    And user "user1" has logged in using the webUI

  Scenario: Creating a public link of a folder and file should be listed in the activity list
    Given user "user1" has created a public link share of folder "simple-folder"
    And user "user1" has created a public link share of file "textfile0.txt"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You shared textfile0.txt and simple-folder via link" in the activity page

  Scenario: Uploading a file to a public shared folder should be listed in the activity list
    Given user "user1" has created a public link share with settings
      | path        | simple-folder |
      | permissions | create        |
    And the public has uploaded file "test.txt" with content "This is a test"
    When the user browses to the activity page
    Then the activity number 1 should contain message "created test.txt" in the activity page

  @issue-690
  Scenario: Downloading a file from a public shared folder using API should be listed in the activity list
    Given user "user1" has created a public link share of folder "simple-folder"
    When the public downloads file "lorem.txt" from inside the last public shared folder with range "bytes=1-7" using the public WebDAV API
    And the user browses to the activity page
    Then the activity number 1 should contain message "You shared simple-folder via link" in the activity page
    #Then the activity number 1 should contain message "Public shared file lorem.txt was downloaded" in the activity page

  Scenario: Downloading a public shared file from a webUI should be listed in the activity list
    Given the user has created a new public link for file "textfile0.txt" using the webUI
    And the public accesses the last created public link using the webUI
    When the public downloads the last created file using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "Public shared file textfile0.txt was downloaded" in the activity page

  Scenario: Downloading a public shared folder from a webUI should be listed in the activity list
    Given the user has created a new public link for folder "simple-folder" using the webUI
    And the public accesses the last created public link using the webUI
    When the public downloads the last created folder using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "Public shared folder simple-folder was downloaded" in the activity page

  Scenario: Creating a public link of a folder and file should not be listed in the activity list stream when shared activity has been disabled
    Given user "user1" has created a public link share of folder "simple-folder"
    And user "user1" has created a public link share of file "textfile0.txt"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Uploading a file to a public shared folder should not be listed in the activity list stream when file created activity has been disabled
    Given user "user1" has created a public link share with settings
      | path        | simple-folder |
      | permissions | create        |
    And the public has uploaded file "test.txt" with content "This is a test"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "created"
    And the activity number 1 should contain message "You shared simple-folder via link" in the activity page

  Scenario: Downloading a public shared file from a webUI should not be listed in the activity list stream when public link download activity has been disabled
    Given the user has created a new public link for file "textfile0.txt" using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "public_links" using the webUI
    And the public accesses the last created public link using the webUI
    And the public downloads the last created file using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "downloaded"
    And the activity number 1 should contain message "You shared textfile0.txt via link" in the activity page

  Scenario: Downloading a public shared folder from a webUI should not be listed in the activity list stream when public link download activity has been disabled
    Given the user has created a new public link for folder "simple-folder" using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "public_links" using the webUI
    And the public accesses the last created public link using the webUI
    And the public downloads the last created folder using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "downloaded"
    And the activity number 1 should contain message "You shared simple-folder via link" in the activity page
