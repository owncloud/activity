@webUI @insulated @disablePreviews
Feature: Tag files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have tagged
  So that I know what happened in my cloud storage

  
  Scenario Outline: Adding a tag on a file/folder should be listed on the activity list
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Alice" has logged in using the webUI
    And user "Alice" has created a "normal" tag with name "lorem"
    # <filepath> already has an ending slash('/')
    And user "Alice" has added tag "lorem" to file "<filepath><filename>"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You assigned system tag lorem to <filename>" in the activity page
    Examples:
      | filepath                            | filename            |
      | /                                   | lorem.txt           |
      | simple-folder/                      | testapp.zip         |
      | /                                   | 0                   |
      | 'single'quotes/                     | simple-empty-folder |
      | 0/                                  | lorem.txt           |
      | 'single'quotes/simple-empty-folder/ | for-git-commit      |

  
  Scenario Outline: Adding a tag on the shared file/folder should be listed on the activity list
    Given these users have been created with default attributes and large skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And group "group1" has been created
    And user "Alice" has been added to group "group1"
    And user "Brian" has been added to group "group1"
    And user "Alice" has created a "normal" tag with name "lorem"
    And user "Alice" has shared file "<filename>" with group "group1"
    And user "Alice" has added tag "lorem" to file "<filename>"
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have message "You assigned system tag lorem to <filename>" in the activity page
    And the activity number 2 should have message "You shared <filename> with group group1" in the activity page
    When the user re-logs in as "Brian" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "Alice Hansen assigned system tag lorem to <filename>" in the activity page
    And the activity number 2 should contain message "Alice Hansen shared <filename> with you" in the activity page
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  
  Scenario Outline: tagging activity before sharing should not be listed for the share receiver.
    Given these users have been created with default attributes and large skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And group "group1" has been created
    And user "Alice" has been added to group "group1"
    And user "Brian" has been added to group "group1"
    And user "Alice" has created a "normal" tag with name "lorem"
    And user "Alice" has added tag "lorem" to file "<filename>"
    And user "Alice" has shared entry "<filename>" with group "group1"
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have message "You shared <filename> with group group1" in the activity page
    And the activity number 2 should have message "You assigned system tag lorem to <filename>" in the activity page
    When the user re-logs in as "Brian" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "Alice Hansen shared <filename> with you" in the activity page
    And the activity should not have any message with keyword "system tag lorem"
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  
  Scenario Outline: Activity for tagging a shared file/folder by sharee should be listed for sharer as well
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "Alice" has been added to group "group1"
    And user "Brian" has been added to group "group1"
    And user "Alice" has shared file "<filename>" with group "group1"
    And user "Brian" has created a "normal" tag with name "lorem"
    And user "Brian" has added tag "lorem" to file "<filename>"
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should contain message "Brian Murphy assigned system tag lorem to <filename>" in the activity page
    And the activity number 2 should have message "You shared <filename> with group group1" in the activity page
    When the user re-logs in as "Brian" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You assigned system tag lorem to <filename>" in the activity page
    And the activity number 2 should contain message "Alice Hansen shared <filename> with you" in the activity page
    Examples:
      | filename      |
      | lorem.txt     |
      | simple-folder |

  
  Scenario: Activity for tagging a reshared folder by sharee should be listed for original sharer as well
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And group "group1" has been created
    And user "Alice" has been added to group "group1"
    And user "Brian" has been added to group "group1"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with group "group1"
    And user "Brian" has shared folder "simple-empty-folder" with user "Carol"
    And user "Carol" has created a "normal" tag with name "simple"
    And user "Carol" has added tag "simple" to folder "simple-empty-folder"
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should contain message "Carol King assigned system tag simple to simple-empty-folder" in the activity page
    And the activity number 2 should have a message saying that user "Brian Murphy" has shared "simple-empty-folder" with user "Carol King"
    And the activity number 3 should have message "You shared simple-empty-folder with group group1" in the activity page
    When the user re-logs in as "Brian" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "Carol King assigned system tag simple to simple-empty-folder" in the activity page
    And the activity number 2 should have a message saying that you have shared folder "simple-empty-folder" with user "Carol King"
    And the activity number 3 should have a message saying that user "Alice Hansen" has shared "simple-empty-folder" with you
    When the user re-logs in as "Carol" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You assigned system tag simple to simple-empty-folder" in the activity page
    And the activity number 2 should have a message saying that user "Brian Murphy" has shared "simple-empty-folder" with you
    And the activity should not have any message with keyword "Alice Hansen"

  
  Scenario: Activity for creating a normal system tag by a user should be listed in activity list of an admin
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Alice" has created a "normal" tag with name "lorem"
    And the administrator has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" created system tag "lorem"

  
  Scenario: Activity for deleting a normal system tag by a user should be listed in activity list of an admin
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Alice" has created a "normal" tag with name "lorem"
    When user "Alice" deletes the tag with name "lorem" using the WebDAV API
    And the administrator logs in using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" deleted system tag "lorem"

  
  Scenario: Activity for creating a static system tag by a administrator should be listed in activity list of an admin
    Given the administrator has created a "static" tag with name "StaticTagName"
    And the administrator has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have message "You created system tag StaticTagName (static)" in the activity page

  
  Scenario: Activity for deleting a static system tag by a administrator should be listed in activity list of an admin
    Given the administrator has created a "static" tag with name "StaticTagName"
    When the administrator deletes the tag with name "StaticTagName" using the WebDAV API
    And the administrator logs in using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You deleted system tag StaticTagName (static)" in the activity page

  @skipOnFIREFOX
  # Firefox does not auto-scroll to click the checkbox for 'disables activity log stream for "systemtags"'
  Scenario Outline: Adding a tag on a file/folder should not be listed in the activity list stream when system tags activity has been disabled
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Alice" has logged in using the webUI
    And user "Alice" has created a "normal" tag with name "lorem"
    # <filepath> already has an ending slash('/')
    And user "Alice" has added tag "lorem" to file "<filepath><filename>"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "systemtags" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "system tag"
    Examples:
      | filepath                            | filename            |
      | /                                   | lorem.txt           |
      | simple-folder/                      | testapp.zip         |
      | /                                   | 0                   |
      | 'single'quotes/                     | simple-empty-folder |
      | 0/                                  | lorem.txt           |
      | 'single'quotes/simple-empty-folder/ | for-git-commit      |

  
  Scenario: Adding a tag on a file/folder should be listed on the activity tab
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Alice" has logged in using the webUI
    And user "Alice" has created a "normal" tag with name "lorem"
    And user "Alice" has added tag "lorem" to file "lorem.txt"
    When the user browses directly to display the details of file "lorem.txt" in folder "/"
    Then the activity number 1 should contain message "You assigned system tag lorem" in the activity tab
    And the activity number 2 should contain message "You created lorem.txt" in the activity tab

  
  Scenario: Administrator checks the activity of user after deleting the user
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Alice" has created a "normal" tag with name "StaticTagName"
    And user "Alice" has been deleted
    And the administrator logs in using the webUI
    And the user browses to the activity page
    # DisplayName is not available when the user is deleted.
    Then the activity number 1 should have message "AAlice created system tag StaticTagName" in the activity page