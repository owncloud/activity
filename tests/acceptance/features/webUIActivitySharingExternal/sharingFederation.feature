@webUI @insulated @disablePreviews
Feature: federation sharing file/folder activities
  As a user
  I want to be able to see history of the files and folders shared externally
  So that I know what happened in my cloud storage

  Background:
    Given using server "REMOTE"
    And user "user2" has been created with default attributes
    And using server "LOCAL"
    And user "user1" has been created with default attributes
    And user "user1" has logged in using the webUI

  Scenario: Sharing a folder with a remote server should not be listed in the activity list of a sharer if the sharee has not accepted the share
    Given user "user1" from server "LOCAL" has shared "simple-folder" with user "user2" from server "REMOTE"
    When the user browses to the activity page
    Then the activity should not have any message with keyword "remote share"

  Scenario: Sharing a folder with a remote server should be listed in the activity list of a sharer
    Given user "user1" from server "LOCAL" has shared "simple-folder" with user "user2" from server "REMOTE"
    When user "user2" from server "REMOTE" accepts the last pending share using the sharing API
    And the user browses to the activity page
    Then the activity number 1 should contain message "user2@… accepted remote share simple-folder" in the activity page

  Scenario: Sharing a file with a remote server should be listed in the activity list of a sharer
    Given user "user1" from server "LOCAL" has shared "textfile0.txt" with user "user2" from server "REMOTE"
    When user "user2" from server "REMOTE" accepts the last pending share using the sharing API
    And the user browses to the activity page
    Then the activity number 1 should contain message "user2@… accepted remote share textfile0.txt" in the activity page

  Scenario: Sharing a file/folder with a remote server should be listed in the activity list of a sharee eventhough they have not accepted the share
    Given user "user2" from server "REMOTE" has shared "textfile0.txt" with user "user1" from server "LOCAL"
    And user "user2" from server "REMOTE" has shared "simple-folder" with user "user1" from server "LOCAL"
    When the user browses to the activity page
    Then the activity number 1 should contain message "You received a new remote share simple-folder from user2@…" in the activity page
    And the activity number 2 should contain message "You received a new remote share textfile0.txt from user2@…" in the activity page

  Scenario: remote sharee does not get new activity message after accepting the pending share
    Given user "user2" from server "REMOTE" has shared "textfile0.txt" with user "user1" from server "LOCAL"
    When user "user1" from server "LOCAL" accepts the last pending share using the sharing API
    And the user browses to the activity page
    Then the activity number 1 should contain message "You received a new remote share textfile0.txt from user2@…" in the activity page

  Scenario: Sharing a folder with a remote server should not be listed in the activity list stream when remote share activity has been disabled
    Given user "user1" from server "LOCAL" has shared "simple-folder" with user "user2" from server "REMOTE"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "remote_share" using the webUI
    And user "user2" from server "REMOTE" accepts the last pending share using the sharing API
    And the user browses to the activity page
    Then the activity should not have any message with keyword "remote share"

  Scenario: Sharing a file with a remote server should not be listed in the activity list stream when remote share activity has been disabled
    Given user "user1" from server "LOCAL" has shared "textfile0.txt" with user "user2" from server "REMOTE"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "remote_share" using the webUI
    And user "user2" from server "REMOTE" accepts the last pending share using the sharing API
    And the user browses to the activity page
    Then the activity should not have any message with keyword "remote share"

  Scenario: Receiving a file/folder from a remote server should not be listed in the activity list stream when remote share activity has been disabled
    Given user "user2" from server "REMOTE" has shared "textfile0.txt" with user "user1" from server "LOCAL"
    And user "user2" from server "REMOTE" has shared "simple-folder" with user "user1" from server "LOCAL"
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "remote_share" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "remote share"