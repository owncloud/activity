@webUI @insulated @disablePreews
Feature: Moving file/folders activity
    As a user
    I want to be able to move files and folders that I have created
    So that I know what happened in my cloud storage

    Background:
        Given the administrator has added config key "enable_move_and_rename_activities" with value "yes" in app "activity"
        And user "Alice" has been created with default attributes and without skeleton files
        And user "Alice" has logged in using the webUI

    Scenario: moving a folder should be listed in the activity list
        Given user "Alice" has created the following folders
            | path    |
            | folder1 |
            | folder2 |
            | folder3 |
        When user "Alice" moves folder "/folder2" to "/folder1/folder3" using the WebDAV API
        And the user browses to the activity page
        Then the activity number 1 should contain message "You moved folder2 to folder1/folder3" in the activity page

    Scenario: renaming a folder should be listed in the activity list
        Given user "Alice" has created folder "New folder"
        When user "Alice" moves folder "New folder" to "newFolder" using the WebDAV API
        And the user browses to the activity page
        Then the activity number 1 should contain message "You renamed New folder to newFolder" in the activity page

