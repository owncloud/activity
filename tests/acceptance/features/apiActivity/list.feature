@api
Feature: List activity
  As a user
  I want to be able to see the activity list
  So that I know what is happening with my files/folders

  Scenario: file deletion should be listed in the activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes file "textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/                                                                                                                                              |
      | user             | /^Alice$/                                                                                                                                                     |
      | affecteduser     | /^Alice$/                                                                                                                                                     |
      | app              | /^files$/                                                                                                                                                     |
      | subject          | /^deleted_self$/                                                                                                                                              |
      | object_name      | /^\/textfile0.txt$/                                                                                                                                           |
      | object_type      | /^files$/                                                                                                                                                     |
      | typeicon         | /^icon-delete-color$/                                                                                                                                         |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\.d\d+&view=trashbin\" id=\"\d+\">textfile0\.txt<\/file>$/ |


  Scenario: root file rename should be listed in the activity list
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file with content "upload-content" to "/textfile0.txt"
    When user "Alice" moves file "/textfile0.txt" to "/textfile1.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_renamed/                                                                                                                                                                                                                                                     |
      | user             | /^Alice$/                                                                                                                                                                                                                                                           |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                           |
      | app              | /^files$/                                                                                                                                                                                                                                                           |
      | subject          | /^renamed_self$/                                                                                                                                                                                                                                                    |
      | object_name      | /^\/textfile1.txt$/                                                                                                                                                                                                                                                 |
      | object_type      | /^files$/                                                                                                                                                                                                                                                           |
      | typeicon         | /^icon-rename/                                                                                                                                                                                                                                                      |
      | subject_prepared | /^You renamed <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\" id=\"\">textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile1\.txt\" id=\"\d+\">textfile1\.txt<\/file>$/ |


  Scenario: file rename inside a subfolder should be listed in the activity list
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "folder"
    And user "Alice" has created folder "folder/sub-folder"
    And user "Alice" has uploaded file with content "upload-content" to "/folder/sub-folder/textfile0.txt"
    When user "Alice" moves file "/folder/sub-folder/textfile0.txt" to "/folder/sub-folder/textfile1.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_renamed/                                                                                                                                                                                                                                                                                                                                 |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                                                                       |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                                                                       |
      | app              | /^files$/                                                                                                                                                                                                                                                                                                                                       |
      | subject          | /^renamed_self$/                                                                                                                                                                                                                                                                                                                                |
      | object_name      | /^\/folder\/sub-folder\/textfile1.txt$/                                                                                                                                                                                                                                                                                                         |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                                                       |
      | typeicon         | /^icon-rename/                                                                                                                                                                                                                                                                                                                                  |
      | subject_prepared | /^You renamed <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\/sub-folder&scrollto=textfile0\.txt\" id=\"\">folder\/sub-folder\/textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\/sub-folder&scrollto=textfile1\.txt\" id=\"\d+\">folder\/sub-folder\/textfile1\.txt<\/file>$/ |


  Scenario: move file action into a subfolder should be listed in the activity list
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "folder"
    And user "Alice" has created folder "folder/sub-folder"
    And user "Alice" has uploaded file with content "upload-content" to "/textfile0.txt"
    When user "Alice" moves file "/textfile0.txt" to "/folder/sub-folder/textfile1.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_moved/                                                                                                                                                                                                                                                                                           |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                               |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                               |
      | app              | /^files$/                                                                                                                                                                                                                                                                                               |
      | subject          | /^moved_self$/                                                                                                                                                                                                                                                                                          |
      | object_name      | /^\/folder\/sub-folder\/textfile1.txt$/                                                                                                                                                                                                                                                                 |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                               |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                                            |
      | subject_prepared | /^You moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\" id=\"\">textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\/sub-folder&scrollto=textfile1\.txt\" id=\"\d+\">folder\/sub-folder\/textfile1\.txt<\/file>$/ |


  Scenario: move folder out of a subfolder should be listed in the activity list
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "folder"
    And user "Alice" has created folder "folder/sub-folder"
    And user "Alice" has created folder "folder/sub-folder/deep-folder"
    When user "Alice" moves folder "/folder/sub-folder/deep-folder" to "/folder/deep-folder" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_moved/                                                                                                                                                                                                                                                                                   |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                       |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                       |
      | app              | /^files$/                                                                                                                                                                                                                                                                                       |
      | subject          | /^moved_self$/                                                                                                                                                                                                                                                                                  |
      | object_name      | /^\/folder\/deep-folder$/                                                                                                                                                                                                                                                                       |
      | object_type      | /^files/                                                                                                                                                                                                                                                                                        |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                                    |
      | subject_prepared | /^You moved <file link=\"%base_url%\/(index.php\/)?apps\/files\/\?dir=\/folder\/sub-folder&scrollto=deep-folder\" id=\"\">folder\/sub-folder\/deep-folder<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\/deep-folder\" id="\d+\">folder\/deep-folder<\/file>$/ |

  @skipOnOcV10.2
  Scenario: file restore should be listed in the activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted file "textfile0.txt"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the file with original path "textfile0.txt" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/                                                                                                                          |
      | user             | /^Alice$/                                                                                                                                  |
      | affecteduser     | /^Alice$/                                                                                                                                  |
      | app              | /^files$/                                                                                                                                  |
      | subject          | /^restored_self$/                                                                                                                          |
      | object_name      | /^\/textfile0.txt$/                                                                                                                        |
      | object_type      | /^files$/                                                                                                                                  |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\" id=\"\d+\">textfile0\.txt<\/file>$/ |


  Scenario: folder deletion should be listed in the activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes folder "FOLDER" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/                                                                                                                    |
      | user             | /^Alice$/                                                                                                                           |
      | affecteduser     | /^Alice$/                                                                                                                           |
      | app              | /^files$/                                                                                                                           |
      | subject          | /^deleted_self$/                                                                                                                    |
      | object_name      | /^\/FOLDER$/                                                                                                                        |
      | object_type      | /^files$/                                                                                                                           |
      | typeicon         | /^icon-delete-color$/                                                                                                               |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\.d\d+&view=trashbin\" id=\"\d+\">FOLDER<\/file>$/ |

  @skipOnOcV10.2
  Scenario: folder restore should be listed in the activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted folder "FOLDER"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the folder with original path "FOLDER" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/                                                                                                |
      | user             | /^Alice$/                                                                                                        |
      | affecteduser     | /^Alice$/                                                                                                        |
      | app              | /^files$/                                                                                                        |
      | subject          | /^restored_self$/                                                                                                |
      | object_name      | /^\/FOLDER$/                                                                                                     |
      | object_type      | /^files$/                                                                                                        |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\" id=\"\d+\">FOLDER<\/file>$/ |


  Scenario: file inside folder deletion should be listed in the activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes file "PARENT/parent.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/                                                                                                                                               |
      | user             | /^Alice$/                                                                                                                                                      |
      | affecteduser     | /^Alice$/                                                                                                                                                      |
      | app              | /^files$/                                                                                                                                                      |
      | subject          | /^deleted_self$/                                                                                                                                               |
      | object_name      | /^\/PARENT\/parent.txt$/                                                                                                                                       |
      | object_type      | /^files$/                                                                                                                                                      |
      | typeicon         | /^icon-delete-color$/                                                                                                                                          |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=parent\.txt\.d\d+&view=trashbin\" id=\"\d+\">PARENT\/parent.txt<\/file>$/ |

  @skipOnOcV10.2
  Scenario: file inside folder restore should be listed in the activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted file "PARENT/parent.txt"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the file with original path "PARENT/parent.txt" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/                                                                                                                                  |
      | user             | /^Alice$/                                                                                                                                          |
      | affecteduser     | /^Alice$/                                                                                                                                          |
      | app              | /^files$/                                                                                                                                          |
      | subject          | /^restored_self$/                                                                                                                                  |
      | object_name      | /^\/PARENT\/parent.txt$/                                                                                                                           |
      | object_type      | /^files$/                                                                                                                                          |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT&scrollto=parent\.txt\" id=\"\d+\">PARENT\/parent\.txt<\/file>$/ |


  Scenario: sub folder deletion should be listed in the activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes folder "PARENT/CHILD" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/                                                                                                                         |
      | user             | /^Alice$/                                                                                                                                |
      | affecteduser     | /^Alice$/                                                                                                                                |
      | app              | /^files$/                                                                                                                                |
      | subject          | /^deleted_self$/                                                                                                                         |
      | object_name      | /^\/PARENT\/CHILD$/                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                |
      | typeicon         | /^icon-delete-color$/                                                                                                                    |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/CHILD.d\d+&view=trashbin\" id=\"\d+\">PARENT\/CHILD<\/file>$/ |

  @skipOnOcV10.2
  Scenario: sub folder restore should be listed in the activity list
    Given the administrator has enabled DAV tech_preview
    And user "Alice" has been created with default attributes and small skeleton files
    And user "Alice" has deleted folder "PARENT/CHILD"
    And user "Alice" has logged in to a web-style session
    When user "Alice" restores the folder with original path "PARENT/CHILD" using the trashbin API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_restored$/                                                                                                             |
      | user             | /^Alice$/                                                                                                                     |
      | affecteduser     | /^Alice$/                                                                                                                     |
      | app              | /^files$/                                                                                                                     |
      | subject          | /^restored_self$/                                                                                                             |
      | object_name      | /^\/PARENT\/CHILD$/                                                                                                           |
      | object_type      | /^files$/                                                                                                                     |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT\/CHILD" id=\"\d+\">PARENT\/CHILD<\/file>$/ |


  Scenario: multiple file deletion should be listed in activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes file "textfile0.txt" using the WebDAV API
    And user "Alice" deletes file "textfile1.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/                                                                                                                                                                                                                                                                                                                     |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                                                            |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                                                            |
      | app              | /^files$/                                                                                                                                                                                                                                                                                                                            |
      | subject          | /^deleted_self$/                                                                                                                                                                                                                                                                                                                     |
      | object_name      | /^\/textfile1\.txt$/                                                                                                                                                                                                                                                                                                                 |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                                            |
      | typeicon         | /^icon-delete-color$/                                                                                                                                                                                                                                                                                                                |
      | subject_prepared | /^You deleted <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile1\.txt\.d\d+&view=trashbin\" id=\"\d+\">textfile1\.txt<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0\.txt\.d\d+&view=trashbin\" id=\"\d+\">textfile0\.txt<\/file><\/collection>$/ |


  Scenario: multiple folder deletion should be listed in activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes folder "PARENT" using the WebDAV API
    And user "Alice" deletes folder "FOLDER" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/                                                                                                                                                                                                                                                                 |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                        |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                        |
      | app              | /^files$/                                                                                                                                                                                                                                                                        |
      | subject          | /^deleted_self$/                                                                                                                                                                                                                                                                 |
      | object_name      | /^\/FOLDER$/                                                                                                                                                                                                                                                                     |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                        |
      | typeicon         | /^icon-delete-color$/                                                                                                                                                                                                                                                            |
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
      | type             | /^file_restored$/                                                                                                                                                                                                                                                                             |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                     |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                     |
      | app              | /^files$/                                                                                                                                                                                                                                                                                     |
      | subject          | /^restored_self$/                                                                                                                                                                                                                                                                             |
      | object_name      | /^\/textfile1\.txt$/                                                                                                                                                                                                                                                                          |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                     |
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
      | type             | /^file_restored$/                                                                                                                                                                                                                         |
      | user             | /^Alice$/                                                                                                                                                                                                                                 |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                 |
      | app              | /^files$/                                                                                                                                                                                                                                 |
      | subject          | /^restored_self$/                                                                                                                                                                                                                         |
      | object_name      | /^\/PARENT$/                                                                                                                                                                                                                              |
      | object_type      | /^files$/                                                                                                                                                                                                                                 |
      | subject_prepared | /^You restored <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT\" id=\"\d+\">PARENT<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\" id=\"\d+\">FOLDER<\/file><\/collection>$/ |

  Scenario: mix of folder and file deletion should be listed in activity list
    Given user "Alice" has been created with default attributes and small skeleton files
    When user "Alice" deletes file "textfile0.txt" using the WebDAV API
    And user "Alice" deletes folder "FOLDER" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_deleted$/                                                                                                                                                                                                                                                                                           |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                                  |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                                  |
      | app              | /^files$/                                                                                                                                                                                                                                                                                                  |
      | subject          | /^deleted_self$/                                                                                                                                                                                                                                                                                           |
      | object_name      | /^\/FOLDER$/                                                                                                                                                                                                                                                                                               |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                  |
      | typeicon         | /^icon-delete-color$/                                                                                                                                                                                                                                                                                      |
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
      | type             | /^file_restored$/                                                                                                                                                                                                                                                   |
      | user             | /^Alice$/                                                                                                                                                                                                                                                           |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                           |
      | app              | /^files$/                                                                                                                                                                                                                                                           |
      | subject          | /^restored_self$/                                                                                                                                                                                                                                                   |
      | object_name      | /^\/FOLDER$/                                                                                                                                                                                                                                                        |
      | object_type      | /^files$/                                                                                                                                                                                                                                                           |
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
      | type             | /^shared$/                                                                                                                                                    |
      | user             | /^Alice$/                                                                                                                                                     |
      | affecteduser     | /^Alice$/                                                                                                                                                     |
      | app              | /^files_sharing$/                                                                                                                                             |
      | subject          | /^shared_user_self$/                                                                                                                                          |
      | object_name      | /^\/two$/                                                                                                                                                     |
      | object_type      | /^files$/                                                                                                                                                     |
      | typeicon         | /^icon-shared$/                                                                                                                                               |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/two\" id=\"\d+\">two<\/file> with <user display-name=\"Carol King\">Carol<\/user>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                      |
      | user             | /^Alice$/                                                                                                                                                       |
      | affecteduser     | /^Alice$/                                                                                                                                                       |
      | app              | /^files_sharing$/                                                                                                                                               |
      | subject          | /^shared_user_self$/                                                                                                                                            |
      | object_name      | /^\/one$/                                                                                                                                                       |
      | object_type      | /^files$/                                                                                                                                                       |
      | typeicon         | /^icon-shared$/                                                                                                                                                 |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/one\" id=\"\d+\">one<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/ |


  Scenario: folder creation should be listed in the activity list
    Given user "Alice" has been created with default attributes and without skeleton files
    When user "Alice" creates folder "/one" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_created$/                                                                                                     |
      | user             | /^Alice$/                                                                                                            |
      | affecteduser     | /^Alice$/                                                                                                            |
      | app              | /^files$/                                                                                                            |
      | subject          | /^created_self$/                                                                                                     |
      | object_name      | /^\/one$/                                                                                                            |
      | object_type      | /^files$/                                                                                                            |
      | typeicon         | /^icon-add-color$/                                                                                                   |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                 |
      | subject_prepared | /^You created <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/one\" id=\"\d+\">one<\/file>/ |


  Scenario: file upload should be listed in activity list
    Given user "Alice" has been created with default attributes and without skeleton files
    When user "Alice" uploads file "filesForUpload/textfile.txt" to "/text.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_created$/                                                                                                                        |
      | user             | /^Alice$/                                                                                                                               |
      | affecteduser     | /^Alice$/                                                                                                                               |
      | app              | /^files$/                                                                                                                               |
      | subject          | /^created_self$/                                                                                                                        |
      | object_name      | /^\/text.txt$/                                                                                                                          |
      | object_type      | /^files$/                                                                                                                               |
      | typeicon         | /^icon-add-color$/                                                                                                                      |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                                    |
      | subject_prepared | /^You created <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=text.txt" id=\"\d+\">text.txt<\/file>/ |

  @skipOnOcV10.2
  Scenario: different files share with different user should be listed in activity list of sharer
    Given user "Alice" has been created with default attributes and small skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    When user "Alice" shares file "PARENT/parent.txt" with user "Carol" using the sharing API
    And user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                   |
      | user             | /^Alice$/                                                                                                                                                                                    |
      | affecteduser     | /^Alice$/                                                                                                                                                                                    |
      | app              | /^files_sharing$/                                                                                                                                                                            |
      | subject          | /^shared_user_self$/                                                                                                                                                                         |
      | object_name      | /^\/textfile0.txt$/                                                                                                                                                                          |
      | object_type      | /^files$/                                                                                                                                                                                    |
      | typeicon         | /^icon-shared$/                                                                                                                                                                              |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                                                                                         |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                         |
      | user             | /^Alice$/                                                                                                                                                                                          |
      | affecteduser     | /^Alice$/                                                                                                                                                                                          |
      | app              | /^files_sharing$/                                                                                                                                                                                  |
      | subject          | /^shared_user_self$/                                                                                                                                                                               |
      | object_name      | /^\/PARENT\/parent.txt$/                                                                                                                                                                           |
      | object_type      | /^files$/                                                                                                                                                                                          |
      | typeicon         | /^icon-shared$/                                                                                                                                                                                    |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT$/                                                                                                                                         |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT&scrollto=parent.txt" id=\"\d+\">PARENT\/parent.txt<\/file> with <user display-name=\"Carol King\">Carol<\/user>$/ |

  @skipOnOcV10.2
  Scenario: different files shared with same user should be listed in activity list of sharer
    Given user "Alice" has been created with default attributes and small skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    When user "Alice" shares file "PARENT/parent.txt" with user "Brian" using the sharing API
    And user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                   |
      | user             | /^Alice$/                                                                                                                                                                                    |
      | affecteduser     | /^Alice$/                                                                                                                                                                                    |
      | app              | /^files_sharing$/                                                                                                                                                                            |
      | subject          | /^shared_user_self$/                                                                                                                                                                         |
      | object_name      | /^\/textfile0.txt$/                                                                                                                                                                          |
      | object_type      | /^files$/                                                                                                                                                                                    |
      | typeicon         | /^icon-shared$/                                                                                                                                                                              |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                                                                                         |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                           |
      | user             | /^Alice$/                                                                                                                                                                                            |
      | affecteduser     | /^Alice$/                                                                                                                                                                                            |
      | app              | /^files_sharing$/                                                                                                                                                                                    |
      | subject          | /^shared_user_self$/                                                                                                                                                                                 |
      | object_name      | /^\/PARENT\/parent.txt$/                                                                                                                                                                             |
      | object_type      | /^files$/                                                                                                                                                                                            |
      | typeicon         | /^icon-shared$/                                                                                                                                                                                      |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT$/                                                                                                                                           |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT&scrollto=parent.txt" id=\"\d+\">PARENT\/parent.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/ |

  @skipOnOcV10.2
  Scenario: different files shared with different user should be listed in activity list of sharee
    Given user "Alice" has been created with default attributes and small skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    And user "Carol" has been created with default attributes and without skeleton files
    When user "Alice" shares file "PARENT/parent.txt" with user "Brian" using the sharing API
    And user "Alice" shares file "textfile0.txt" with user "Carol" using the sharing API
    Then the activity number 1 of user "Carol" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                   |
      | user             | /^Alice$/                                                                                                                                                                                    |
      | affecteduser     | /^Carol$/                                                                                                                                                                                    |
      | app              | /^files_sharing$/                                                                                                                                                                            |
      | subject          | /^shared_with_by$/                                                                                                                                                                           |
      | object_name      | /^\/textfile0.txt$/                                                                                                                                                                          |
      | object_type      | /^files$/                                                                                                                                                                                    |
      | typeicon         | /^icon-shared$/                                                                                                                                                                              |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                                                                                         |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with you$/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                                                             |
      | user             | /^Alice$/                                                                                                                                                                              |
      | affecteduser     | /^Brian$/                                                                                                                                                                              |
      | app              | /^files_sharing$/                                                                                                                                                                      |
      | subject          | /^shared_with_by$/                                                                                                                                                                     |
      | object_name      | /^\/parent.txt$/                                                                                                                                                                       |
      | object_type      | /^files$/                                                                                                                                                                              |
      | typeicon         | /^icon-shared$/                                                                                                                                                                        |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                                                                                   |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=parent.txt" id=\"\d+\">parent.txt<\/file> with you$/ |

  @skipOnOcV10.2
  Scenario: different files shared with same user should be listed in activity list of sharee
    Given user "Alice" has been created with default attributes and small skeleton files
    And user "Brian" has been created with default attributes and without skeleton files
    When user "Alice" shares file "PARENT/parent.txt" with user "Brian" using the sharing API
    And user "Alice" shares file "textfile0.txt" with user "Brian" using the sharing API
    Then the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                                                                                                                                                             |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                                                              |
      | affecteduser     | /^Brian$/                                                                                                                                                                                                                                                                                                                              |
      | app              | /^files_sharing$/                                                                                                                                                                                                                                                                                                                      |
      | subject          | /^shared_with_by$/                                                                                                                                                                                                                                                                                                                     |
      | object_name      | /^\/textfile0.txt$/                                                                                                                                                                                                                                                                                                                    |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                                              |
      | typeicon         | /^icon-shared$/                                                                                                                                                                                                                                                                                                                        |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                                                                                                                                                                                                                                   |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <collection><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file><file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=parent.txt" id=\"\d+\">parent.txt<\/file><\/collection> with you$/ |

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
      | type             | /^shared$/                                                                                                                                                                                   |
      | user             | /^Alice$/                                                                                                                                                                                    |
      | affecteduser     | /^Brian$/                                                                                                                                                                                    |
      | app              | /^files_sharing$/                                                                                                                                                                            |
      | subject          | /^shared_with_by$/                                                                                                                                                                           |
      | object_name      | /^\/textfile0.txt$/                                                                                                                                                                          |
      | object_type      | /^files$/                                                                                                                                                                                    |
      | typeicon         | /^icon-shared$/                                                                                                                                                                              |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                                                                                         |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with you$/ |

  @skipOnOcV10.2
  Scenario: users checks a user related activity after deleting the user
    Given these users have been created with default attributes and small skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has shared file "textfile0.txt" with user "Brian"
    When the administrator deletes user "Alice" using the provisioning API
    Then the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                                                            |
      | user             | /^Alice$/                                                                                                                                                                             |
      | affecteduser     | /^Brian$/                                                                                                                                                                             |
      | app              | /^files_sharing$/                                                                                                                                                                     |
      | subject          | /^shared_with_by$/                                                                                                                                                                    |
      | object_name      | /^\/textfile0.txt$/                                                                                                                                                                   |
      | object_type      | /^files$/                                                                                                                                                                             |
      | typeicon         | /^icon-shared$/                                                                                                                                                                       |
      | link             | /^%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/$/                                                                                                                                  |
      | subject_prepared | /^<user display-name=\"Alice\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=textfile0.txt" id=\"\d+\">textfile0.txt<\/file> with you$/ |

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
      | type             | /^file_deleted$/                                                                                                                                      |
      | user             | /^Alice$/                                                                                                                                             |
      | affecteduser     | /^Alice$/                                                                                                                                             |
      | app              | /^files$/                                                                                                                                             |
      | subject          | /^deleted_self$/                                                                                                                                      |
      | object_name      | /^\/lorem.txt$/                                                                                                                                       |
      | object_type      | /^files$/                                                                                                                                             |
      | typeicon         | /^icon-delete-color$/                                                                                                                                 |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\.d\d+&view=trashbin\" id=\"\d+\">lorem\.txt<\/file>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                                |
      | user             | /^Alice$/                                                                                                                                                                                                 |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                 |
      | app              | /^files_sharing$/                                                                                                                                                                                         |
      | subject          | /^shared_user_self$/                                                                                                                                                                                      |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                                           |
      | object_type      | /^files$/                                                                                                                                                                                                 |
      | typeicon         | /^icon-shared$/                                                                                                                                                                                           |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt\.d\d+&view=trashbin\" id=\"\d+\">lorem.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_deleted$/                                                                                                                                                             |
      | user             | /^Alice$/                                                                                                                                                                    |
      | affecteduser     | /^Brian$/                                                                                                                                                                    |
      | app              | /^files$/                                                                                                                                                                    |
      | subject          | /^deleted_by$/                                                                                                                                                               |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                              |
      | object_type      | /^files$/                                                                                                                                                                    |
      | typeicon         | /^icon-delete-color$/                                                                                                                                                        |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file>$/ |
    And the activity number 2 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                                                           |
      | user             | /^Alice$/                                                                                                                                                                            |
      | affecteduser     | /^Brian$/                                                                                                                                                                            |
      | app              | /^files_sharing$/                                                                                                                                                                    |
      | subject          | /^shared_with_by$/                                                                                                                                                                   |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                                                            |
      | typeicon         | /^icon-shared$/                                                                                                                                                                      |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file> with you$/ |

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
      | type             | /^shared$/                                                                                                                                                                            |
      | user             | /^Alice$/                                                                                                                                                                             |
      | affecteduser     | /^Alice$/                                                                                                                                                                             |
      | app              | /^files_sharing$/                                                                                                                                                                     |
      | subject          | /^shared_user_self$/                                                                                                                                                                  |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                       |
      | object_type      | /^files$/                                                                                                                                                                             |
      | typeicon         | /^icon-shared$/                                                                                                                                                                       |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt\" id=\"\d+\">lorem.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                       |
      | user             | /^Brian$/                                                                                                                                                                                        |
      | affecteduser     | /^Brian$/                                                                                                                                                                                        |
      | app              | /^files_sharing$/                                                                                                                                                                                |
      | subject          | /^unshared_from_self$/                                                                                                                                                                           |
      | typeicon         | /^icon-shared$/                                                                                                                                                                                  |
      | subject_prepared | /^You unshared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id="">lorem.txt<\/file> shared by <user display-name=\"Alice Hansen\">Alice<\/user> from self$/ |
    And the activity number 2 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                                                           |
      | user             | /^Alice$/                                                                                                                                                                            |
      | affecteduser     | /^Brian$/                                                                                                                                                                            |
      | app              | /^files_sharing$/                                                                                                                                                                    |
      | subject          | /^shared_with_by$/                                                                                                                                                                   |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                                                            |
      | typeicon         | /^icon-shared$/                                                                                                                                                                      |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file> with you$/ |

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
      | type             | /^file_restored$/                                                                                                                  |
      | user             | /^Alice$/                                                                                                                          |
      | affecteduser     | /^Alice$/                                                                                                                          |
      | app              | /^files$/                                                                                                                          |
      | subject          | /^restored_self$/                                                                                                                  |
      | object_name      | /^\/lorem.txt$/                                                                                                                    |
      | object_type      | /^files$/                                                                                                                          |
      | subject_prepared | /^You restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^file_deleted$/                                                                                                                  |
      | user             | /^Alice$/                                                                                                                         |
      | affecteduser     | /^Alice$/                                                                                                                         |
      | app              | /^files$/                                                                                                                         |
      | subject          | /^deleted_self$/                                                                                                                  |
      | object_name      | /^\/lorem.txt$/                                                                                                                   |
      | object_type      | /^files$/                                                                                                                         |
      | typeicon         | /^icon-delete-color$/                                                                                                             |
      | subject_prepared | /^You deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file>$/ |
    And the activity number 3 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                            |
      | user             | /^Alice$/                                                                                                                                                                             |
      | affecteduser     | /^Alice$/                                                                                                                                                                             |
      | app              | /^files_sharing$/                                                                                                                                                                     |
      | subject          | /^shared_user_self$/                                                                                                                                                                  |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                       |
      | object_type      | /^files$/                                                                                                                                                                             |
      | typeicon         | /^icon-shared$/                                                                                                                                                                       |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt\" id=\"\d+\">lorem.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_restored$/                                                                                                                                                             |
      | user             | /^Alice$/                                                                                                                                                                     |
      | affecteduser     | /^Brian$/                                                                                                                                                                     |
      | app              | /^files$/                                                                                                                                                                     |
      | subject          | /^restored_by$/                                                                                                                                                               |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                               |
      | object_type      | /^files$/                                                                                                                                                                     |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> restored <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file>$/ |
    And the activity number 2 of user "Brian" should match these properties:
      | type             | /^file_deleted$/                                                                                                                                                             |
      | user             | /^Alice$/                                                                                                                                                                    |
      | affecteduser     | /^Brian$/                                                                                                                                                                    |
      | app              | /^files$/                                                                                                                                                                    |
      | subject          | /^deleted_by$/                                                                                                                                                               |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                              |
      | object_type      | /^files$/                                                                                                                                                                    |
      | typeicon         | /^icon-delete-color$/                                                                                                                                                        |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file>$/ |
    And the activity number 3 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                                                           |
      | user             | /^Alice$/                                                                                                                                                                            |
      | affecteduser     | /^Brian$/                                                                                                                                                                            |
      | app              | /^files_sharing$/                                                                                                                                                                    |
      | subject          | /^shared_with_by$/                                                                                                                                                                   |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                                                            |
      | typeicon         | /^icon-shared$/                                                                                                                                                                      |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file> with you$/ |


  Scenario: Check activity list after share is expired for user share
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/lorem.txt"
    When user "Alice" creates a share using the sharing API with settings
      | path       | /lorem.txt |
      | shareType  | user       |
      | shareWith  | Brian      |
      | expireDate | +15 days   |
    And the administrator expires the last created share using the testing API
    # Testing api is used above so to tigger the latest list of activity
    And user "Alice" gets all shares shared by him using the sharing API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                                        |
      | user             | /^auto:automation$/                                                                                                                                                                                               |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                         |
      | app              | /^files_sharing$/                                                                                                                                                                                                 |
      | subject          | /^unshared_user_self$/                                                                                                                                                                                            |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                                                   |
      | object_type      | /^files$/                                                                                                                                                                                                         |
      | subject_prepared | /^You removed the share of <user display-name="auto\:automation">auto\:automation<\/user> for <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                              |
      | user             | /^Alice$/                                                                                                                                                                               |
      | affecteduser     | /^Alice$/                                                                                                                                                                               |
      | app              | /^files_sharing$/                                                                                                                                                                       |
      | subject          | /^shared_user_self$/                                                                                                                                                                    |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                         |
      | object_type      | /^files$/                                                                                                                                                                               |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file> with <user display-name=\"Brian Murphy\">Brian<\/user>$/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                  |
      | user             | /^auto:automation$/                                                                                                                         |
      | affecteduser     | /^Brian$/                                                                                                                                   |
      | app              | /^files_sharing$/                                                                                                                           |
      | subject          | /^unshared_by$/                                                                                                                             |
      | object_name      | /^\/lorem.txt$/                                                                                                                             |
      | object_type      | /^files$/                                                                                                                                   |
      | subject_prepared | /^The share for <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file> expired$/ |
    And the last share id should not be included in the response


  Scenario: Check activity list after share is expired for group share
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And group "grp1" has been created
    And user "Brian" has been added to group "grp1"
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/lorem.txt"
    When user "Alice" creates a share using the sharing API with settings
      | path       | /lorem.txt |
      | shareType  | group      |
      | shareWith  | grp1       |
      | expireDate | +15 days   |
    And the administrator expires the last created share using the testing API
    # Testing api is used above so to tigger the latest list of activity
    And user "Alice" gets all shares shared by him using the sharing API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                                                                        |
      | user             | /^auto:automation$/                                                                                                                                                                               |
      | affecteduser     | /^Alice$/                                                                                                                                                                                         |
      | app              | /^files_sharing$/                                                                                                                                                                                 |
      | subject          | /^unshared_group_self$/                                                                                                                                                                           |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                                   |
      | object_type      | /^files$/                                                                                                                                                                                         |
      | subject_prepared | /^You removed the share of group <parameter>auto\:automation<\/parameter> for <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file>$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type         | /^shared$/            |
      | user         | /^Alice$/             |
      | affecteduser | /^Alice$/             |
      | app          | /^files_sharing$/     |
      | subject      | /^shared_group_self$/ |
      | object_name  | /^\/lorem.txt$/       |
      | object_type  | /^files$/             |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                  |
      | user             | /^auto:automation$/                                                                                                                         |
      | affecteduser     | /^Brian$/                                                                                                                                   |
      | app              | /^files_sharing$/                                                                                                                           |
      | subject          | /^unshared_by$/                                                                                                                             |
      | object_name      | /^\/lorem.txt$/                                                                                                                             |
      | object_type      | /^files$/                                                                                                                                   |
      | subject_prepared | /^The share for <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file> expired$/ |
    And the activity number 2 of user "Brian" should match these properties:
      | type             | /^shared$/                                                                                                                                                                           |
      | user             | /^Alice$/                                                                                                                                                                            |
      | affecteduser     | /^Brian$/                                                                                                                                                                            |
      | app              | /^files_sharing$/                                                                                                                                                                    |
      | subject          | /^shared_with_by$/                                                                                                                                                                   |
      | object_name      | /^\/lorem.txt$/                                                                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                                                            |
      | typeicon         | /^icon-shared$/                                                                                                                                                                      |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem.txt" id=\"\d+\">lorem.txt<\/file> with you$/ |
    And the last share id should not be included in the response


  Scenario: Check activity list after share is expired for public link share
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
    And user "Alice" has uploaded file "filesForUpload/lorem.txt" to "/lorem.txt"
    When user "Alice" has created a public link share with settings
      | path       | /lorem.txt |
      | expireDate | +15 days   |
    And the administrator expires the last created share using the testing API
    # Testing api is used above so to tigger the latest list of activity
    And user "Alice" gets all shares shared by him using the sharing API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                         |
      | user             | /^auto:automation$/                                                                                                                                |
      | affecteduser     | /^Alice$/                                                                                                                                          |
      | app              | /^files_sharing$/                                                                                                                                  |
      | subject          | /^link_expired$/                                                                                                                                   |
      | object_name      | /^\/lorem.txt$/                                                                                                                                    |
      | object_type      | /^files$/                                                                                                                                          |
      | subject_prepared | /^Your public link for <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file> expired$/ |
    And the activity number 2 of user "Alice" should match these properties:
      | type             | /^shared$/                                                                                                                                |
      | user             | /^Alice$/                                                                                                                                 |
      | affecteduser     | /^Alice$/                                                                                                                                 |
      | app              | /^files_sharing$/                                                                                                                         |
      | subject          | /^shared_link_self$/                                                                                                                      |
      | object_name      | /^\/lorem.txt$/                                                                                                                           |
      | object_type      | /^files$/                                                                                                                                 |
      | subject_prepared | /^You shared <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=lorem\.txt\" id=\"\d+\">lorem\.txt<\/file> via link$/ |
    And the last share id should not be included in the response


  Scenario: check activity after renaming a shared folder
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has shared folder "/FOLDER" with user "Brian"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Alice" moves folder "/FOLDER" to "/PARENT" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_renamed$/                                                                                                                                                                                                          |
      | user             | /^Alice$/                                                                                                                                                                                                                 |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                 |
      | app              | /^files$/                                                                                                                                                                                                                 |
      | subject          | /^renamed_self$/                                                                                                                                                                                                          |
      | object_name      | /^\/PARENT/                                                                                                                                                                                                               |
      | object_type      | /^files$/                                                                                                                                                                                                                 |
      | typeicon         | /^icon-rename/                                                                                                                                                                                                            |
      | subject_prepared | /^You renamed <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/&scrollto=FOLDER\" id=\"\">FOLDER<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/PARENT\" id=\"\d+\">PARENT<\/file>$/ |
    And user "Brian" should not have any activity entries with type "file_renamed$"


  Scenario: rename a file inside a shared folder
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has uploaded file with content "file to share" to "/FOLDER/textfile0.txt"
    And user "Alice" has shared folder "/FOLDER" with user "Brian"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Alice" moves file "/FOLDER/textfile0.txt" to "/FOLDER/textfile1.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_renamed$/                                                                                                                                                                                                                                                                                 |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                        |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                        |
      | app              | /^files$/                                                                                                                                                                                                                                                                                        |
      | subject          | /^renamed_self$/                                                                                                                                                                                                                                                                                 |
      | object_name      | /^\/FOLDER\/textfile1\.txt/                                                                                                                                                                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                        |
      | typeicon         | /^icon-rename/                                                                                                                                                                                                                                                                                   |
      | subject_prepared | /^You renamed <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile0\.txt\" id=\"\">FOLDER\/textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile1\.txt\" id=\"\d+\">FOLDER\/textfile1\.txt<\/file>/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_renamed$/                                                                                                                                                                                                                                                                                                                             |
      | user             | /^Alice/                                                                                                                                                                                                                                                                                                                                     |
      | affecteduser     | /^Brian$/                                                                                                                                                                                                                                                                                                                                    |
      | app              | /^files$/                                                                                                                                                                                                                                                                                                                                    |
      | subject          | /^renamed_by/                                                                                                                                                                                                                                                                                                                                |
      | object_name      | /^\/FOLDER\/textfile1\.txt/                                                                                                                                                                                                                                                                                                                  |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                                                    |
      | typeicon         | /^icon-rename/                                                                                                                                                                                                                                                                                                                               |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> renamed <file link="%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile0\.txt" id=\"\">FOLDER\/textfile0\.txt<\/file> to <file link="%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile1\.txt\" id=\"\d+\">FOLDER\/textfile1\.txt<\/file>$/ |


  Scenario: move a file into a share
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has uploaded file with content "file to share" to "/textfile0.txt"
    And user "Alice" has shared folder "FOLDER" with user "Brian"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Alice" moves file "/textfile0.txt" to "/FOLDER/textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_moved$/                                                                                                                                                                                                                                                                   |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                        |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                        |
      | app              | /^files$/                                                                                                                                                                                                                                                                        |
      | subject          | /^moved_self$/                                                                                                                                                                                                                                                                   |
      | object_name      | /^\/FOLDER\/textfile0\.txt/                                                                                                                                                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                        |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                     |
      | subject_prepared | /^You moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/\&scrollto=textfile0\.txt\" id=\"\">textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile0\.txt\" id=\"\d+\">FOLDER\/textfile0\.txt<\/file>/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_created/                                                                                                                                                                                        |
      | user             | /^Alice/                                                                                                                                                                                               |
      | affecteduser     | /^Brian$/                                                                                                                                                                                              |
      | app              | /^files$/                                                                                                                                                                                              |
      | subject          | /^created_by/                                                                                                                                                                                          |
      | object_name      | /^\/FOLDER\/textfile0\.txt/                                                                                                                                                                            |
      | object_type      | /^files$/                                                                                                                                                                                              |
      | typeicon         | /^icon-add-color/                                                                                                                                                                                      |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> created <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile0\.txt\" id=\"\d+\">FOLDER\/textfile0\.txt<\/file>$/ |


  Scenario: move a file into a share (inside Shares folder)
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And the administrator has set the default folder for received shares to "Shares"
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has uploaded file with content "file to share" to "/textfile0.txt"
    And user "Alice" has shared folder "FOLDER" with user "Brian"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Alice" moves file "/textfile0.txt" to "/FOLDER/textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_moved$/                                                                                                                                                                                                                                                                   |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                        |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                        |
      | app              | /^files$/                                                                                                                                                                                                                                                                        |
      | subject          | /^moved_self$/                                                                                                                                                                                                                                                                   |
      | object_name      | /^\/FOLDER\/textfile0\.txt/                                                                                                                                                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                        |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                     |
      | subject_prepared | /^You moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/\&scrollto=textfile0\.txt\" id=\"\">textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile0\.txt\" id=\"\d+\">FOLDER\/textfile0\.txt<\/file>/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_created/                                                                                                                                                                                                        |
      | user             | /^Alice/                                                                                                                                                                                                               |
      | affecteduser     | /^Brian$/                                                                                                                                                                                                              |
      | app              | /^files$/                                                                                                                                                                                                              |
      | subject          | /^created_by/                                                                                                                                                                                                          |
      | object_name      | /^\/Shares\/FOLDER\/textfile0\.txt/                                                                                                                                                                                    |
      | object_type      | /^files$/                                                                                                                                                                                                              |
      | typeicon         | /^icon-add-color/                                                                                                                                                                                                      |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> created <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/Shares\/FOLDER\&scrollto=textfile0\.txt\" id=\"\d+\">Shares\/FOLDER\/textfile0\.txt<\/file>$/ |


  Scenario: move a file out of a share
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has created folder "FOLDER"
    And user "Alice" has uploaded file with content "file to share" to "/FOLDER/textfile0.txt"
    And user "Alice" has shared folder "FOLDER" with user "Brian"
    And user "Brian" has accepted share "/FOLDER" offered by user "Alice"
    When user "Alice" moves file "/FOLDER/textfile0.txt" to "/textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_moved$/                                                                                                                                                                                                                                                                  |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                       |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                       |
      | app              | /^files$/                                                                                                                                                                                                                                                                       |
      | subject          | /^moved_self$/                                                                                                                                                                                                                                                                  |
      | object_name      | /^\/textfile0\.txt/                                                                                                                                                                                                                                                             |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                       |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                    |
      | subject_prepared | /^You moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile0\.txt\" id=\"\">FOLDER\/textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/\&scrollto=textfile0\.txt" id=\"\d+\">textfile0\.txt<\/file>/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_deleted/                                                                                                                                                                                        |
      | user             | /^Alice/                                                                                                                                                                                               |
      | affecteduser     | /^Brian$/                                                                                                                                                                                              |
      | app              | /^files$/                                                                                                                                                                                              |
      | subject          | /^deleted_by/                                                                                                                                                                                          |
      | object_name      | /^\/FOLDER\/textfile0\.txt/                                                                                                                                                                            |
      | object_type      | /^files$/                                                                                                                                                                                              |
      | typeicon         | /^icon-delete-color/                                                                                                                                                                                   |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FOLDER\&scrollto=textfile0\.txt\" id=\"\d+\">FOLDER\/textfile0\.txt<\/file>$/ |


  Scenario: move a file inside a subfolder of a shared folder
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And user "Alice" has created folder "folder"
    And user "Alice" has created folder "folder/sub"
    And user "Alice" has uploaded file with content "file to share" to "/folder/textfile0.txt"
    And user "Alice" has shared folder "folder" with user "Brian"
    And user "Brian" has accepted share "/folder" offered by user "Alice"
    When user "Alice" moves file "/folder/textfile0.txt" to "/folder/sub/textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_moved/                                                                                                                                                                                                                                                                                             |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                                 |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                                 |
      | app              | /^files$/                                                                                                                                                                                                                                                                                                 |
      | subject          | /^moved_self$/                                                                                                                                                                                                                                                                                            |
      | object_name      | /^\/folder\/sub\/textfile0\.txt/                                                                                                                                                                                                                                                                          |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                 |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                                              |
      | subject_prepared | /^You moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\&scrollto=textfile0\.txt\" id=\"\">folder\/textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\/sub\&scrollto=textfile0\.txt\" id=\"\d+\">folder\/sub\/textfile0\.txt<\/file>$/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_moved$/                                                                                                                                                                                                                                                                                                                                          |
      | user             | /^Alice/                                                                                                                                                                                                                                                                                                                                                |
      | affecteduser     | /^Brian$/                                                                                                                                                                                                                                                                                                                                               |
      | app              | /^files$/                                                                                                                                                                                                                                                                                                                                               |
      | subject          | /^moved_by/                                                                                                                                                                                                                                                                                                                                             |
      | object_name      | /^\/folder\/sub\/textfile0\.txt/                                                                                                                                                                                                                                                                                                                        |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                                                               |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                                                                                            |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\&scrollto=textfile0\.txt\" id=\"\">folder\/textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\/sub\&scrollto=textfile0\.txt\" id=\"\d+\">folder\/sub\/textfile0\.txt<\/file>$/ |

  Scenario: move a file inside a subfolder of a shared folder (into Shares folder)
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
    And the administrator has set the default folder for received shares to "Shares"
    And user "Alice" has created folder "folder"
    And user "Alice" has created folder "folder/sub"
    And user "Alice" has uploaded file with content "file to share" to "/folder/textfile0.txt"
    And user "Alice" has shared folder "folder" with user "Brian"
    And user "Brian" has accepted share "/folder" offered by user "Alice"
    When user "Alice" moves file "/folder/textfile0.txt" to "/folder/sub/textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_moved$/                                                                                                                                                                                                                                                                                           |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                                |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                                |
      | app              | /^files$/                                                                                                                                                                                                                                                                                                |
      | subject          | /^moved_self$/                                                                                                                                                                                                                                                                                           |
      | object_name      | /^\/folder\/sub\/textfile0\.txt/                                                                                                                                                                                                                                                                         |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                                             |
      | subject_prepared | /^You moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\&scrollto=textfile0\.txt\" id=\"\">folder\/textfile0\.txt<\/file> to <file link="%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/folder\/sub\&scrollto=textfile0\.txt\" id=\"\d+\">folder\/sub\/textfile0\.txt<\/file>$/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_moved$/                                                                                                                                                                                                                                |
      | user             | /^Alice/                                                                                                                                                                                                                                      |
      | affecteduser     | /^Brian$/                                                                                                                                                                                                                                     |
      | app              | /^files$/                                                                                                                                                                                                                                     |
      | subject          | /^moved_by/                                                                                                                                                                                                                          |
      | object_name      | /^\/Shares\/folder\/sub\/textfile0\.txt/                                                                                                                                                                                                      |
      | object_type      | /^files$/                                                                                                                                                                                                                                     |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                  |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/Shares\/folder\&scrollto=textfile0\.txt\" id=\"\">Shares\/folder\/textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/Shares\/folder\/sub\&scrollto=textfile0\.txt\" id=\"\d+\">Shares\/folder\/sub\/textfile0\.txt<\/file>$/    |


  Scenario: move a file between shares
    Given these users have been created with default attributes and without skeleton files:
      | username |
      | Alice    |
      | Brian    |
      | Carol    |
    And user "Alice" has created folder "FolderForBrian"
    And user "Alice" has created folder "FolderForCarol"
    And user "Alice" has uploaded file with content "file to move" to "/FolderForBrian/textfile0.txt"
    And user "Alice" has shared folder "FolderForBrian" with user "Brian"
    And user "Alice" has shared folder "FolderForCarol" with user "Carol"
    And user "Brian" has accepted share "/FolderForBrian" offered by user "Alice"
    And user "Carol" has accepted share "/FolderForCarol" offered by user "Alice"
    When user "Alice" moves file "/FolderForBrian/textfile0.txt" to "/FolderForCarol/textfile0.txt" using the WebDAV API
    Then the activity number 1 of user "Alice" should match these properties:
      | type             | /^file_moved$/                                                                                                                                                                                                                                                                                                                    |
      | user             | /^Alice$/                                                                                                                                                                                                                                                                                                                         |
      | affecteduser     | /^Alice$/                                                                                                                                                                                                                                                                                                                         |
      | app              | /^files$/                                                                                                                                                                                                                                                                                                                         |
      | subject          | /^moved_self$/                                                                                                                                                                                                                                                                                                                    |
      | object_name      | /^\/FolderForCarol\/textfile0\.txt/                                                                                                                                                                                                                                                                                               |
      | object_type      | /^files$/                                                                                                                                                                                                                                                                                                                         |
      | typeicon         | /^icon-move/                                                                                                                                                                                                                                                                                                                      |
      | subject_prepared | /^You moved <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FolderForBrian\&scrollto=textfile0\.txt\" id=\"\">FolderForBrian\/textfile0\.txt<\/file> to <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FolderForCarol\&scrollto=textfile0\.txt\" id=\"\d+\">FolderForCarol\/textfile0\.txt<\/file>/ |
    And the activity number 1 of user "Brian" should match these properties:
      | type             | /^file_deleted/                                                                                                                                                                                                        |
      | user             | /^Alice/                                                                                                                                                                                                               |
      | affecteduser     | /^Brian/                                                                                                                                                                                                              |
      | app              | /^files$/                                                                                                                                                                                                              |
      | subject          | /^deleted_by/                                                                                                                                                                                                          |
      | object_name      | /^\/FolderForBrian\/textfile0\.txt/                                                                                                                                                                                            |
      | object_type      | /^files$/                                                                                                                                                                                                              |
      | typeicon         | /^icon-delete/                                                                                                                                                                                                      |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> deleted <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FolderForBrian\&scrollto=textfile0\.txt\" id=\"\d+\">FolderForBrian\/textfile0\.txt<\/file>$/ |
    And the activity number 1 of user "Carol" should match these properties:
      | type             | /^file_created/                                                                                                                                                                                                        |
      | user             | /^Alice/                                                                                                                                                                                                               |
      | affecteduser     | /^Carol/                                                                                                                                                                                                              |
      | app              | /^files$/                                                                                                                                                                                                              |
      | subject          | /^created_by/                                                                                                                                                                                                          |
      | object_name      | /^\/FolderForCarol\/textfile0\.txt/                                                                                                                                                                                            |
      | object_type      | /^files$/                                                                                                                                                                                                              |
      | typeicon         | /^icon-add-color/                                                                                                                                                                                                      |
      | subject_prepared | /^<user display-name=\"Alice Hansen\">Alice<\/user> created <file link=\"%base_url%\/(index\.php\/)?apps\/files\/\?dir=\/FolderForCarol\&scrollto=textfile0\.txt\" id=\"\d+\">FolderForCarol\/textfile0\.txt<\/file>$/ |
