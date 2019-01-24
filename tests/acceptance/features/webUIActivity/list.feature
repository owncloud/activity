@webUI @insulated @disablePreviews
Feature: List activity
  As a user I want to be able to see the activity list
  So that I know what is happening with my files/folders

  Scenario: folder share should be listed in the activity list
    Given these users have been created with default attributes but not initialized:
      | username |
      | user0    |
      | user1    |
      | user2    |
    And user "user0" creates folder "/one" using the WebDAV API
    And user "user0" creates folder "/two" using the WebDAV API
    And user "user0" has shared folder "/one" with user "user1"
    And user "user0" has shared folder "/two" with user "user2"
    And user "user0" has browsed to the activity page
    Then the activity number 1 should have a message saying that you have shared folder "two" with user "User Two"
    And the activity number 2 should have a message saying that you have shared folder "one" with user "User One"
