@webUI @insulated @disablePreviews
Feature: Tag files/folders activities
  As a user
  I want to be able to see history of the files and folders that I have tagged
  So that I know what happened in my cloud storage

  Scenario Outline: Adding a tag on a file/folder should be listed on the activity list
    Given user "user0" has been created with default attributes
    And user "user0" has created a "normal" tag with name "lorem"
    # <filepath> already has an ending slash('/')
    And user "user0" has added tag "lorem" to file "<filepath><filename>"
    When user "user0" browses to the activity page
    Then the activity number 1 should contain message "You assigned system tag lorem to <filename>" in the activity page
    Examples:
      | filepath                            | filename            |
      | /                                   | lorem.txt           |
      | simple-folder/                      | testapp.zip         |
      | /                                   | 0                   |
      | 'single'quotes/                     | simple-empty-folder |
      | 0/                                  | lorem.txt           |
      | 'single'quotes/simple-empty-folder/ | for-git-commit      |
