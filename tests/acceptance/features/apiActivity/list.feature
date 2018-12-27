@api
Feature: List activity
  As a user I want to be able to see the activity list
  So that I know what is happening with my files/folders

  Scenario: file deletion should be listed in the activity list
    Given user "user0" has been created with default attributes
    When user "user0" deletes file "textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "user0" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^user0$/             |
      | affecteduser     | /^user0$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/textfile0.txt$/   |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\.d\d+&view=trashbin\" id=\"\d+\">textfile0\.txt<\/file>$/ |

  Scenario: folder share should be listed in the activity list
    Given these users have been created with default attributes but not initialized:
      | username |
      | user0    |
      | user1    |
      | user2    |
    When user "user0" creates folder "/one" using the WebDAV API
    And user "user0" creates folder "/two" using the WebDAV API
    And user "user0" shares folder "/one" with user "user1" using the sharing API
    And user "user0" shares folder "/two" with user "user2" using the sharing API
    Then the activity number 1 of user "user0" should match these properties:
      | type             | /^shared$/           |
      | user             | /^user0$/            |
      | affecteduser     | /^user0$/            |
      | app              | /^files_sharing$/    |
      | subject          | /^shared_user_self$/ |
      | object_name      | /^\/two$/            |
      | object_type      | /^files$/            |
      | typeicon         | /^icon-share$/       |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/two\" id=\"\d+\">two<\/file> with <user display-name=\"User Two\">user2<\/user>$/|
    And the activity number 2 of user "user0" should match these properties:
      | type             | /^shared$/           |
      | user             | /^user0$/            |
      | affecteduser     | /^user0$/            |
      | app              | /^files_sharing$/    |
      | subject          | /^shared_user_self$/ |
      | object_name      | /^\/one$/            |
      | object_type      | /^files$/            |
      | typeicon         | /^icon-share$/       |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/one\" id=\"\d+\">one<\/file> with <user display-name=\"User One\">user1<\/user>$/|
