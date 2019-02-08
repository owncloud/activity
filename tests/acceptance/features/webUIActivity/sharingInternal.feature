@webUI @insulated @disablePreviews
Feature: Sharing file/folders activities
  As a user
  I want to be able to see history of the files and folders that I have shared or received as share
  So that I know what happened in my cloud storage

  Background:
    Given user "user0" has been created with default attributes

  Scenario: Sharing a file/folder with a user should be listed in the activity list of a sharer
    Given these users have been created with default attributes but not initialized:
      | username |
      | user1    |
      | user2    |
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user2"
    And user "user0" has shared file "simple-folder/lorem.txt" with user "user1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with user "user2"
    And user "user0" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "User Two"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "User One"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "User Two"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "User One"
    When the user filters activity list by "Activities by you"
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "User Two"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "User One"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "User Two"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "User One"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "User Two"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "User One"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "User Two"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "User One"

  Scenario: Sharing a file/folder with a group should be listed in the activity list of a sharer
    Given group "grp1" has been created
    And group "grp2" has been created
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And user "user0" has shared folder "folder with space" with group "grp2"
    And user "user0" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "grp2"
    And user "user0" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should contain message "You shared simple-empty-folder with group grp2" in the activity page
    And the activity number 2 should contain message "You shared lorem.txt with group grp1" in the activity page
    And the activity number 3 should contain message "You shared folder with space with group grp2" in the activity page
    And the activity number 4 should contain message "You shared textfile0.txt with group grp1" in the activity page
    When the user filters activity list by "Activities by you"
    Then the activity number 1 should contain message "You shared simple-empty-folder with group grp2" in the activity page
    And the activity number 2 should contain message "You shared lorem.txt with group grp1" in the activity page
    And the activity number 3 should contain message "You shared folder with space with group grp2" in the activity page
    And the activity number 4 should contain message "You shared textfile0.txt with group grp1" in the activity page
    When the user filters activity list by "Shares"
    Then the activity number 1 should contain message "You shared simple-empty-folder with group grp2" in the activity page
    And the activity number 2 should contain message "You shared lorem.txt with group grp1" in the activity page
    And the activity number 3 should contain message "You shared folder with space with group grp2" in the activity page
    And the activity number 4 should contain message "You shared textfile0.txt with group grp1" in the activity page

  Scenario: Sharing a file/folder with a user should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user1"
    And user "user0" has shared file "simple-folder/lorem.txt" with user "user1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with user "user1"
    And user "user1" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you
    When the user filters activity list by "Activities by you"
    Then the activity should not have any message with keyword "shared"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that user "User Zero" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you

  Scenario: Sharing a file/folder with a group should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes
    And group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And user "user0" has shared folder "folder with space" with group "grp1"
    And user "user0" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "grp1"
    And user "user1" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you
    When the user filters activity list by "Activities by you"
    Then the activity should not have any message with keyword "shared"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that user "User Zero" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you

  Scenario: Sharing a file/folder with a user should not be listed in the activity list stream when shared activity has been disabled
    Given these users have been created with default attributes but not initialized:
      | username |
      | user1    |
      | user2    |
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user2"
    And user "user0" has shared file "simple-folder/lorem.txt" with user "user1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with user "user2"
    And user "user0" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Sharing a file/folder with a group should not be listed in the activity list stream when shared activity has been disabled
    Given group "grp1" has been created
    And group "grp2" has been created
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And user "user0" has shared folder "folder with space" with group "grp2"
    And user "user0" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "grp2"
    And user "user0" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Receiving a file/folder from a sharer should not be listed in the activity list stream when shared activity has been disabled
    Given user "user1" has been created with default attributes
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user1"
    And user "user0" has shared file "simple-folder/lorem.txt" with user "user1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Receiving a file/folder in a group as a share should not be listed in the activity list stream when shared activity has been disabled
    Given user "user1" has been created with default attributes
    And group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And user "user0" has shared folder "folder with space" with group "grp1"
    And user "user0" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "grp1"
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"
