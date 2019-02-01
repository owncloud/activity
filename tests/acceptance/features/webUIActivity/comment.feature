@webUI @insulated @disablePreviews
Feature: Comment files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have commented
  So that I know what happened in my cloud storage

  Background:
    Given using new DAV path
    And user "user0" has been created with default attributes
    And user "user0" has logged in using the webUI

  Scenario Outline: Commenting on a file/folder should be listed in the activity page
    Given user "user0" has commented with content "My first comment" on file "<filepath><filename>"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    Examples:
      | filepath                            | filename            |
      | /                                   | lorem.txt           |
      | simple-folder/                      | testapp.zip         |
      | /                                   | 0                   |
      | 'single'quotes/                     | simple-empty-folder |
      | 0/                                  | lorem.txt           |
      | 'single'quotes/simple-empty-folder/ | for-git-commit      |

  Scenario Outline: Comment, and then deleting comment on a file/folder should be listed in the activity page without any comment
    Given user "user0" has commented with content "My first comment" on file "<filepath><filename>"
    And user "user0" has deleted the last created comment
    When the user browses to the activity page
    Then the activity number 1 should contain message "You commented on <filename>" in the activity page
    And the activity number 1 should not contain any comment message in the activity page
    Examples:
      | filepath                            | filename            |
      | /                                   | lorem.txt           |
      | simple-folder/                      | testapp.zip         |
      | /                                   | 0                   |
      | 'single'quotes/                     | simple-empty-folder |
      | 0/                                  | lorem.txt           |
      | 'single'quotes/simple-empty-folder/ | for-git-commit      |