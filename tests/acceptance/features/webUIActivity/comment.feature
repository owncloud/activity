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

  Scenario Outline: Adding a comment on the shared file/folder should be listed on the activity list
    Given user "user1" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "user1" has been added to group "group1"
    And user "user0" has shared file "<filename>" with group "group1"
    And user "user0" has commented with content "My first comment" on file "<filename>"
    When the user browses to the activity page
    Then the activity number 1 should have message "You commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have message "You shared <filename> with group group1" in the activity page
    When the user re-logs in as "user1" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "User Zero commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that user "User Zero" has shared "<filename>" with you
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  Scenario Outline: Activity for commenting before sharing file/folder should not be listed on the activity list
    Given user "user1" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "user1" has been added to group "group1"
    And user "user0" has commented with content "My first comment" on file "<filename>"
    And user "user0" has shared file "<filename>" with group "group1"
    When the user browses to the activity page
    Then the activity number 1 should have message "You shared <filename> with group group1" in the activity page
    And the activity number 2 should have message "You commented on <filename>" in the activity page
    And the comment message for activity number 2 in the activity page should be:
    """
    My first comment
    """
    When the user re-logs in as "user1" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" has shared "<filename>" with you
    And the activity should not have any message with keyword "comment"
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  Scenario Outline: Activity for commenting on a shared file/folder by sharee should be listed for sharer as well
    Given user "user1" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "user1" has been added to group "group1"
    And user "user0" has shared file "<filename>" with group "group1"
    And user "user1" has commented with content "My first comment" on file "<filename>"
    When the user browses to the activity page
    Then the activity number 1 should contain message "User One commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have message "You shared <filename> with group group1" in the activity page
    When the user re-logs in as "user1" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that user "User Zero" has shared "<filename>" with you
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  Scenario: Activity for commenting a reshared folder by sharee should be listed for original sharer as well
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user2" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "user1" has been added to group "group1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "group1"
    And user "user1" has shared folder "simple-empty-folder" with user "user2"
    And user "user2" has commented with content "My first comment" on file "simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should contain message "User Two commented on simple-empty-folder" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that user "User One" has shared "simple-empty-folder" with user "User Two"
    And the activity number 3 should have message "You shared simple-empty-folder with group group1" in the activity page
    When the user re-logs in as "user1" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "User Two commented on simple-empty-folder" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that you have shared folder "simple-empty-folder" with user "User Two"
    And the activity number 3 should have a message saying that user "User Zero" has shared "simple-empty-folder" with you
    When the user re-logs in as "user2" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "You commented on simple-empty-folder" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that user "User One" has shared "simple-empty-folder" with you
    And the activity should not have any message with keyword "User Zero"