@webUI @insulated @skipOnOcV10.2 @disablePreviews
Feature: Restored files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have restored using the webUI
  So that I know what happened in my cloud storage

  Background:
    Given user "Alice" has been created with default attributes and large skeleton files
    And user "Alice" has logged in using the webUI

  
  Scenario Outline: Restore a file using the webUI and check the activity
    Given user "Alice" has deleted file "<file>"
    And the user has browsed to the trashbin page
    When the user restores file "lorem.txt" from the trashbin using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You restored lorem.txt" in the activity page
    Examples:
      | file                    |
      | lorem.txt               |
      | simple-folder/lorem.txt |

  
  Scenario Outline: Restore a folder using the webUI and check the activity
    Given user "Alice" has deleted folder "<deleted-folder>"
    And the user has browsed to the trashbin page
    When the user restores folder "<restored-folder>" from the trashbin using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You restored <restored-folder>" in the activity page
    Examples:
      | deleted-folder                    | restored-folder     |
      | simple-folder                     | simple-folder       |
      | simple-folder/simple-empty-folder | simple-empty-folder |

  
  Scenario: Restore multiple deleted files/folder using the webUI and check the activity
    Given user "Alice" has deleted the following files
      | path                                  |
      | simple-folder/lorem.txt               |
      | lorem.txt                             |
      | folder with space/simple-empty-folder |
      | 'single'quotes                        |
      | strängé नेपाली folder                 |
    And the user has browsed to the trashbin page
    And the user marks these files for batch action using the webUI
      | name                  |
      | lorem.txt             |
      | 'single'quotes        |
      | strängé नेपाली folder |
    When the user batch restores the marked files using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that you restored the following files in the activity page:
      | entry                 |
      | strängé नेपाली folder   |
      | lorem.txt             |
      | 'single'quotes        |
