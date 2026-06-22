*** Settings ***
Library                       RequestsLibrary
Library                       FakerLibrary
Library                       String
Library    Collections
Resource                      API_TestData.robot

*** Keywords ***
Open Session
    [Documentation]      open HTTP session. Used as suite Setup
    Create Session       ${ALIAS}    ${BASE_URL}

Create Account Details
    ${fake_user_name}=       FakerLibrary.User Name
    ${fake_password}=        FakerLibrary.Password
    ${fake_first_name}=      FakerLibrary.First Name Male
    ${fake_last_name}=       FakerLibrary.Last Name Male
    &{TEST_ACCOUNT}=      Create Dictionary        user_name=${fake_user_name}      password=${fake_password}
    ...                   first_name=${fake_first_name}           last_name=${fake_last_name}
    RETURN      &{TEST_ACCOUNT}

Build User Credentials Body
    [Arguments]     ${account}
    &{body}=        Create Dictionary            userName=${account.user_name}               password= ${account.password}
    RETURN      ${body}

Send Create Account Request
    [Arguments]         ${body}
    ${response}=        POST On Session     ${ALIAS}       ${CREATE_ACCOUNT_API}      json=${body}
    RETURN          ${response}

Create Account Via API
    [Documentation]     Create a new account via api using a fresh faker details.
    ...                 Used together with Generate Token Via API as test setup.
    ${account}=     Create Account Details
    VAR          &{TEST_ACCOUNT}      &{account}     scope=TEST
    ${body}=        Build User Credentials Body           ${account}
    ${response}=      Send Create Account Request       ${body}
    VAR     ${ACCOUNT_ID}       ${response.json()}[userID]      scope=TEST
    RETURN      ${response}

Attempt Create Account With Missing Field Via API
    [Documentation]     Create a new account without username.
    ${account}=     Create Account Details
    VAR          &{TEST_ACCOUNT}      &{account}     scope=TEST
    ${body}=        Build User Credentials Body           ${account}
    Remove From Dictionary      ${body}      userName
    ${response}=      Send Create Account Request       ${body}
    VAR     ${ACCOUNT_ID}       ${response.json()}[userID]      scope=TEST
    RETURN      ${response}

Send Generate Token Request
    [Arguments]     ${body}
    ${response}=        POST On Session     ${ALIAS}       ${GENERATE_TOKEN_API}      json=${body}
    RETURN      ${response}

Generate Token Via API
    [Documentation]     Generates a token for the account. Used together with Create Account Via API as test setup.
    ${body}=       Build User Credentials Body     ${TEST_ACCOUNT}
    ${response}=        Send Generate Token Request     ${body}
    VAR    ${TOKEN}     ${response.json()}[token]       scope=TEST
    RETURN      ${response}

Attempt Generate Token With Missing Field Via API
    [Documentation]     Generates a token for an account without entering its username.
    ${body}=       Build User Credentials Body     ${TEST_ACCOUNT}
    Remove From Dictionary      ${body}      userName
    ${response}=        Send Generate Token Request     ${body}
    VAR    ${TOKEN}     ${response.json()}[token]       scope=TEST
    RETURN      ${response}

Attempt Generate Token With Invalid Fields Via API
    [Documentation]     Generates a token for a non existent account.
    ${body}=       Build User Credentials Body     ${TEST_ACCOUNT}
    Set To Dictionary    ${body}         userName=x
    ${response}=        Send Generate Token Request     ${body}
    VAR    ${TOKEN}     ${response.json()}[token]       scope=TEST
    RETURN      ${response}


Create Authenticated Account Via API
    [Documentation]     Create account and it's token. it makes TEST_ACCOUNT, ACCOUNT_ID and TOKEN test variables.
    ...                 Used as test setup
    Create Account Via API
    Generate Token Via API

Build Authorization Headers
    [Arguments]     ${account_token}
    &{headers}=     Create Dictionary       Authorization=Bearer ${account_token}
    RETURN      ${headers}

Send Delete Account Request
    [Arguments]         ${headers}          ${uuid}
    ${delete_account_via_api_with_uuid}=        Format String    ${DELETE_ACCOUNT_API}        ${uuid}
    ${response}=        DELETE On Session     ${ALIAS}       ${delete_account_via_api_with_uuid}        headers=${headers}
    RETURN      ${response}

Delete Account Via API
    [Documentation]     Deletes Account by ID. Used as test teardown.
    ${headers}=     Build Authorization Headers        ${TOKEN}
    ${response}=        Send Delete Account Request         ${headers}      ${ACCOUNT_ID}
    RETURN      ${response}


Send Check Accout Authorization Request
    [Arguments]         ${body}
    ${response}=        POST On Session     ${ALIAS}       ${CHECK_ACCOUNT_AUTHORIZATION_API}      json=${body}
    RETURN      ${response}

Check Account Authorization Via API
    [Documentation]     Verify if account is logged in or not
    ${body}=        Build User Credentials Body     ${TEST_ACCOUNT}
    ${response}=        Send Check Accout Authorization Request       ${body}
    RETURN      ${response}

Attempt Check Accout Authorization With Missing Field Via API
    [Documentation]     Verify if account is logged in or not by using a only password without user name.
    ${body}=        Build User Credentials Body     ${TEST_ACCOUNT}
    Remove From Dictionary      ${body}            userName
    ${response}=        Send Check Accout Authorization Request       ${body}
    RETURN      ${response}

Attempt Check Accout Authorization With Invalid Fields Via API
    [Documentation]     Verify if account is logged in or not by using a credentials of non existent account.
    ${body}=        Build User Credentials Body     ${TEST_ACCOUNT}
    Set To Dictionary          ${body}         userName=x
    ${response}=        Send Check Accout Authorization Request       ${body}
    RETURN      ${response}


Send Get Account Details Request
    [Arguments]         ${headers}      ${uuid}
    ${get_account_details_apia_with_uuid}=      Format String    ${GET_ACCOUNT_DETAILS_API}     ${uuid}
    ${response}=        GET On Session     ${ALIAS}       ${get_account_details_apia_with_uuid}        headers=${headers}
    RETURN      ${response}

Get Account Details Via API
    [Documentation]     Get an existing account details by ID. Requires authorized account.
    ${headers}=     Build Authorization Headers     ${TOKEN}
    ${response}=        Send Get Account Details Request        ${headers}         ${ACCOUNT_ID}
    RETURN      ${response}











