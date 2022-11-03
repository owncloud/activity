@webUI @insulated @disablePreviews
Feature: Comment files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have commented
  So that I know what happened in my cloud storage

  Background:
    Given using new DAV path
    And user "Alice" has been created with default attributes and large skeleton files
    And user "Alice" has logged in using the webUI

  
  Scenario Outline: Commenting on a file/folder should be listed in the activity page
    Given user "Alice" has commented with content "My first comment" on file "<filepath><filename>"
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
    Given user "Alice" has commented with content "My first comment" on file "<filepath><filename>"
    And user "Alice" has deleted the last created comment
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
    Given user "Brian" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "Brian" has been added to group "group1"
    And user "Alice" has shared file "<filename>" with group "group1"
    And user "Alice" has commented with content "My first comment" on file "<filename>"
    When the user browses to the activity page
    Then the activity number 1 should have message "You commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have message "You shared <filename> with group group1" in the activity page
    When the user re-logs in as "Brian" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "Alice Hansen commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that user "Alice Hansen" has shared "<filename>" with you
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  
  Scenario Outline: Activity for commenting before sharing file/folder should not be listed on the activity list
    Given user "Brian" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "Brian" has been added to group "group1"
    And user "Alice" has commented with content "My first comment" on file "<filename>"
    And user "Alice" has shared file "<filename>" with group "group1"
    When the user browses to the activity page
    Then the activity number 1 should have message "You shared <filename> with group group1" in the activity page
    And the activity number 2 should have message "You commented on <filename>" in the activity page
    And the comment message for activity number 2 in the activity page should be:
    """
    My first comment
    """
    When the user re-logs in as "Brian" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" has shared "<filename>" with you
    And the activity should not have any message with keyword "comment"
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  
  Scenario Outline: Activity for commenting on a shared file/folder by sharee should be listed for sharer as well
    Given user "Brian" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "Brian" has been added to group "group1"
    And user "Alice" has shared file "<filename>" with group "group1"
    And user "Brian" has commented with content "My first comment" on file "<filename>"
    When the user browses to the activity page
    Then the activity number 1 should contain message "Brian Murphy commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have message "You shared <filename> with group group1" in the activity page
    When the user re-logs in as "Brian" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You commented on <filename>" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that user "Alice Hansen" has shared "<filename>" with you
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  
  Scenario: Activity for commenting a reshared folder by sharee should be listed for original sharer as well
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "Brian" has been added to group "group1"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with group "group1"
    And user "Brian" has shared folder "simple-empty-folder" with user "Carol"
    And user "Carol" has commented with content "My first comment" on file "simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should contain message "Carol King commented on simple-empty-folder" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that user "Brian Murphy" has shared "simple-empty-folder" with user "Carol King"
    And the activity number 3 should have message "You shared simple-empty-folder with group group1" in the activity page
    When the user re-logs in as "Brian" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "Carol King commented on simple-empty-folder" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that you have shared folder "simple-empty-folder" with user "Carol King"
    And the activity number 3 should have a message saying that user "Alice Hansen" has shared "simple-empty-folder" with you
    When the user re-logs in as "Carol" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "You commented on simple-empty-folder" in the activity page
    And the comment message for activity number 1 in the activity page should be:
    """
    My first comment
    """
    And the activity number 2 should have a message saying that user "Brian Murphy" has shared "simple-empty-folder" with you
    And the activity should not have any message with keyword "Alice Hansen"

  
  Scenario: Activity for commenting on a shared file/folder by sharee should be listed for sharer and sharee as well in the activity tab
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared file "lorem.txt" with user "Brian"
    And user "Brian" has commented with content "My first comment" on file "lorem.txt"
    When the user browses directly to display the details of file "lorem.txt" in folder "/"
    Then the activity number 1 should contain message "Brian Murphy commented" in the activity tab
    And the comment message for activity number 1 in the activity tab should be:
    """
    My first comment
    """
    And the activity number 2 should have message saying that the file is shared with user "Brian Murphy" in the activity tab
    When the user re-logs in as "Brian" using the webUI
    And the user browses directly to display the details of file "lorem.txt" in folder "/"
    Then the activity number 1 should have message "You commented" in the activity tab
    And the comment message for activity number 1 in the activity tab should be:
    """
    My first comment
    """
    And the activity number 2 should have message saying that the file is shared by user "Alice Hansen" in the activity tab
