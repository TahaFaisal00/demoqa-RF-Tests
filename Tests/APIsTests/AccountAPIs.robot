*** Settings ***
Resource        ../../Resources/API_RES.robot
Suite Setup     Open Session

*** Test Cases ***
POST Check Account Authorization - Valid Fields - Returns 200
    [Documentation]     Sends a post request to check the given account authorization. verifies
    ...                 the response code and the response body boolean.
    [Tags]      functional      api     post        positive        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Check Account Authorization Via API
    Verify Response Code         ${OK_CODE}
    Verify Response Body Return True    ${response}
    [Teardown]      Delete Account Via API

POST Check Account Authorization - Missing Fields - Returns 400
    [Documentation]     Sends a post request to check the given account authorization without the user name
    ...                 field. verifies the response code and the response message.
    [Tags]      functional      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Check Account Authorization With Missing Field Via API
    Verify Response Code         ${BAD_REQUEST_CODE}
    Verify Response Message Contains    ${response}    ${MISSING_CREDENTIALS_MESSAGE}
    [Teardown]      Delete Account Via API

POST Check Account Authorization - Invalid Fields - Returns 404
    [Documentation]     Sends a post request to check the given account authorization with a non
    ...                 existent account user name. verifies the response code and the response message.
    [Tags]      functional      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Check Account Authorization With Invalid Fields Via API
    Verify Response Code         ${NOT_FOUND_CODE}
    Verify Response Message    ${response}    ${USER_NOT_FOUND_MESSAGE}
    [Teardown]      Delete Account Via API


POST Generate Token For Account - Valid Fields - Returns 200
    [Documentation]     Generates a token for newly created account. Verifies response message and code.
    [Tags]      functional      api     post        positive        account
    [Setup]     Create Account Via API
    ${response}=        Generate Token Via API
    Verify Response Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_TOKEN}
    [Teardown]      Delete Account Via API

POST Generate Token For Account - Missing Required Fields - Returns 400
    [Documentation]     Generates a token for newly created account without providing the username.
    ...                 Verifies response message and code.
    [Tags]      functional      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Generate Token With Missing Field Via API
    Verify Response Code    ${BAD_REQUEST_CODE}
    Verify Response Message Contains    ${response}    ${MISSING_CREDENTIALS_MESSAGE}
    [Teardown]      Delete Account Via API

POST Generate Token For Account - Invalid Required Fields - Returns 200
    [Documentation]     Generates a token for a non existent account. Verifies response message and code.
    ...                 Bug: Response should return 404 not found but it's returning 200.
    [Tags]      bug      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Generate Token With Invalid Fields Via API
    Verify Response Code    ${OK_CODE}
    Verify Response Result Contain    ${response}    ${AUTHORIZATION_FIELD_RESULT}
    [Teardown]      Delete Account Via API


POST Create Account - Valid Fields - Returns 201
    [Documentation]     Creates new account. Verifies response message and code.
    [Tags]      functional      api     post        positive        account
    ${response}=        Create Account Via API
    Verify Response Code               ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_USER_ID_CREATE_ACCOUNT}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_USERNAME}
    [Teardown]  Authenticate Account And Delete It Via API

POST Create Account - Missing Fields - Returns 400
    [Documentation]     Creates new account without user name. Verifies response message and code.
    [Tags]      functional      api     post        negative        account
    ${response}=        Attempt Create Account With Missing Field Via API
    Verify Response Code              ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}    ${MISSING_CREDENTIALS_MESSAGE}

POST Create Account - Already Created Account - Returns 406
    [Documentation]     Creates new account using already created account username and password.
    ...                 Verifies response message and code.
    [Tags]      functional      api     post        negative        account
    [Setup]     Create Account Via API
    ${response}=        Attempt Create Account With Already Created Account Credentials Via API
    Verify Response Code             ${NOT_ACCEPTABLE_CODE}
    Verify Response Message     ${response}    ${USER_EXIST_MESSAGE}
    [Teardown]      Authenticate Account And Delete It Via API


Delete Account - Valid Account ID - Returns 204
    [Documentation]     Deletes Account by account ID. Verifies response message and code.
    ...                 the swagger documents a response body that doesn't exist, misleading to any developer reading it.
    [Tags]      bug     api     delete        positive        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Delete Account Via API
    Verify Response Code    ${NO_CONTENT_CODE}

Delete Account - Already Deleted Account ID - Returns 200
    [Documentation]     Deletes Already Deleted Account by ID. Verifies response message and code.
    [Tags]      bug     api      delete        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Delete Account Via API
    ${response}=        Delete Account Via API
    Verify Response Code    ${OK_CODE}
    Verify Response Message    ${response}       ${INCORRECT_USER_ID_MESSAGE}

Delete Account - Invalid Account ID - Returns 200
    [Documentation]     Deletes Account by Invalid account ID. Verifies response message and code.
    ...                 BUG: API is returning code 200, it should be 400 - bad request according to what the swagger
    ...                 states like the other delete a single item APIs of this website.
    [Tags]      bug     api      delete        negative        account         #response should return 401      #204 and 401 descriptions are literally swapped.
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Delete Account With Invalid Account ID Via API
    Verify Response Code    ${OK_CODE}
    Verify Response Message    ${response}       ${INCORRECT_USER_ID_MESSAGE}

Delete Account - Unauthorized - Returns 401
    [Documentation]     Deletes Account by Unauthorized account ID. Verifies response message and code.
    [Tags]      bug     api      delete        negative        account
    [Setup]     Create Account Via API
    ${response}=        Attempt Delete Account Without Authorization Via API
    Verify Response Code    ${NOT_AUTHORIZED_CODE}
    Verify Response Message    ${response}      ${NOT_AUTHORIZED_MESSAGE}
    [Teardown]      Authenticate Account And Delete It Via API


GET Account Details - Valid Account ID - Returns 200
    [Documentation]     Gets account details by ID. Verifies response message and code.
    [Tags]      functional      api     get        positive        account
    [Setup]   Create Authenticated Account Via API
    ${response}=        Get Account Details Via API
    Status Should Be    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_USERNAME}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_USER_ID_GET_DETAILS}
    [Teardown]      Delete Account Via API

GET Account Details - Invalid Account ID - Returns 401
    [Documentation]     Gets account details by non existent account ID. Verifies response message and code.
    [Tags]      functional      api     get        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Get Account Details With Invalid Account ID Via API
    Status Should Be    ${NOT_AUTHORIZED_CODE}
    Verify Response Message    ${response}    ${USER_NOT_FOUND_MESSAGE}
    [Teardown]      Delete Account Via API

