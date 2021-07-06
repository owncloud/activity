@api
Feature: List activity
  As a user I want to be able to see the activity list
  So that I know what is happening with my files/folders

  Scenario: file deletion should be listed in the activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes file "textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/textfile0.txt$/   |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\.d\d+&view=trashbin\" id=\"\d+\">textfile0\.txt<\/file>$/ |

  @skipOnOcV10.2
  Scenario: file restore should be listed in the activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted file "textfile0.txt"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the file with original path "textfile0.txt" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/   |
      | user             | /^Alice$/           |
      | affecteduser     | /^Alice$/           |
      | app              | /^files$/           |
      | subject          | /^restored_self$/   |
      | object_name      | /^\/textfile0.txt$/ |
      | object_type      | /^files$/           |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\" id=\"\d+\">textfile0\.txt<\/file>$/ |

  Scenario: folder deletion should be listed in the activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes folder "FOLDER" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/FOLDER$/          |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You abc <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\.d\d+&view=trashbin\" id=\"\d+\">FOLDER<\/file>$/ |

  @skipOnOcV10.2
  Scenario: folder restore should be listed in the activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted folder "FOLDER"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the folder with original path "FOLDER" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/ |
      | user             | /^Alice$/         |
      | affecteduser     | /^Alice$/         |
      | app              | /^files$/         |
      | subject          | /^restored_self$/ |
      | object_name      | /^\/FOLDER$/      |
      | object_type      | /^files$/         |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\" id=\"\d+\">FOLDER<\/file>$/ |

  Scenario: file inside folder deletion should be listed in the activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes file "PARENT/parent.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/         |
      | user             | /^Alice$/                |
      | affecteduser     | /^Alice$/                |
      | app              | /^files$/                |
      | subject          | /^deleted_self$/         |
      | object_name      | /^\/PARENT\/parent.txt$/ |
      | object_type      | /^files$/                |
      | typeicon         | /^icon-delete-color$/    |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=parent\.txt\.d\d+&view=trashbin\" id=\"\d+\">PARENT\/parent.txt<\/file>$/ |

  @skipOnOcV10.2
  Scenario: file inside folder restore should be listed in the activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted file "PARENT/parent.txt"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the file with original path "PARENT/parent.txt" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/        |
      | user             | /^Alice$/                |
      | affecteduser     | /^Alice$/                |
      | app              | /^files$/                |
      | subject          | /^restored_self$/        |
      | object_name      | /^\/PARENT\/parent.txt$/ |
      | object_type      | /^files$/                |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT&scrollto=parent\.txt\" id=\"\d+\">PARENT\/parent\.txt<\/file>$/ |

  Scenario: sub folder deletion should be listed in the activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes folder "PARENT/CHILD" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/PARENT\/CHILD$/   |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/CHILD.d\d+&view=trashbin\" id=\"\d+\">PARENT\/CHILD<\/file>$/ |

  @skipOnOcV10.2
  Scenario: sub folder restore should be listed in the activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted folder "PARENT/CHILD"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the folder with original path "PARENT/CHILD" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/   |
      | user             | /^Alice$/           |
      | affecteduser     | /^Alice$/           |
      | app              | /^files$/           |
      | subject          | /^restored_self$/   |
      | object_name      | /^\/PARENT\/CHILD$/ |
      | object_type      | /^files$/           |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT\/CHILD" id=\"\d+\">PARENT\/CHILD<\/file>$/ |

  Scenario: multiple file deletion should be listed in activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes file "textfile0.txt" using the WebDAV API
    And user "Alice" deletes file "textfile1.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/textfile1\.txt$/  |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You deleted <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile1\.txt\.d\d+&view=trashbin\" id=\"\d+\">textfile1\.txt<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\.d\d+&view=trashbin\" id=\"\d+\">textfile0\.txt<\/file><\/collection>$/ |

  Scenario: multiple folder deletion should be listed in activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes folder "PARENT" using the WebDAV API
    And user "Alice" deletes folder "FOLDER" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/FOLDER$/          |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You deleted <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\.d\d+&view=trashbin\" id=\"\d+\">FOLDER<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT\.d\d+&view=trashbin\" id=\"\d+\">PARENT<\/file><\/collection>$/ |

  @skipOnOcV10.2
  Scenario: multiple file restore should be listed in activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted file "textfile0.txt"
    And user "Alice" has deleted file "textfile1.txt"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the file with original path "textfile0.txt" using the trashbin API
    And user "Alice" restores the file with original path "textfile1.txt" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/    |
      | user             | /^Alice$/            |
      | affecteduser     | /^Alice$/            |
      | app              | /^files$/            |
      | subject          | /^restored_self$/    |
      | object_name      | /^\/textfile1\.txt$/ |
      | object_type      | /^files$/            |
      | subject_prepared | /^You restored <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile1\.txt\" id=\"\d+\">textfile1\.txt<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\" id=\"\d+\">textfile0\.txt<\/file><\/collection>$/ |

  @skipOnOcV10.2
  Scenario: multiple folder restore should be listed in activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted folder "FOLDER"
    And user "Alice" has deleted folder "PARENT"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the folder with original path "FOLDER" using the trashbin API
    And user "Alice" restores the folder with original path "PARENT" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/ |
      | user             | /^Alice$/         |
      | affecteduser     | /^Alice$/         |
      | app              | /^files$/         |
      | subject          | /^restored_self$/ |
      | object_name      | /^\/PARENT$/      |
      | object_type      | /^files$/         |
      | subject_prepared | /^You restored <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT\" id=\"\d+\">PARENT<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\" id=\"\d+\">FOLDER<\/file><\/collection>$/ |

  Scenario: mix of folder and file deletion should be listed in activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes file "textfile0.txt" using the WebDAV API
    And user "Alice" deletes folder "FOLDER" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/FOLDER$/          |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You deleted <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\.d\d+&view=trashbin\" id=\"\d+\">FOLDER<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\.d\d+&view=trashbin\" id=\"\d+\">textfile0\.txt<\/file><\/collection>$/ |

  @skipOnOcV10.2
  Scenario: mix of folder and file restore should be listed in activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted file "textfile0.txt"
    And user "Alice" has deleted folder "FOLDER"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the file with original path "textfile0.txt" using the trashbin API
    And user "Alice" restores the folder with original path "FOLDER" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/ |
      | user             | /^Alice$/         |
      | affecteduser     | /^Alice$/         |
      | app              | /^files$/         |
      | subject          | /^restored_self$/ |
      | object_name      | /^\/FOLDER$/      |
      | object_type      | /^files$/         |
      | subject_prepared | /^You restored <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\" id=\"\d+\">FOLDER<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\" id=\"\d+\">textfile0\.txt<\/file><\/collection>$/ |

  @skipOnOcV10.2
  Scenario: folder share should be listed in the activity list
    Given these users have been created with default attributes and small skeleton files but not initialized:
      | username |
      | Alice    |
      | Brian    |
      | Carol    |
    When user "Alice" creates folder "/one" using the WebDAV API
    And user "Alice" creates folder "/two" using the WebDAV API
    And user "Alice" shares folder "/one" with user "Brian" using the sharing API
    And user "Alice" shares folder "/two" with user "Carol" using the sharing API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/           |
      | user             | /^Alice$/            |
      | affecteduser     | /^Alice$/            |
      | app              | /^files_sharing$/    |
      | subject          | /^shared_user_self$/ |
      | object_name      | /^\/two$/            |
      | object_type      | /^files$/            |
      | typeicon         | /^icon-shared$/      |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/two\" id=\"\d+\">two<\/file> with <user display-name=\"Carol King\">Carol<\/user>$/|
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/           |
      | user             | /^Alice$/            |
      | affecteduser     | /^Alice$/            |
      | app              | /^files_sharing$/    |
      | subject          | /^shared_user_self$/ |
      | object_name      | /^\/one$/            |
      | object_type      | /^files$/            |
      | typeicon         | /^icon-shared$/      |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/one\" id=\"\d+\">one<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/|

  Scenario: folder creation should be listed in the activity list
    Given user "Alice" has been created with default attributes and without skeleton files
    When user "Alice" creates folder "/one" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_created$/   |
      | user             | /^Alice$/          |
      | affecteduser     | /^Alice$/          |
      | app              | /^files$/          |
      | subject          | /^created_self$/   |
      | object_name      | /^\/one$/          |
      | object_type      | /^files$/          |
      | typeicon         | /^icon-add-color$/ |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^You created <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/one\" id=\"\d+\">one<\/file>/|

  Scenario: file upload should be listed in activity list
     Given user "Alice" has been created with default attributes and without skeleton files
     When user "Alice" uploads file "filesForUpload/textfile.txt" to "/text.txt" using the WebDAV API
     Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_created$/   |
      | user             | /^Alice$/          |
      | affecteduser     | /^Alice$/          |
      | app              | /^files$/          |
      | subject          | /^created_self$/   |
      | object_name      | /^\/text.txt$/     |
      | object_type      | /^files$/          |
      | typeicon         | /^icon-add-color$/ |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^You created <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=text.txt" id=\"\d+\">text.txt<\/file>/|

  @skipOnOcV10.2
  Scenario: different files share with different user should be listed in activity list of sharer
    Given user "Alice" has been created with default attributes and small skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    When user "Alice" shares file "PARENT/parent.txt" with user "Carol" using the sharing API
    And user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/           |
      | user             | /^Alice$/            |
      | affecteduser     | /^Alice$/            |
      | app              | /^files_sharing$/    |
      | subject          | /^shared_user_self$/ |
      | object_name      | /^\/textfile0.txt$/  |
      | object_type      | /^files$/            |
      | typeicon         | /^icon-shared$/      |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/|
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/               |
      | user             | /^Alice$/                |
      | affecteduser     | /^Alice$/                |
      | app              | /^files_sharing$/        |
      | subject          | /^shared_user_self$/     |
      | object_name      | /^\/PARENT\/parent.txt$/ |
      | object_type      | /^files$/                |
      | typeicon         | /^icon-shared$/          |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT$/ |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT&scrollto=parent.txt" id=\"\d+\">PARENT\/parent.txt<\/file> with <user display-name=\"Carol King\">Carol<\/user>$/|

  @skipOnOcV10.2
  Scenario: different files shared with same user should be listed in activity list of sharer
    Given user "Alice" has been created with default attributes and small skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    When user "Alice" shares file "PARENT/parent.txt" with user "Brian" using the sharing API
    And user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/           |
      | user             | /^Alice$/            |
      | affecteduser     | /^Alice$/            |
      | app              | /^files_sharing$/    |
      | subject          | /^shared_user_self$/ |
      | object_name      | /^\/textfile0.txt$/  |
      | object_type      | /^files$/            |
      | typeicon         | /^icon-shared$/      |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/|
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/               |
      | user             | /^Alice$/                |
      | affecteduser     | /^Alice$/                |
      | app              | /^files_sharing$/        |
      | subject          | /^shared_user_self$/     |
      | object_name      | /^\/PARENT\/parent.txt$/ |
      | object_type      | /^files$/                |
      | typeicon         | /^icon-shared$/          |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT$/ |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT&scrollto=parent.txt" id=\"\d+\">PARENT\/parent.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/|

  @skipOnOcV10.2
  Scenario: different files shared with different user should be listed in activity list of sharee
    Given user "Alice" has been created with default attributes and small skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    When user "Alice" shares file "PARENT/parent.txt" with user "Brian" using the sharing API
    And user "Alice" shares file "textfile0.txt" with user "Carol" using the sharing API
    Then the activity number 1 of user "Carol" should match these properties:
      | type             | /^shared$/          |
      | user             | /^Alice$/           |
      | affecteduser     | /^Carol$/           |
      | app              | /^files_sharing$/   |
      | subject          | /^shared_with_by$/  |
      | object_name      | /^\/textfile0.txt$/ |
      | object_type      | /^files$/           |
      | typeicon         | /^icon-shared$/     |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with you$/|
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/         |
      | user             | /^Alice$/          |
      | affecteduser     | /^Brian$/          |
      | app              | /^files_sharing$/  |
      | subject          | /^shared_with_by$/ |
      | object_name      | /^\/parent.txt$/   |
      | object_type      | /^files$/          |
      | typeicon         | /^icon-shared$/    |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=parent.txt" id=\"\d+\">parent.txt<\/file> with you$/|

  @skipOnOcV10.2
  Scenario: different files shared with same user should be listed in activity list of sharee
    Given user "Alice" has been created with default attributes and small skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    When user "Alice" shares file "PARENT/parent.txt" with user "Brian" using the sharing API
    And user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    Then the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/          |
      | user             | /^Alice$/           |
      | affecteduser     | /^Brian$/           |
      | app              | /^files_sharing$/   |
      | subject          | /^shared_with_by$/  |
      | object_name      | /^\/textfile0.txt$/ |
      | object_type      | /^files$/           |
      | typeicon         | /^icon-shared$/     |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=parent.txt" id=\"\d+\">parent.txt<\/file><\/collection> with you$/|

  @skipOnOcV10.2
  Scenario: users checks a group related activity after deleting the group
    Given these users have been created with default attributes and small skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And group "grp1" has been created
    And user "Alice" has been added to group "grp1"
    And user "Brian" has been added to group "grp1"
    And user "Alice" has shared file "textfile0.txt" with group "grp1"
    When the administrator deletes group "grp1" using the provisioning API
    Then the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/          |
      | user             | /^Alice$/           |
      | affecteduser     | /^Brian$/           |
      | app              | /^files_sharing$/   |
      | subject          | /^shared_with_by$/  |
      | object_name      | /^\/textfile0.txt$/ |
      | object_type      | /^files$/           |
      | typeicon         | /^icon-shared$/     |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with you$/|

  @skipOnOcV10.2
  Scenario: users checks a user related activity after deleting the user
    Given these users have been created with default attributes and small skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    When the administrator deletes user "Alice" using the provisioning API
    Then the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/          |
      | user             | /^Alice$/           |
      | affecteduser     | /^Brian$/           |
      | app              | /^files_sharing$/   |
      | subject          | /^shared_with_by$/  |
      | object_name      | /^\/textfile0.txt$/ |
      | object_type      | /^files$/           |
      | typeicon         | /^icon-shared$/     |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/ |
      | subject_prepared | /^<user display-name=\"Alice\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with you$/|

  @skipOnOcV10.2
  Scenario: Sharer and sharee check activity after sharer deletes shared file
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/lorem.txt"
    And user "Alice" has shared file "/lorem.txt" with user "Brian"
    When user "Alice" deletes file "/lorem.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/lorem.txt$/       |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\.d\d+&view=trashbin\" id=\"\d+\">lorem\.txt<\/file>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/               |
      | user             | /^Alice$/                |
      | affecteduser     | /^Alice$/                |
      | app              | /^files_sharing$/        |
      | subject          | /^shared_user_self$/     |
      | object_name      | /^\/lorem.txt$/          |
      | object_type      | /^files$/                |
      | typeicon         | /^icon-shared$/          |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt\.d\d+&view=trashbin\" id=\"\d+\">lorem.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/|
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_deleted$/         |
      | user             | /^Alice$/                |
      | affecteduser     | /^Brian$/                |
      | app              | /^files$/                |
      | subject          | /^deleted_by$/           |
      | object_name      | /^\/lorem.txt$/          |
      | object_type      | /^files$/                |
      | typeicon         | /^icon-delete-color$/    |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file>$/|
    And the activity number 2 of user "Brian" should match these properties:
      | type             | /^shared$/            |
      | user             | /^Alice$/             |
      | affecteduser     | /^Brian$/             |
      | app              | /^files_sharing$/     |
      | subject          | /^shared_with_by$/    |
      | object_name      | /^\/lorem.txt$/       |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-shared$/       |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file> with you$/|

  @skipOnOcV10.2
  Scenario: Sharer and sharee check activity after sharee deletes shared file
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/lorem.txt"
    And user "Alice" has shared file "/lorem.txt" with user "Brian"
    When user "Brian" deletes file "/lorem.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/               |
      | user             | /^Alice$/                |
      | affecteduser     | /^Alice$/                |
      | app              | /^files_sharing$/        |
      | subject          | /^shared_user_self$/     |
      | object_name      | /^\/lorem.txt$/          |
      | object_type      | /^files$/                |
      | typeicon         | /^icon-shared$/          |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt\" id=\"\d+\">lorem.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/|
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/             |
      | user             | /^Brian$/              |
      | affecteduser     | /^Brian$/              |
      | app              | /^files_sharing$/      |
      | subject          | /^unshared_from_self$/ |
      | typeicon         | /^icon-shared$/    |
      | subject_prepared | /^You unshared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id="">lorem.txt<\/file> shared by <user display-name=\"Alice Hansen\">Alice<\/user> from self$/|
    And the activity number 2 of user "Brian" should match these properties:
      | type             | /^shared$/            |
      | user             | /^Alice$/             |
      | affecteduser     | /^Brian$/             |
      | app              | /^files_sharing$/     |
      | subject          | /^shared_with_by$/    |
      | object_name      | /^\/lorem.txt$/       |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-shared$/       |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file> with you$/|

  @skipOnOcV10.2
  Scenario: Sharer and sharee check activity after sharer deletes shared file and then again restore it
    Given the administrator has enabled DAV tech_preview
    And these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/lorem.txt"
    And user "Alice" has shared file "/lorem.txt" with user "Brian"
    When user "Alice" deletes file "/lorem.txt" using the WebDAV API
    And user "Alice" restores the file with original path "lorem.txt" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/     |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^restored_self$/     |
      | object_name      | /^\/lorem.txt$/       |
      | object_type      | /^files$/             |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^file_deleted$/      |
      | user             | /^Alice$/             |
      | affecteduser     | /^Alice$/             |
      | app              | /^files$/             |
      | subject          | /^deleted_self$/      |
      | object_name      | /^\/lorem.txt$/       |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-delete-color$/ |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file>$/ |
    And the activity number 3 of user "Alice" should match these properties:
      | type             | /^shared$/               |
      | user             | /^Alice$/                |
      | affecteduser     | /^Alice$/                |
      | app              | /^files_sharing$/        |
      | subject          | /^shared_user_self$/     |
      | object_name      | /^\/lorem.txt$/          |
      | object_type      | /^files$/                |
      | typeicon         | /^icon-shared$/          |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt\" id=\"\d+\">lorem.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/|
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_restored$/     |
      | user             | /^Alice$/             |
      | affecteduser     | /^Brian$/             |
      | app              | /^files$/             |
      | subject          | /^restored_by$/     |
      | object_name      | /^\/lorem.txt$/       |
      | object_type      | /^files$/             |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file>$/|
    And the activity number 2 of user "Brian" should match these properties:
      | type             | /^file_deleted$/         |
      | user             | /^Alice$/                |
      | affecteduser     | /^Brian$/                |
      | app              | /^files$/                |
      | subject          | /^deleted_by$/           |
      | object_name      | /^\/lorem.txt$/          |
      | object_type      | /^files$/                |
      | typeicon         | /^icon-delete-color$/    |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file>$/|
    And the activity number 3 of user "Brian" should match these properties:
      | type             | /^shared$/            |
      | user             | /^Alice$/             |
      | affecteduser     | /^Brian$/             |
      | app              | /^files_sharing$/     |
      | subject          | /^shared_with_by$/    |
      | object_name      | /^\/lorem.txt$/       |
      | object_type      | /^files$/             |
      | typeicon         | /^icon-shared$/       |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file> with you$/|
