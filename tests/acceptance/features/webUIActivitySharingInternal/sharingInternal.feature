@webUI @insulated @disablePreviews
Feature: Sharing file/folders activities
  As a user
  I want to be able to see history of the files and folders that I have shared or received as share
  So that I know what happened in my cloud storage

  Background:
    Given user "Alice" has been created with default attributes and skeleton files

  Scenario: Sharing a file/folder with a user should be listed in the activity list of a sharer
    Given these users have been created with default attributes and skeleton files but not initialized:
      | username |
      | Brian    |
      | Carol    |
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Alice" has shared folder "folder with space" with user "Carol"
    And user "Alice" has shared file "simple-folder/lorem.txt" with user "Brian"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with user "Carol"
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "Carol King"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "Brian Murphy"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "Carol King"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "Brian Murphy"
    When the user filters activity list by "Activities by you"
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "Carol King"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "Brian Murphy"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "Carol King"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "Brian Murphy"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "Carol King"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "Brian Murphy"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "Carol King"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "Brian Murphy"

  Scenario: Sharing a file/folder with a group should be listed in the activity list of a sharer
    Given group "grp1" has been created
    And group "grp2" has been created
    And user "Alice" has shared file "textfile0.txt" with group "grp1"
    And user "Alice" has shared folder "folder with space" with group "grp2"
    And user "Alice" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with group "grp2"
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should contain message "You shared simple-empty-folder with group grp2" in the activity page
    And the activity number 2 should contain message "You shared lorem.txt with group grp1" in the activity page
    And the activity number 3 should contain message "You shared folder with space with group grp2" in the activity page
    And the activity number 4 should contain message "You shared textfile0.txt with group grp1" in the activity page
    When the user filters activity list by "Activities by you"
    Then the activity number 1 should contain message "You shared simple-empty-folder with group grp2" in the activity page
    And the activity number 2 should contain message "You shared lorem.txt with group grp1" in the activity page
    And the activity number 3 should contain message "You shared folder with space with group grp2" in the activity page
    And the activity number 4 should contain message "You shared textfile0.txt with group grp1" in the activity page
    When the user filters activity list by "Shares"
    Then the activity number 1 should contain message "You shared simple-empty-folder with group grp2" in the activity page
    And the activity number 2 should contain message "You shared lorem.txt with group grp1" in the activity page
    And the activity number 3 should contain message "You shared folder with space with group grp2" in the activity page
    And the activity number 4 should contain message "You shared textfile0.txt with group grp1" in the activity page

  Scenario: Sharing a file/folder with a user should be listed in the activity list of a sharee
    Given user "Brian" has been created with default attributes and skeleton files
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Alice" has shared folder "folder with space" with user "Brian"
    And user "Alice" has shared file "simple-folder/lorem.txt" with user "Brian"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you
    When the user filters activity list by "Activities by you"
    Then the activity should not have any message with keyword "shared"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that user "Alice Hansen" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you

  Scenario: Sharing a file/folder with a group should be listed in the activity list of a sharee
    Given user "Brian" has been created with default attributes and skeleton files
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has shared file "textfile0.txt" with group "grp1"
    And user "Alice" has shared folder "folder with space" with group "grp1"
    And user "Alice" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with group "grp1"
    And user "Brian" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you
    When the user filters activity list by "Activities by you"
    Then the activity should not have any message with keyword "shared"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that user "Alice Hansen" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you

  Scenario: Sharing a file/folder with a user should not be listed in the activity list stream when shared activity has been disabled
    Given these users have been created with default attributes and skeleton files but not initialized:
      | username |
      | Brian    |
      | Carol    |
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Alice" has shared folder "folder with space" with user "Carol"
    And user "Alice" has shared file "simple-folder/lorem.txt" with user "Brian"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with user "Carol"
    And user "Alice" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Sharing a file/folder with a group should not be listed in the activity list stream when shared activity has been disabled
    Given group "grp1" has been created
    And group "grp2" has been created
    And user "Alice" has shared file "textfile0.txt" with group "grp1"
    And user "Alice" has shared folder "folder with space" with group "grp2"
    And user "Alice" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with group "grp2"
    And user "Alice" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Receiving a file/folder from a sharer should not be listed in the activity list stream when shared activity has been disabled
    Given user "Brian" has been created with default attributes and skeleton files
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Alice" has shared folder "folder with space" with user "Brian"
    And user "Alice" has shared file "simple-folder/lorem.txt" with user "Brian"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Receiving a file/folder in a group as a share should not be listed in the activity list stream when shared activity has been disabled
    Given user "Brian" has been created with default attributes and skeleton files
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has shared file "textfile0.txt" with group "grp1"
    And user "Alice" has shared folder "folder with space" with group "grp1"
    And user "Alice" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "Alice" has shared folder "simple-folder/simple-empty-folder" with group "grp1"
    And user "Brian" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Uploading a file inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Alice" has logged in using the webUI
    And user "Brian" has uploaded file "filesForUpload/textfile.txt" to "simple-folder/textfilemoved.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Brian Murphy" created "textfilemoved.txt"

  Scenario: Creating a folder inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Alice" has logged in using the webUI
    And user "Brian" has created folder "simple-folder/newFolder"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Brian Murphy" created "newFolder"

  Scenario: Uploading a file inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "Brian" has been created with default attributes and skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Alice" has uploaded file "filesForUpload/textfile.txt" to "simple-folder/textfilemoved.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" created "textfilemoved.txt"

  Scenario: Creating a folder inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "Brian" has been created with default attributes and skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Alice" has created folder "simple-folder/newFolder"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" created "newFolder"

  Scenario: Deleting a file inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Alice" has logged in using the webUI
    And user "Brian" has deleted file "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Brian Murphy" deleted "lorem.txt"

  Scenario: Deleting a folder inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Alice" has logged in using the webUI
    And user "Brian" has deleted folder "simple-folder/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Brian Murphy" deleted "simple-empty-folder"

  Scenario: Deleting a file inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "Brian" has been created with default attributes and skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Alice" has deleted file "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" deleted "lorem.txt"

  Scenario: Deleting a folder inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "Brian" has been created with default attributes and skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Alice" has deleted folder "simple-folder/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" deleted "simple-empty-folder"

  Scenario: Changing a shared file by a sharee should be listed in the activity list of a sharer
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared file "lorem.txt" with user "Brian"
    And user "Alice" has logged in using the webUI
    And user "Brian" has uploaded file "filesForUpload/new-lorem-big.txt" to "lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Brian Murphy" changed "lorem.txt"

  Scenario: Changing a file inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Alice" has logged in using the webUI
    And user "Brian" has uploaded file "filesForUpload/new-lorem-big.txt" to "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Brian Murphy" changed "lorem.txt"

  Scenario: Changing a shared file by a sharer should be listed in the activity list of a sharee
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared file "lorem.txt" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Alice" has uploaded file "filesForUpload/new-lorem-big.txt" to "lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" changed "lorem.txt"

  Scenario: Changing a file inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "Brian" has been created with default attributes and skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Alice" has uploaded file "filesForUpload/new-lorem-big.txt" to "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" changed "lorem.txt"

  Scenario: Creating a folder inside a shared folder by a sharer should be listed in the activity list of a sharee even after the sharee has unshared the share
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Alice" has created folder "simple-folder/newFolder"
    And user "Brian" has declined share "/simple-folder" offered by user "Alice"
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Alice Hansen" created "newFolder"

  Scenario: Creating a folder inside a shared folder by a sharee should be listed in the activity list of a sharer even after the sharee has unshared the share
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Alice" has logged in using the webUI
    And user "Brian" has created folder "simple-folder/newFolder"
    And user "Brian" has declined share "/simple-folder" offered by user "Alice"
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that user "Brian Murphy" created "newFolder"

  Scenario: Deleting a share by a sharer should be listed in the activity list of the sharee
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Alice" has deleted the last share
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that "Alice Hansen" removed the share for "simple-folder"

  Scenario: Deleting a share by a sharer should be listed in the activity list of the sharer
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared folder "simple-folder" with user "Brian"
    And user "Alice" has logged in using the webUI
    And user "Alice" has deleted the last share
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that you removed the share of "Brian Murphy" for "simple-folder"

  @issue-752 @skipOnOcV10.2
  Scenario: Sharer and sharee check activity after sharee unshares a shared file
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Brian    |
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Brian" has logged in using the webUI
    And user "Brian" has unshared file "textfile0.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that you have unshared file "textfile0.txt" shared by "Alice Hansen" from self
    And the activity number 2 should contain message "Alice Hansen shared textfile0.txt with you" in the activity page
    When the user re-logs in as "Alice" using the webUI
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared file "textfile0.txt" with user "Brian Murphy"

  Scenario: Sharing a file/folder with a user should be listed in the activity tab of the sharer for the file
    Given these users have been created with default attributes and skeleton files but not initialized:
      | username |
      | Brian    |
      | Carol    |
    And user "Alice" has shared file "block-aligned.txt" with user "Brian"
    And user "Alice" has shared folder "folder with space" with user "Carol"
    And user "Alice" has logged in using the webUI
    When the user browses directly to display the details of file "block-aligned.txt" in folder "/"
    Then the activity number 1 should have message saying that the file is shared with user "Brian Murphy" in the activity tab
    And the activity number 2 should contain message "You created block-aligned.txt" in the activity tab
    When the user opens the file action menu of folder "folder with space" on the webui
    And the user clicks the details file action on the webui
    Then the activity number 1 should have message saying that the folder is shared with user "Carol King" in the activity tab
    And the activity number 2 should contain message "You created folder with space" in the activity tab

  Scenario: Sharing a file/folder with a user should be listed in the activity tab of the sharee for the file
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has shared file "block-aligned.txt" with user "Brian"
    And user "Alice" has shared folder "folder with space" with user "Brian"
    And user "Brian" has logged in using the webUI
    When the user browses directly to display the details of file "block-aligned.txt" in folder "/"
    Then the activity number 1 should have message saying that the file is shared by user "Alice Hansen" in the activity tab
    When the user opens the file action menu of folder "folder with space" on the webui
    And the user clicks the details file action on the webui
    Then the activity number 1 should have message saying that the folder is shared by user "Alice Hansen" in the activity tab

  @issue-695
  Scenario: Sharing a file with a user should be listed in the activity list of a sharer
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Alice" has shared file "textfile0.txt" with user "Carol"
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared file "textfile0.txt" with user "Carol King"
    #remove the above step when issue is fixed
    #Then the activity number 1 should contain message "You shared textfile0.txt with Alice Hansen and Carol King" in the activity page

  Scenario: users checks a group related activity after deleting the group
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Brian    |
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Alice" has shared file "textfile0.txt" with group "grp1"
    And group "grp1" has been deleted
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should contain message "You shared textfile0.txt with group grp1" in the activity page

  Scenario: users checks a user related activity after deleting the user
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Brian    |
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    And user "Brian" has been deleted
    And user "Alice" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared file "textfile0.txt" with user "Brian"