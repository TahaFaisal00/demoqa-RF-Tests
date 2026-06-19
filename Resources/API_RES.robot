*** Settings ***
Library                       RequestsLibrary
Library                       FakerLibrary
Resource                      API_DataBase.robot

*** Keywords ***
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
    [Documentation]     Create a new account via api using a fresh faker details and used as test setup.
    ${account}=     Create Account Details
    VAR          &{TEST_ACCOUNT}      &{account}     scope=TEST
    ${body}=        Build Create Account Body           ${account}
    ${response}=      Send Create Account Request       ${body}
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























