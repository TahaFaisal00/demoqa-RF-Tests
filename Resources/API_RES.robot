*** Settings ***
Library                       RequestsLibrary
Library                       FakerLibrary
Library                       String
Resource                      API_DataBase.robot

*** Keywords ***
Open Session
    [Documentation]      open HTTP session. Used as suite Setup
    Create Session       ${ALIAS}    ${BASE_URL}

Create Account Details
    ${fake_user_name}=       FakerLibrary.User Name
    ${fake_password}=        FakerLibrary.Password
    &{TEST_ACCOUNT}=      Create Dictionary        user_name=${fake_user_name}      password=${fake_password}
    RETURN      &{TEST_ACCOUNT}

Build Create Account Body
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
    ${body}=        Build Create Account Body           ${account}
    ${response}=      Send Create Account Request       ${body}
    VAR     ${ACCOUNT_ID}       ${response.json()}[userID]      scope=TEST
    RETURN      ${response}

Build Generate Token Body
    [Arguments]     ${account}
    &{body}=        Create Dictionary            userName=${account.user_name}               password=${account.password}
    RETURN      ${body}

Send Generate Token Request
    [Arguments]     ${body}
    ${response}=        POST On Session     ${ALIAS}       ${GENERATE_TOKEN_API}      json=${body}
    RETURN      ${response}

Generate Token Via API
    [Documentation]     Generates a token for the account. Used together with Create Account Via API as test setup.
    ${body}=       Build Generate Token Body     ${TEST_ACCOUNT}
    ${response}=        Send Generate Token Request     ${body}
    VAR    ${TOKEN}     ${response.json()}[token]       scope=TEST
    RETURN      ${response}

Create Authenticated Account Via API
    [Documentation]     Create account and it's token. it makes TEST_ACCOUNT, ACCOUNT_ID and TOKEN test variables.
    ...                 Used as test setup
    Create Account Via API
    Generate Token Via API

Build Delete Account Headers
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
    ${headers}=     Build Delete Account Headers        ${TOKEN}
    ${response}=        Send Delete Account Request         ${headers}      ${ACCOUNT_ID}
    RETURN      ${response}




















