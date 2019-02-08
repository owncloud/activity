@webUI @insulated @disablePreviews
Feature: Created files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have created
  So that I know what happened in my cloud storage

  Background:
    Given user "user0" has been created with default attributes and without skeleton files
    And user "user0" has logged in using the webUI

  Scenario: Creating new file should be listed in the activity list
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text.txt"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created text.txt" in the activity page

  Scenario: Creating new folder should be listed in the activity list
    Given user "user0" has created folder "Docs"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created Docs" in the activity page

  Scenario: Creating multiple files should be listed in the activity list
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text1.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text2.txt"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created text2.txt, text1.txt, text.txt" in the activity page

  Scenario: Creating multiple files should be listed in the activity list with contracted list
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text1.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text2.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text3.txt"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created text3.txt, text2.txt, text1.txt" in the activity page

  Scenario: Creating multiple folders should be listed in the activity list
    Given user "user0" has created folder "Doc1"
    And user "user0" has created folder "Doc2"
    And user "user0" has created folder "Doc3"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created Doc3, Doc2, Doc1" in the activity page

  Scenario: Uploading new file using async should register in the activity list
    Given the administrator has enabled async operations
    And using new DAV path
    And user "user0" has uploaded the following chunks asynchronously to "/text.txt" with new chunking
      | 1 | AAAAA |
      | 2 | BBBBB |
      | 3 | CCCCC |
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created text.txt" in the activity page

  Scenario: Uploading new files using all mechanisms should be listed in the activity list
    When user "user0" uploads file "filesForUpload/textfile.txt" to filenames based on "/text.txt" with all mechanisms using the WebDAV API
    And the user browses to the activity page
    Then the activity number 1 should contain message "You created text.txt-newdav-newchunking, text.txt-newdav-regular, text.txt-olddav-oldchunking" in the activity page

  Scenario: Creating multiple folders should be listed in the activity list with contracted list
    Given user "user0" has created folder "Doc1"
    And user "user0" has created folder "Doc2"
    And user "user0" has created folder "Doc3"
    And user "user0" has created folder "Doc4"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created Doc4, Doc3, Doc2" in the activity page

  Scenario: Creating multiple folders and files should be listed in activity list
    Given user "user0" has created folder "doc"
    And user "user0" has uploaded file "filesForUpload/lorem.txt" to "/doc/text1.txt"
    And user "user0" has created folder "doc/nested"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created nested, text1.txt, doc" in the activity page

  Scenario: Creating files inside folder should be listed in the activity list
    Given user "user0" has created folder "doc"
    And user "user0" has uploaded file "filesForUpload/lorem.txt" to "/doc/text1.txt"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You created text1.txt, doc" in the activity page

  Scenario: Copying files should be shown in activity log
    Given user "user0" has uploaded file "filesForUpload/lorem.txt" to "/text1.txt"
    And user "user0" has copied file "/text1.txt" to "/text2.txt"
    When the user browses to the activity page
    And the activity number 1 should contain message "You created text2.txt, text1.txt" in the activity page

  Scenario: Copying folder should be shown in activity log as created
    Given user "user0" has created folder "doc"
    And user "user0" has copied file "/doc" to "/doc2"
    When the user browses to the activity page
    And the activity number 1 should contain message "You created doc2, doc" in the activity page

  Scenario: Copying files to another folder should be shown in log
    Given user "user0" has created folder "doc"
    And user "user0" has uploaded file "filesForUpload/lorem-big.txt" to "/text.txt"
    And user "user0" has copied file "/text.txt" to "/doc/text.txt"
    When the user browses to the activity page
    And the activity number 1 should contain message "You created text.txt, text.txt, doc" in the activity page

  Scenario: Creating new file should not be listed in the activity list when file creation activity has been disabled
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text.txt"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity list should be empty

  Scenario: Creating new folder should not be listed in the activity list when file creation activity has been disabled
    Given user "user0" has created folder "Docs"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity list should be empty

  Scenario: Uploading new file using async should not be listed in the activity list when file creation activity has been disabled
    Given the administrator has enabled async operations
    And using new DAV path
    And user "user0" has uploaded the following chunks asynchronously to "/text.txt" with new chunking
      | 1 | AAAAA |
      | 2 | BBBBB |
      | 3 | CCCCC |
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity list should be empty

  Scenario: Uploading new files using all mechanisms should not be listed in the activity list when file created activity has been disabled
    Given the user has browsed to the personal general settings page
    When user "user0" uploads file "filesForUpload/textfile.txt" to filenames based on "/text.txt" with all mechanisms using the WebDAV API
    And the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity list should be empty

  Scenario: Creating files inside folder should not be listed in the activity list stream when file created activity has been disabled
    Given user "user0" has created folder "doc"
    And user "user0" has uploaded file "filesForUpload/lorem.txt" to "/doc/text1.txt"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity list should be empty

  Scenario: Copying files should not be listed in the activity list stream when file created activity has been disabled
    Given user "user0" has uploaded file "filesForUpload/lorem.txt" to "/text1.txt"
    And user "user0" has copied file "/text1.txt" to "/text2.txt"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity list should be empty

  Scenario: Copying folder should not be listed in the activity list stream when file created activity has been disabled
    Given user "user0" has created folder "doc"
    And user "user0" has copied file "/doc" to "/doc2"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity list should be empty

  Scenario: Copying files to another folder should not be listed in the activity list stream when file created activity has been disabled
    Given user "user0" has created folder "doc"
    And user "user0" has uploaded file "filesForUpload/lorem-big.txt" to "/text.txt"
    And user "user0" has copied file "/text.txt" to "/doc/text.txt"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "file_created" using the webUI
    And the user browses to the activity page
    Then the activity list should be empty
