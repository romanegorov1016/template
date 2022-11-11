@demo @debug
Feature: Demo scenarios - For UI Testing

    Should demonstrate main principles of framework

    # Demonstarting UI Scenario with table verification and using DATA Provider
    Scenario Outline: Create a new Exercise with <exerciseDescription> for <clientName>
        Given User navigates to "http://localhost:3000/create"
        When User waits 3 seconds
        When User selects item "option" with text "Anton" from [Username Dropdown] "[data-ta='selectUser']"
            And User enters "<exerciseDescription>" in [Description Field] "[data-ta='description']"
            And User enters value "<exerciseDate>" in [Date Field] "[data-ta='date'] input" by executing script
            And User clicks on [Duration Field] "[data-ta='duration']"
            And User clears text from [Duration Field] "[data-ta='duration']"
            And User enters "<exerciseDuration>" in [Duration Field] "[data-ta='duration']"
            And User clicks [Submit Exercise] "[data-ta='submitExercise']"
        Then Page URL is equal to "http://localhost:3000/"
            And [Exercize] table ".table" data contains values:
            | Username     | Description           | Duration           | Date                    | Actions       |
            | <clientName> | <exerciseDescription> | <exerciseDuration> | <exercisePublishedDate> | edit \ delete |
        Examples:
            | clientName | exerciseDescription | exerciseDuration | exerciseDate | exercisePublishedDate |
            | Anton      | test desc 1         | 20               | 06/04/2021   | 2021-06-04            |
            | Anton      | test desc 2         | 30               | 06/04/2021   | 2021-06-04            |


    # Demonstarting UI Scenario with possibility to remember input data and reuse it in next steps:
    # If {text} parameter in a step starts with 'UNIQUE:' or 'UNIQUE-EMAIL:'
    #   then a unique text value with prefix automation_ and postfix _{TIMESTAMP} should be generated
    # If "UNIQUE:{text}" already exists then the value from storage will be taken.
    # Prefix may be changed in a src\features\support\parameter-types.js
    # Example: "UNIQUE:username" will be stored as "key: value" pare - username: automation_username_1235253235432
    Scenario: Create a new Exercise with a Unique Description
        Given User navigates to "http://localhost:3000/create"
        When User waits 1 second
            And User selects item "option" with text "Anton" from [Username Dropdown] "[data-ta='selectUser']"
            And User enters "UNIQUE:description" in [Description Field] "[data-ta='description']"
            And User clicks [Submit Exercise] "[data-ta='submitExercise']"
        Then [Description Cell] "td" with text "UNIQUE:description" is displayed

    # Demonstarting UI Scenario with possibility to use Regular Expression in verification methods
    # If string starts with "REGEXP:" - get string as regular expression.
    Scenario: Verify a Date format with Regular Expression
        Given User navigates to "http://localhost:3000/create"
        When User waits 1 second
            And User selects item "option" with text "Anton" from [Username Dropdown] "[data-ta='selectUser']"
            And User enters "UNIQUE:description" in [Description Field] "[data-ta='description']"
            And User clicks [Submit Exercise] "[data-ta='submitExercise']"
        Then [Date First Cell] "tr td:nth-child(4)" text is equal to "REGEXP:^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$"


    # Demonstrating of possibility to Download a file
    Scenario: Verify a File Download Correctly
        Given User navigates to "http://localhost:3000/downloadfiles"
        When User waits 1 second
            And User clicks [Download Users Button] "[data-ta='downloadUsers']"
        Then Downloaded file with name "download_users.json" exists

    # Demonstrating of possibility to Upload a file
    Scenario: Verify a File Upload
        Given User navigates to "http://localhost:3000/uploadfiles"
        When User starts itersepting API
        When User uploads [Data File] "test-upload.txt" using [Input] "#upload"
        And User clicks [Upload File Button] "[data-ta='upload_file_btn']"
        Then User verifies intercepted request "/files/upload-file" body is equal to json:
            """
            {
                "status": true,
                "message": "File is uploaded",
                "data": {
                    "name": "test-upload.txt",
                    "mimetype": "text/plain",
                    "size": 72
                }
            }
            """



    # Demonstrating of possibility to create an e2e API Scenario
    # More info about Soft Assert is in beforeScenario() function in common-config.js
    @soft_assert_enable
    Scenario: Verify DELETE User Request
        When User sends "POST" request to "http://localhost:5000/exercises/add" with Body:
            """
            {
                "username": "Anton",
                "description": "test",
                "duration": "50",
                "date": "2021-06-04T14:20:13.935Z"
            }
            """
        Then Status Code is "200"
        When User sends "GET" request to "http://localhost:5000/exercises/"
        Then Status Code is "200"
        When User remembers response property "$..body[?(@.username=='Anton' && @.duration==50)]._id" as "idForDelete"
            And User sends "DELETE" request to "http://localhost:5000/exercises/$idForDelete"
        When User sends "GET" request to "http://localhost:5000/exercises/"
        Then User verifies response does not contain property "duration" in "body" with value "50"
        Then User verifies response does not contain "$..body[?(@.username=='Anton' && @.duration==50)]"



    # Demonstrating a possibility to intercept requests and verify data while UI actions performs
    Scenario: Verify Add New User Intercepted Request
        Given User navigates to "http://localhost:3000/user"
        When User enters "UNIQUE:Test Client" in [Username Field] "[data-ta='username']"
            And User starts itersepting API
            And User clicks [Create User] "input[type='submit']"
        Then User verifies intercepted request "/users/add" body is equal to json:
            """
            {
                "status": "success",
                "username": "$Test Client"
            }
            """

    # Demonstrating of HTML5 drag and drop with execute script.
    # Basic dragAndDrop function might not be working with HTML 5 elements.
    Scenario: Verify drag and drop HTML 5 elements work with executing native js script
        Given User navigates to "http://demo.automationtesting.in/Static.html"
        When User dragAndDrop [Audience] "#angular" to [Exclude Pane] "#droparea" with execute script
            And User waits 3 seconds
        Then User compares screenshot of Portrait "#droparea" to "dnd-completed.png"


    # Demonstarting UI Scenario with set textContent value by executing script
    Scenario: Verify TEXTAREA Html value entered
        Given User navigates to "https://html.com/tags/textarea/"
        When User enters "TEST execute script" in [Description Field] ".disclosure" by executing script
            And User waits 3 seconds
        Then [Description] ".disclosure" text is equal to "TEST execute script"
