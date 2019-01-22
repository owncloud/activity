@webUI @insulated @disablePreviews
Feature: Created files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have created
  So that I know what happened in my cloud storage

  Background:
    Given user "user0" has been created with default attributes and without skeleton files

  Scenario: Creating new file should be listed in the activity list
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text.txt"
    When user "user0" browses to the activity page
    Then the activity number 1 should contain message "You created text.txt" in the activity page

  Scenario: Creating new folder should be listed in the activity list
    Given user "user0" has created folder "Docs"
    When user "user0" browses to the activity page
    Then the activity number 1 should contain message "You created Docs" in the activity page

  Scenario: Creating multiple files should be listed in the activity list
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text1.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text2.txt"
    When user "user0" browses to the activity page
    Then the activity number 1 should contain message "You created text2.txt, text1.txt, text.txt" in the activity page

  Scenario: Creating multiple files should be listed in the activity list with contracted list
    Given user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text1.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text2.txt"
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "/text3.txt"
    When user "user0" browses to the activity page
    Then the activity number 1 should contain message "You created text3.txt, text2.txt, text1.txt" in the activity page

  Scenario: Creating multiple folders should be listed in the activity list
    Given user "user0" has created folder "Doc1"
    And user "user0" has created folder "Doc2"
    And user "user0" has created folder "Doc3"
    When user "user0" browses to the activity page
    Then the activity number 1 should contain message "You created Doc3, Doc2, Doc1" in the activity page

  Scenario: Creating multiple folders should be listed in the activity list with contracted list
    Given user "user0" has created folder "Doc1"
    And user "user0" has created folder "Doc2"
    And user "user0" has created folder "Doc3"
    And user "user0" has created folder "Doc4"
    When user "user0" browses to the activity page
    Then the activity number 1 should contain message "You created Doc4, Doc3, Doc2" in the activity page

  Scenario: Creating multiple folders and files should be listed in activity list
    Given user "user0" has created folder "doc"
    And user "user0" has uploaded file "filesForUpload/lorem.txt" to "/doc/text1.txt"
    And user "user0" has created folder "doc/nested"
    When user "user0" browses to the activity page
    Then the activity number 1 should contain message "You created nested, text1.txt, doc" in the activity page