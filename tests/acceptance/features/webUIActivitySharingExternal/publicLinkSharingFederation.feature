@webUI @insulated @disablePreviews
Feature: public link federation sharing file/folder activities
  As a user
  I want to be able to see history of the files and folders shared externally
  So that I know what happened in my cloud storage

  @issue-800
  Scenario: adding a server to the public link does not show activity for the receiver
    Given using server "REMOTE"
    And user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file with content "ownCloud test text file 0" to "/textfile0.txt"
    And user "Alice" has created a public link share of file "textfile0.txt"
    And using server "LOCAL"
    And user "Brian" has been created with default attributes and without skeleton files
    And the public has accessed the last created public link using the webUI
    When the public adds the public link to "%local_server%" as user "Brian" using the webUI
    And the user accepts the offered federated shares using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"
    # remove the above step and use the following one after the issue has been resolved, might need some refactor
    # And the activity number 1 should contain message "You received a new federated share textfile0.txt from Alice@…" in the activity page
