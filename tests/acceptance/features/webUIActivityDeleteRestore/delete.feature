@webUI @insulated @disablePreviews
Feature: Deleted files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have deleted
  So that I know what happened in my cloud storage

  Background:
    Given user "user0" has been created with default attributes and skeleton files
    And user "user0" has logged in using the webUI

  @issue-622
  Scenario Outline: file deletion should be listed in the activity list for following filters
    Given user "user0" has deleted file "lorem.txt"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity number 1 should have message "You deleted lorem.txt" in the activity page
    Examples:
      | filter            |
      | All Activities    |
      | Activities by you |
    # Favorites shows the same as 'All Activities'. Remove after fix.
      | Favorites         |

  @issue-622
  Scenario Outline: file deletion should not be listed in the activity list for following filters
    Given user "user0" has deleted file "lorem.txt"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity should not have any message with keyword "lorem.txt"
    Examples:
      | filter               |
      | Shares               |
      | Comments             |
      | Activities by others |
      # Favorites shows the same as 'All Activities'. Uncomment after the fix
      #| Favorites            |

  Scenario: folder deletion should be listed in the activity list
    Given user "user0" has deleted folder "simple-folder"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted simple-folder" in the activity page

  Scenario: file inside folder deleted should be listed in the activity list
    Given user "user0" has deleted file "simple-folder/block-aligned.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted block-aligned.txt" in the activity page

  Scenario: folder inside folder deleted should be listed in the activity list
    Given user "user0" has deleted folder "simple-folder/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted simple-empty-folder" in the activity page

  Scenario: Deleting multiple folders should be listed in the activity list
    Given user "user0" has deleted folder "simple-folder/simple-empty-folder"
    And user "user0" has deleted folder "0"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted folder "strängé नेपाली folder"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted strängé नेपाली folder, 'single'quotes, simple-empty-folder, 0 and simple-empty-folder" in the activity page

  Scenario: Deleting 6 or more folders at once should be contracted in the activity list
    Given user "user0" has deleted folder "simple-folder/simple-empty-folder"
    And user "user0" has deleted folder "0"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted folder "strängé नेपाली folder"
    And user "user0" has deleted folder "strängé नेपाली folder empty"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted strängé नेपाली folder empty, strängé नेपाली folder, 'single'quotes and 3 more" in the activity page

  Scenario: Deleting multiple files should be listed in the activity list
    Given user "user0" has deleted file "simple-folder/lorem.txt"
    And user "user0" has deleted file "lorem.txt"
    And user "user0" has deleted file "data.zip"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted testavatar.png, textfile0.txt, data.zip, lorem.txt and lorem.txt" in the activity page

  Scenario: Deleting 6 or more files at once should be contracted in the activity list
    Given user "user0" has deleted file "simple-folder/lorem.txt"
    And user "user0" has deleted file "lorem.txt"
    And user "user0" has deleted file "data.zip"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted file "'single'quotes/for-git-commit"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted testavatar.png, for-git-commit, textfile0.txt and 3 more" in the activity page

  @issue-622
  Scenario Outline: Deleting mix of files and folders at once should be listed in the activity list for the following filters
    Given user "user0" has deleted folder "0"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity number 1 should have message "You deleted simple-empty-folder, textfile0.txt, 'single'quotes, testavatar.png and 0" in the activity page
    Examples:
      | filter            |
      | All Activities    |
      | Activities by you |
    # Favorites shows the same as 'All Activities'. Remove after fix.
      | Favorites         |

  @issue-622
  Scenario Outline: Deleting mix of files and folders at once should not be listed in the activity list for the following filters
    Given user "user0" has deleted folder "0"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity should not have any message with keyword "deleted"
    Examples:
      | filter               |
      | Shares               |
      | Comments             |
      | Activities by others |
      # Favorites shows the same as 'All Activities'. Uncomment after the fix
      #| Favorites            |

  Scenario: Deleting mix of files and folders 6 or more at once should be contracted in the activity list
    Given user "user0" has deleted folder "0"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has deleted file "data.zip"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted data.zip, simple-empty-folder, textfile0.txt and 3 more" in the activity page

  Scenario: folder deletion should not be listed in the activity list stream when file deleted activity has been disabled
    Given user "user0" has deleted folder "simple-folder"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_deleted" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "deleted"

  Scenario: file inside folder deleted should not be listed in the activity list stream when file deleted activity has been disabled
    Given user "user0" has deleted file "simple-folder/block-aligned.txt"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_deleted" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "deleted"

  Scenario: Sharer and sharee check activity after sharer deletes shared file
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | user1    |
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And the user has reloaded the current page of the webUI
    When the user deletes file "textfile0.txt" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "You deleted textfile0.txt" in the activity page
    And the activity number 2 should have a message saying that you have shared file "textfile0.txt" with user "User One"
    When the user re-logs in as "user1" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should contain message "User Zero deleted textfile0.txt" in the activity page
    And the activity number 2 should have a message saying that user "User Zero" has shared "textfile0.txt" with you

  @skipOnOcV10.2
  Scenario: Sharer and sharee check activity after sharee deletes shared file
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | user1    |
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And the user re-logs in as "user1" using the webUI
    When the user deletes file "textfile0.txt" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that you have unshared file "textfile0.txt" shared by "User Zero" from self
    And the activity number 2 should contain message "User Zero shared textfile0.txt with you" in the activity page
    When the user re-logs in as "user0" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared file "textfile0.txt" with user "User One"

