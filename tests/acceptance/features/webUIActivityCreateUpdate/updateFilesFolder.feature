@webUI @insulated @disablePreviews
Feature: Updated files/folders activities
  As a user
  I want to be able to see activities of updated files/folders
  So that I know what happened in my cloud storage

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has logged in using the webUI

  
  Scenario: Changing file contents should be shown in activity list
    Given user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/text.txt"
    And user "Alice" has uploaded file "filesForUpload/lorem-big.txt" to "/text.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You changed text.txt" in the activity page
    And the activity number 2 should contain message "You created text.txt" in the activity page

  @issue-622
  Scenario Outline: Changing multiple file contents should be shown in activity list for following filters
    Given user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/text.txt"
    And user "Alice" has uploaded file "filesForUpload/new-lorem.txt" to "/text1.txt"
    And user "Alice" has uploaded file "filesForUpload/lorem-big.txt" to "/text.txt"
    And user "Alice" has uploaded file "filesForUpload/new-lorem-big.txt" to "/text1.txt"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity number 1 should have message "You changed text1.txt and text.txt" in the activity page
    And the activity number 2 should contain message "You created text1.txt, text.txt" in the activity page
    Examples:
      | filter            |
      | All Activities    |
      | Activities by you |
    # Favorites shows the same as 'All Activities'. Remove after fix.
      | Favorites         |

  @issue-622
  Scenario Outline: Changing multiple file contents should not be shown in activity list for following filters
    Given user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/text.txt"
    And user "Alice" has uploaded file "filesForUpload/new-lorem.txt" to "/text1.txt"
    And user "Alice" has uploaded file "filesForUpload/lorem-big.txt" to "/text.txt"
    And user "Alice" has uploaded file "filesForUpload/new-lorem-big.txt" to "/text1.txt"
    When the user browses to the activity page
    And the user filters activity list by "<filter>"
    Then the activity should not have any message with keyword "text1.txt"
    And the activity should not have any message with keyword "text.txt"
    Examples:
      | filter               |
      | Shares               |
      | Comments             |
      | Activities by others |
      # Favorites shows the same as 'All Activities'. Uncomment after the fix
      #| Favorites            |

  
  Scenario: Changing multiple files in different order should be shown in activity list in the way it happens
    Given user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/text.txt"
    And user "Alice" has uploaded file "filesForUpload/lorem-big.txt" to "/text.txt"
    And user "Alice" has uploaded file "filesForUpload/new-lorem.txt" to "/text1.txt"
    And user "Alice" has uploaded file "filesForUpload/new-lorem-big.txt" to "/text1.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You changed text1.txt" in the activity page
    And the activity number 2 should have message "You created text1.txt" in the activity page
    And the activity number 3 should have message "You changed text.txt" in the activity page
    And the activity number 4 should contain message "You created text.txt" in the activity page

  
  Scenario: Changing contents of file inside folder should be shown in activity list
    Given user "Alice" has created folder "doc"
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/doc/text.txt"
    And user "Alice" has uploaded file "filesForUpload/lorem-big.txt" to "/doc/text.txt"
    And user "Alice" has uploaded file "filesForUpload/new-lorem.txt" to "/doc/text1.txt"
    And user "Alice" has uploaded file "filesForUpload/new-lorem-big.txt" to "/doc/text1.txt"
    When the user browses to the activity page
    Then the activity number 1 should have message "You changed text1.txt" in the activity page
    And the activity number 2 should have message "You created text1.txt" in the activity page
    And the activity number 3 should have message "You changed text.txt" in the activity page
    And the activity number 4 should contain message "You created text.txt, doc" in the activity page

  
  Scenario: Changing file contents should not be listed in the activity list stream when file changed activity has been disabled
    Given user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/text.txt"
    And user "Alice" has uploaded file "filesForUpload/lorem-big.txt" to "/text.txt"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_changed" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "changed"

  
  Scenario: Changing contents of file should be shown in the activity tab
    Given user "Alice" has created folder "doc"
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/doc/text.txt"
    And user "Alice" has uploaded file "filesForUpload/lorem-big.txt" to "/doc/text.txt"
    When the user browses directly to display the details of file "/doc/text.txt" in folder "/"
    Then the activity number 1 should have message "You changed text.txt" in the activity tab
    And the activity number 2 should have message "You created text.txt" in the activity tab
