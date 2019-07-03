@webUI @insulated @disablePreviews @skipOnOcV10.2
Feature: Restored files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have restored
  So that I know what happened in my cloud storage

  Background:
    Given user "user0" has been created with default attributes and skeleton files
    And user "user0" has logged in using the webUI

  @issue-622
  Scenario Outline: Restoring deleted folder should be listed in the activity list for the following filters
    Given user "user0" has deleted folder "simple-folder"
    And user "user0" has restored the folder with original path "simple-folder"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity number 1 should have message "You restored simple-folder" in the activity page
    And the activity number 2 should have message "You deleted simple-folder" in the activity page
    Examples:
      | filter            |
      | All Activities    |
      | Activities by you |
    # Favorites shows the same as 'All Activities'. Remove after fix.
      | Favorites         |

  @issue-622
  Scenario Outline: Restoring deleted folder should not be listed in the activity list for the following filters
    Given user "user0" has deleted folder "simple-folder"
    And user "user0" has restored the folder with original path "simple-folder"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity should not have any message with keyword "restored"
    And the activity should not have any message with keyword "deleted"
    Examples:
      | filter               |
      | Shares               |
      | Comments             |
      | Activities by others |
      # Favorites shows the same as 'All Activities'. Uncomment after the fix
      #| Favorites            |

  Scenario: Restoring folder that was inside a folder should be listed in the activity list
    Given user "user0" has deleted folder "simple-folder/simple-empty-folder"
    And user "user0" has restored the folder with original path "simple-folder/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored simple-empty-folder" in the activity page
    And the activity number 2 should have message "You deleted simple-empty-folder" in the activity page

  Scenario: Restoring deleted file should be listed in the activity list
    Given user "user0" has deleted folder "lorem.txt"
    And user "user0" has restored the folder with original path "lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored lorem.txt" in the activity page
    And the activity number 2 should have message "You deleted lorem.txt" in the activity page

  Scenario: Restoring deleted file that was inside a folder should be listed in the activity list
    Given user "user0" has deleted folder "simple-folder/lorem.txt"
    And user "user0" has restored the folder with original path "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored lorem.txt" in the activity page
    And the activity number 2 should have message "You deleted lorem.txt" in the activity page

  Scenario: Restoring multiple deleted folders should be listed in the activity list
    Given user "user0" has deleted folder "simple-folder/simple-empty-folder"
    And user "user0" has deleted folder "0"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted folder "strängé नेपाली folder"
    And user "user0" has restored the folder with original path "strängé नेपाली folder"
    And user "user0" has restored the folder with original path "'single'quotes"
    And user "user0" has restored the folder with original path "folder with space/simple-empty-folder"
    And user "user0" has restored the folder with original path "0"
    And user "user0" has restored the folder with original path "simple-folder/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored simple-empty-folder, 0, simple-empty-folder, 'single'quotes and strängé नेपाली folder" in the activity page
    And the activity number 2 should have message "You deleted strängé नेपाली folder, 'single'quotes, simple-empty-folder, 0 and simple-empty-folder" in the activity page

  Scenario: Restoring multiple deleted folders 6 or more should be contracted in the activity list
    Given user "user0" has deleted folder "simple-folder/simple-empty-folder"
    And user "user0" has deleted folder "0"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted folder "strängé नेपाली folder"
    And user "user0" has deleted folder "strängé नेपाली folder empty"
    And user "user0" has restored the folder with original path "strängé नेपाली folder empty"
    And user "user0" has restored the folder with original path "strängé नेपाली folder"
    And user "user0" has restored the folder with original path "'single'quotes"
    And user "user0" has restored the folder with original path "folder with space/simple-empty-folder"
    And user "user0" has restored the folder with original path "0"
    And user "user0" has restored the folder with original path "simple-folder/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored simple-empty-folder, 0, simple-empty-folder and 3 more" in the activity page
    And the activity number 2 should have message "You deleted strängé नेपाली folder empty, strängé नेपाली folder, 'single'quotes and 3 more" in the activity page

  Scenario: Restoring multiple deleted files should be listed in the activity list
    Given user "user0" has deleted file "simple-folder/lorem.txt"
    And user "user0" has deleted file "lorem.txt"
    And user "user0" has deleted file "data.zip"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the file with original path "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the file with original path "textfile0.txt"
    And user "user0" has restored the file with original path "data.zip"
    And user "user0" has restored the file with original path "lorem.txt"
    And user "user0" has restored the file with original path "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored lorem.txt, lorem.txt, data.zip, textfile0.txt and testavatar.png" in the activity page
    And the activity number 2 should have message "You deleted testavatar.png, textfile0.txt, data.zip, lorem.txt and lorem.txt" in the activity page

  Scenario: Restoring multiple deleted folders 6 or more should be contracted in the activity list
    Given user "user0" has deleted file "simple-folder/lorem.txt"
    And user "user0" has deleted file "lorem.txt"
    And user "user0" has deleted file "data.zip"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted file "'single'quotes/for-git-commit"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the file with original path "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the file with original path "'single'quotes/for-git-commit"
    And user "user0" has restored the file with original path "textfile0.txt"
    And user "user0" has restored the file with original path "data.zip"
    And user "user0" has restored the file with original path "lorem.txt"
    And user "user0" has restored the file with original path "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored lorem.txt, lorem.txt, data.zip and 3 more" in the activity page
    And the activity number 2 should have message "You deleted testavatar.png, for-git-commit, textfile0.txt and 3 more" in the activity page

  Scenario: Restoring multiple files/folders should be listed in the activity page
    Given user "user0" has deleted folder "0"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has restored the folder with original path "folder with space/simple-empty-folder"
    And user "user0" has restored the file with original path "textfile0.txt"
    And user "user0" has restored the folder with original path "'single'quotes"
    And user "user0" has restored the file with original path "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the folder with original path "0"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored 0, testavatar.png, 'single'quotes, textfile0.txt and simple-empty-folder" in the activity page
    And the activity number 2 should have message "You deleted simple-empty-folder, textfile0.txt, 'single'quotes, testavatar.png and 0" in the activity page

  Scenario: Restoring multiple files/folders 6 or more should be contracted in the activity page
    Given user "user0" has deleted folder "0"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has deleted file "data.zip"
    And user "user0" has restored the folder with original path "data.zip"
    And user "user0" has restored the folder with original path "folder with space/simple-empty-folder"
    And user "user0" has restored the file with original path "textfile0.txt"
    And user "user0" has restored the folder with original path "'single'quotes"
    And user "user0" has restored the file with original path "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the folder with original path "0"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored 0, testavatar.png, 'single'quotes and 3 more" in the activity page
    And the activity number 2 should have message "You deleted data.zip, simple-empty-folder, textfile0.txt and 3 more" in the activity page

  Scenario: Restoring files/folders in different order than the previous one should be listed in the order of actions
    Given user "user0" has deleted folder "0"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has restored the file with original path "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the folder with original path "folder with space/simple-empty-folder"
    And user "user0" has restored the folder with original path "'single'quotes"
    And user "user0" has restored the folder with original path "0"
    And user "user0" has restored the file with original path "textfile0.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You restored textfile0.txt, 0, 'single'quotes, simple-empty-folder and testavatar.png" in the activity page
    And the activity number 2 should have message "You deleted simple-empty-folder, textfile0.txt, 'single'quotes, testavatar.png and 0" in the activity page

  @issue-622
  Scenario Outline: Deleting and restoring each files/folders respectively should be listed in the same order for following filters
    Given user "user0" has deleted folder "0"
    And user "user0" has restored the folder with original path "0"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the file with original path "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has restored the folder with original path "'single'quotes"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has restored the file with original path "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has restored the folder with original path "folder with space/simple-empty-folder"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity number 1 should have message "You restored simple-empty-folder" in the activity page
    And the activity number 2 should have message "You deleted simple-empty-folder" in the activity page
    And the activity number 3 should have message "You restored textfile0.txt" in the activity page
    And the activity number 4 should have message "You deleted textfile0.txt" in the activity page
    And the activity number 5 should have message "You restored 'single'quotes" in the activity page
    And the activity number 6 should have message "You deleted 'single'quotes" in the activity page
    And the activity number 7 should have message "You restored testavatar.png" in the activity page
    And the activity number 8 should have message "You deleted testavatar.png" in the activity page
    And the activity number 9 should have message "You restored 0" in the activity page
    And the activity number 10 should have message "You deleted 0" in the activity page
    Examples:
      | filter            |
      | All Activities    |
      | Activities by you |
    # Favorites shows the same as 'All Activities'. Remove after fix.
      | Favorites         |

  Scenario: Deleting-Restoring-Deleting files/folders should be listed in the order
    Given user "user0" has deleted folder "0"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    And user "user0" has restored the file with original path "strängé नेपाली folder/testavatar.png"
    And user "user0" has restored the folder with original path "folder with space/simple-empty-folder"
    And user "user0" has restored the folder with original path "'single'quotes"
    And user "user0" has restored the folder with original path "0"
    And user "user0" has restored the file with original path "textfile0.txt"
    And user "user0" has deleted folder "0"
    And user "user0" has deleted folder "'single'quotes"
    And user "user0" has deleted file "strängé नेपाली folder/testavatar.png"
    And user "user0" has deleted file "textfile0.txt"
    And user "user0" has deleted folder "folder with space/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have message "You deleted simple-empty-folder, textfile0.txt, testavatar.png, 'single'quotes and 0" in the activity page
    And the activity number 2 should have message "You restored textfile0.txt, 0, 'single'quotes, simple-empty-folder and testavatar.png" in the activity page
    And the activity number 3 should have message "You deleted simple-empty-folder, textfile0.txt, 'single'quotes, testavatar.png and 0" in the activity page

  Scenario: Restoring deleted folder should not be listed in the activity list stream when file restored activity has been disabled
    Given user "user0" has deleted folder "simple-folder"
    And user "user0" has restored the folder with original path "simple-folder"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_restored" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You deleted simple-folder" in the activity page
    And the activity should not have any message with keyword "restored"

  Scenario: Restoring deleted file should not be listed in the activity list stream when file restored activity has been disabled
    Given user "user0" has deleted file "lorem.txt"
    And user "user0" has restored the file with original path "lorem.txt"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_restored" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have message "You deleted lorem.txt" in the activity page
    And the activity should not have any message with keyword "restored"

  Scenario: Restoring deleted file should be listed in the activity tab
    Given user "user0" has deleted folder "lorem.txt"
    And user "user0" has restored the folder with original path "lorem.txt"
    When the user browses directly to display the details of file "lorem.txt" in folder "/"
    Then the activity number 1 should have message "You restored lorem.txt" in the activity tab
    And the activity number 2 should have message "You deleted lorem.txt" in the activity tab
