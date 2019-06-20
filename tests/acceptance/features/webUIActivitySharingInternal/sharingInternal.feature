@webUI @insulated @disablePreviews
Feature: Sharing file/folders activities
  As a user
  I want to be able to see history of the files and folders that I have shared or received as share
  So that I know what happened in my cloud storage

  Background:
    Given user "user0" has been created with default attributes and skeleton files

  Scenario: Sharing a file/folder with a user should be listed in the activity list of a sharer
    Given these users have been created with default attributes and skeleton files but not initialized:
      | username |
      | user1    |
      | user2    |
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user2"
    And user "user0" has shared file "simple-folder/lorem.txt" with user "user1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with user "user2"
    And user "user0" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "User Two"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "User One"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "User Two"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "User One"
    When the user filters activity list by "Activities by you"
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "User Two"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "User One"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "User Two"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "User One"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that you have shared folder "simple-empty-folder" with user "User Two"
    And the activity number 2 should have a message saying that you have shared file "lorem.txt" with user "User One"
    And the activity number 3 should have a message saying that you have shared folder "folder with space" with user "User Two"
    And the activity number 4 should have a message saying that you have shared file "textfile0.txt" with user "User One"

  Scenario: Sharing a file/folder with a group should be listed in the activity list of a sharer
    Given group "grp1" has been created
    And group "grp2" has been created
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And user "user0" has shared folder "folder with space" with group "grp2"
    And user "user0" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "grp2"
    And user "user0" has logged in using the webUI
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
    Given user "user1" has been created with default attributes and skeleton files
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user1"
    And user "user0" has shared file "simple-folder/lorem.txt" with user "user1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with user "user1"
    And user "user1" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you
    When the user filters activity list by "Activities by you"
    Then the activity should not have any message with keyword "shared"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that user "User Zero" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you

  Scenario: Sharing a file/folder with a group should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes and skeleton files
    And group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And user "user0" has shared folder "folder with space" with group "grp1"
    And user "user0" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "grp1"
    And user "user1" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you
    When the user filters activity list by "Activities by you"
    Then the activity should not have any message with keyword "shared"
    When the user filters activity list by "Shares"
    Then the activity number 1 should have a message saying that user "User Zero" has shared "simple-empty-folder, lorem.txt, folder with space and textfile0.txt" with you

  Scenario: Sharing a file/folder with a user should not be listed in the activity list stream when shared activity has been disabled
    Given these users have been created with default attributes and skeleton files but not initialized:
      | username |
      | user1    |
      | user2    |
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user2"
    And user "user0" has shared file "simple-folder/lorem.txt" with user "user1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with user "user2"
    And user "user0" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Sharing a file/folder with a group should not be listed in the activity list stream when shared activity has been disabled
    Given group "grp1" has been created
    And group "grp2" has been created
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And user "user0" has shared folder "folder with space" with group "grp2"
    And user "user0" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "grp2"
    And user "user0" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Receiving a file/folder from a sharer should not be listed in the activity list stream when shared activity has been disabled
    Given user "user1" has been created with default attributes and skeleton files
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user1"
    And user "user0" has shared file "simple-folder/lorem.txt" with user "user1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Receiving a file/folder in a group as a share should not be listed in the activity list stream when shared activity has been disabled
    Given user "user1" has been created with default attributes and skeleton files
    And group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And user "user0" has shared folder "folder with space" with group "grp1"
    And user "user0" has shared file "simple-folder/lorem.txt" with group "grp1"
    And user "user0" has shared folder "simple-folder/simple-empty-folder" with group "grp1"
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal general settings page
    When the user disables activity log stream for "shared" using the webUI
    And the user browses to the activity page
    Then the activity should not have any message with keyword "shared"

  Scenario: Uploading a file inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user1" has uploaded file "filesForUpload/textfile.txt" to "simple-folder/textfilemoved.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User One" created "textfilemoved.txt"

  Scenario: Creating a folder inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user1" has created folder "simple-folder/newFolder"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User One" created "newFolder"

  Scenario: Uploading a file inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes and skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user0" has uploaded file "filesForUpload/textfile.txt" to "simple-folder/textfilemoved.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" created "textfilemoved.txt"

  Scenario: Creating a folder inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes and skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user0" has created folder "simple-folder/newFolder"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" created "newFolder"

  Scenario: Deleting a file inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user1" has deleted file "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User One" deleted "lorem.txt"

  Scenario: Deleting a folder inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user1" has deleted folder "simple-folder/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User One" deleted "simple-empty-folder"

  Scenario: Deleting a file inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes and skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user0" has deleted file "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" deleted "lorem.txt"

  Scenario: Deleting a folder inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes and skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user0" has deleted folder "simple-folder/simple-empty-folder"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" deleted "simple-empty-folder"

  Scenario: Changing a shared file by a sharee should be listed in the activity list of a sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared file "lorem.txt" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user1" has uploaded file "filesForUpload/new-lorem-big.txt" to "lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User One" changed "lorem.txt"

  Scenario: Changing a file inside a shared folder by a sharee should be listed in the activity list of a sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user1" has uploaded file "filesForUpload/new-lorem-big.txt" to "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User One" changed "lorem.txt"

  Scenario: Changing a shared file by a sharer should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared file "lorem.txt" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user0" has uploaded file "filesForUpload/new-lorem-big.txt" to "lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" changed "lorem.txt"

  Scenario: Changing a file inside a shared folder by a sharer should be listed in the activity list of a sharee
    Given user "user1" has been created with default attributes and skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user0" has uploaded file "filesForUpload/new-lorem-big.txt" to "simple-folder/lorem.txt"
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" changed "lorem.txt"

  Scenario: Creating a folder inside a shared folder by a sharer should be listed in the activity list of a sharee even after the sharee has unshared the share
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user0" has created folder "simple-folder/newFolder"
    And user "user1" has declined the share "/simple-folder" offered by user "user0"
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User Zero" created "newFolder"

  Scenario: Creating a folder inside a shared folder by a sharee should be listed in the activity list of a sharer even after the sharee has unshared the share
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user1" has created folder "simple-folder/newFolder"
    And user "user1" has declined the share "/simple-folder" offered by user "user0"
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that user "User One" created "newFolder"

  Scenario: Deleting a share by a sharer should be listed in the activity list of the sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user0" has deleted the last share
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that "User Zero" removed the share for "simple-folder"

  Scenario: Deleting a share by a sharer should be listed in the activity list of the sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user0" has deleted the last share
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that you removed the share of "User One" for "simple-folder"

  Scenario: Deleting a share by a sharee should be listed in the activity list of the sharee
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user1" has logged in using the webUI
    And user "user1" has deleted the last share
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that "User One" removed the share for "simple-folder"

  Scenario: Deleting a share by a sharee should be listed in the activity list of the sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared folder "simple-folder" with user "user1"
    And user "user0" has logged in using the webUI
    And user "user1" has deleted the last share
    And the user browses to the activity page
    Then the activity number 1 should have a message saying that "User One" removed the share of "User One" for "simple-folder"
  Scenario: Sharing a file/folder with a user should be listed in the activity tab of the sharer for the file
    Given these users have been created with default attributes and skeleton files but not initialized:
      | username |
      | user1    |
      | user2    |
    And user "user0" has shared file "block-aligned.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user2"
    And user "user0" has logged in using the webUI
    When the user browses directly to display the details of file "block-aligned.txt" in folder "/"
    Then the activity number 1 should have message saying that the file is shared with user "User One" in the activity tab
    And the activity number 2 should contain message "You created block-aligned.txt" in the activity tab
    When the user opens the file action menu of folder "folder with space" on the webui
    And the user clicks the details file action on the webui
    Then the activity number 1 should have message saying that the folder is shared with user "User Two" in the activity tab
    And the activity number 2 should contain message "You created folder with space" in the activity tab

  Scenario: Sharing a file/folder with a user should be listed in the activity tab of the sharee for the file
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user0" has shared file "block-aligned.txt" with user "user1"
    And user "user0" has shared folder "folder with space" with user "user1"
    And user "user1" has logged in using the webUI
    When the user browses directly to display the details of file "block-aligned.txt" in folder "/"
    Then the activity number 1 should have message saying that the file is shared by user "User Zero" in the activity tab
    When the user opens the file action menu of folder "folder with space" on the webui
    And the user clicks the details file action on the webui
    Then the activity number 1 should have message saying that the folder is shared by user "User Zero" in the activity tab

  @issue-695
  Scenario: Sharing a file with a user should be listed in the activity list of a sharer
    Given user "user1" has been created with default attributes and without skeleton files
    And user "user2" has been created with default attributes and without skeleton files
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user0" has shared file "textfile0.txt" with user "user2"
    And user "user0" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared file "textfile0.txt" with user "User Two"
    #remove the above step when issue is fixed
    #Then the activity number 1 should contain message "You shared textfile0.txt with User One and User Two" in the activity page

  Scenario: users checks a group related activity after deleting the group
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | user1    |
    And group "grp1" has been created
    And user "user0" has been added to group "grp1"
    And user "user1" has been added to group "grp1"
    And user "user0" has shared file "textfile0.txt" with group "grp1"
    And group "grp1" has been deleted
    And user "user0" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should contain message "You shared textfile0.txt with group grp1" in the activity page


  Scenario: users checks a user related activity after deleting the user
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | user1    |
    And user "user0" has shared file "textfile0.txt" with user "user1"
    And user "user1" has been deleted
    And user "user0" has logged in using the webUI
    When the user browses to the activity page
    Then the activity number 1 should have a message saying that you have shared file "textfile0.txt" with user "user1"