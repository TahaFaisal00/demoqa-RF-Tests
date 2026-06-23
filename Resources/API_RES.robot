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

Generate Valid Password
    [Documentation]    Builds a DemoQA-compliant password: guarantees ≥1 upper,
    ...                ≥1 lower, ≥1 digit, ≥1 safe special. Avoids JSON-hostile
    ...                chars (" \ space).
    ${upper}=      Evaluate    random.choice(string.ascii_uppercase)    modules=random, string
    ${lower}=      Evaluate    random.choice(string.ascii_lowercase)    modules=random, string
    ${digit}=      Evaluate    random.choice(string.digits)             modules=random, string
    ${special}=    Evaluate    random.choice('!@#$%^&*')                modules=random, string
    ${rest}=       Evaluate    ''.join(random.choices(string.ascii_letters + string.digits, k=8))    modules=random, string
    ${password}=   Evaluate    ''.join(random.sample('${upper}${lower}${digit}${special}${rest}', len('${upper}${lower}${digit}${special}${rest}')))    modules=random, string
    RETURN    ${password}

Create Account Details
    ${fake_user_name}=       FakerLibrary.User Name
    ${fake_password}=        Generate Valid Password
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
    ${response}=        POST On Session     ${ALIAS}       ${CREATE_ACCOUNT_API}      json=${body}      expected_status=anything
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

Attempt Create Account With Already Created Account Credentials Via API
    [Documentation]     Create a new account via api using already created account details.
    ${body}=        Build User Credentials Body            ${TEST_ACCOUNT}
    ${response}=      Send Create Account Request       ${body}
    RETURN      ${response}

Attempt Create Account With Missing Field Via API
    [Documentation]     Create a new account without username.
    ${account}=     Create Account Details
    VAR          &{TEST_ACCOUNT}      &{account}     scope=TEST
    ${body}=        Build User Credentials Body           ${account}
    Remove From Dictionary      ${body}      userName
    ${response}=      Send Create Account Request       ${body}
    RETURN      ${response}

Send Generate Token Request
    [Arguments]     ${body}
    ${response}=        POST On Session     ${ALIAS}       ${GENERATE_TOKEN_API}      json=${body}      expected_status=anything
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
    RETURN      ${response}

Attempt Generate Token With Invalid Fields Via API
    [Documentation]     Generates a token for a non existent account.
    ${body}=       Build User Credentials Body     ${TEST_ACCOUNT}
    Set To Dictionary    ${body}         userName=x
    ${response}=        Send Generate Token Request     ${body}
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
    ${response}=        DELETE On Session     ${ALIAS}       ${delete_account_via_api_with_uuid}        headers=${headers}      expected_status=anything
    RETURN      ${response}

Delete Account Via API
    [Documentation]     Deletes Account by ID. Used as test teardown.
    ${headers}=     Build Authorization Headers        ${TOKEN}
    ${response}=        Send Delete Account Request         ${headers}      ${ACCOUNT_ID}
    RETURN      ${response}

Attempt Delete Account With Invalid Account ID Via API
    [Documentation]     Deletes Account by a non existent account ID.
    ${headers}=     Build Authorization Headers        ${TOKEN}
    ${response}=        Send Delete Account Request         ${headers}      ${INVALID_ACCOUNT_ID}
    RETURN      ${response}

Attempt Delete Account Without Authorization Via API
    [Documentation]     Deletes Account by ID with invalid authorization token.
    ${headers}=     Build Authorization Headers        ${INVALID_TOKEN}
    ${response}=        Send Delete Account Request         ${headers}      ${ACCOUNT_ID}
    RETURN      ${response}


Send Check Accout Authorization Request
    [Arguments]         ${body}
    ${response}=        POST On Session     ${ALIAS}       ${CHECK_ACCOUNT_AUTHORIZATION_API}      json=${body}     expected_status=anything
    RETURN      ${response}

Check Account Authorization Via API
    [Documentation]     Verify if account is logged in or not
    ${body}=        Build User Credentials Body     ${TEST_ACCOUNT}
    ${response}=        Send Check Accout Authorization Request       ${body}
    RETURN      ${response}

Attempt Check Account Authorization With Missing Field Via API
    [Documentation]     Verify if account is logged in or not by using a only password without user name.
    ${body}=        Build User Credentials Body     ${TEST_ACCOUNT}
    Remove From Dictionary      ${body}            userName
    ${response}=        Send Check Accout Authorization Request       ${body}
    RETURN      ${response}

Attempt Check Account Authorization With Invalid Fields Via API
    [Documentation]     Verify if account is logged in or not by using a credentials of non existent account.
    ${body}=        Build User Credentials Body     ${TEST_ACCOUNT}
    Set To Dictionary          ${body}         userName=x
    ${response}=        Send Check Accout Authorization Request       ${body}
    RETURN      ${response}


Send Get Account Details Request
    [Arguments]         ${headers}      ${uuid}
    ${get_account_details_apia_with_uuid}=      Format String    ${GET_ACCOUNT_DETAILS_API}     ${uuid}
    ${response}=        GET On Session     ${ALIAS}       ${get_account_details_apia_with_uuid}        headers=${headers}       expected_status=anything
    RETURN      ${response}

Get Account Details Via API
    [Documentation]     Get an existing account details by ID. Requires authorized account.
    ${headers}=     Build Authorization Headers     ${TOKEN}
    ${response}=        Send Get Account Details Request        ${headers}         ${ACCOUNT_ID}
    RETURN      ${response}

Attempt Get Account Details With Invalid Account ID Via API
    [Documentation]     Get a non existent account details by ID.
    ${headers}=     Build Authorization Headers     ${TOKEN}
    ${response}=        Send Get Account Details Request        ${headers}         ${INVALID_ACCOUNT_ID}
    RETURN      ${response}

Verify Resposne Code
    [Documentation]     Asserts the API's response code equals the expected value.
    [Arguments]         ${response_code}
    Status Should Be    expected_status=${response_code}

Verify Response Message
    [Documentation]     Asserts the message field equals the expected value.
    [Arguments]     ${response}     ${message}
    Should Be Equal    ${response.json()}[message]    ${message}

Verify Response Message Contains
    [Documentation]     Asserts the message field contain the expected value.
    [Arguments]          ${response}      ${message}
    Should Contain    ${response.json()}[message]    ${message}

Verify Response Field Not Empty
    [Documentation]     Asserts the given field in the response body is not message.
    [Arguments]            ${response}      ${field}
    Should Not Be Empty    ${response.json()}[${field}]

Verify Response Body Return True
    [Documentation]     Asserts the body return True in Verify Login Test.
    [Arguments]     ${response}
    ${body}=        Set Variable        ${response.json()}
    Should Be Equal      ${body}       ${True}

Verify Response Result Contain
    [Documentation]     Asserts the result field equals the expected value.
    [Arguments]     ${response}      ${result}
    Should Be Equal    ${response.json()}[result]    ${result}

Send Get Bookstore Books Request
    ${response}=        GET On Session     ${ALIAS}       ${BOOKSTORE_BOOKS_API}
    RETURN      ${response}

Get Bookstore Books Via API
    [Documentation]     Get all books from the bookstore and their details.
    ${resposne}=        Send Get Bookstore Books Request
    RETURN      ${resposne}

Build Create List Of Books Body
    [Arguments]     ${user_id}      @{isbns}
    &{body}=        Create Dictionary           userId=${user_id}             collectionOfIsbns=${isbns}
    RETURN      ${body}

Build Create List Of Books Headers
    [Arguments]     ${token}
    &{headers} =        Create Dictionary       Authorization=Bearer ${token}
    RETURN      ${headers}

Send Create List Of Books Request
    [Arguments]             ${body}     ${headers}
    ${response}=        POST On Session    ${ALIAS}       ${RESPONSE_FIELD_BOOKS}     json=${body}        headers=${headers}
    RETURN      ${response}

Create List Of Books Via API
    [Documentation]     Create a list of books from the given books ISBNs. Requires an authorized user ID.
    ${body}=        Build Create List Of Books Body       ${ACCOUNT_ID}      ${GIT_POCKET_GUIDE_ISBN}       ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${headers}=     Build Create List Of Books Headers      ${TOKEN}
    ${response}=        Send Create List Of Books Request       ${body}     ${headers}
    RETURN      ${response}

Attempt Create List Of Books With Missing Field Via API
    [Documentation]     Create a list of books Without books ISBNs. Requires an authorized user ID.
    ${headers}=     Build Create List Of Books Headers      ${TOKEN}
    ${response}=        Send Create List Of Books Request       ${empty}     ${headers}
    RETURN      ${response}

Attempt Create List Of Books With Invalid Field Via API
    [Documentation]     Create a list of books from the non existent books ISBNs. Requires an authorized user ID.
    ${body}=        Build Create List Of Books Body       ${ACCOUNT_ID}      ${INVALID_ISBN}       ${INVALID_ISBN}
    ${headers}=     Build Create List Of Books Headers      ${TOKEN}
    ${response}=        Send Create List Of Books Request       ${body}     ${headers}
    RETURN      ${response}

Build Delete List Of Books Params
    [Arguments]     ${user_id}
    &{params}=      Create Dictionary           UserId=${user_id}
    RETURN      ${params}

Build Delete List Of Books Headers
    [Arguments]     ${token}
    &{headers} =        Create Dictionary       Authorization=Bearer ${token}
    RETURN      ${headers}

Send Delete List Of Books Request
    [Arguments]      ${params}           ${headers}
    ${response}=     DELETE On Session      ${ALIAS}            ${BOOKSTORE_BOOKS_API}       params=${params}        headers=${headers}
    RETURN

Delete List Of Books Via API
    [Documentation]     Delete the list of book from an authorized user by user ID.
    ${params}=      Build Delete List Of Books Params       ${ACCOUNT_ID}
    ${headers}=     Build Delete List Of Books Headers      ${TOKEN}
    ${response}=        Send Delete List Of Books Request       ${params}       ${headers}
    RETURN      ${response}

Build Get Book Details Params
    [Arguments]     ${book_isbn}
    &{params}=          Create Dictionary           ISBN=${book_isbn}
    RETURN      ${params}

Send Get Book Details Request
    [Arguments]     ${params}
    ${response}=        GET On Session   ${ALIAS}       ${BOOKSTORE_BOOK_API}        params=${params}       expected_status=anything
    RETURN      ${response}

Get Book Details Via API
    [Documentation]     Get a single book details by book ISBN.
    ${params}=      Build Get Book Details Params       ${GIT_POCKET_GUIDE_ISBN}
    ${response}=        Send Get Book Details Request       ${params}
    RETURN      ${response}

Attempt Get Book Details With Invalid ISBN Via API
    [Documentation]     Get a single book details by non existent book ISBN.
    ${params}=      Build Get Book Details Params       ${INVALID_ISBN}
    ${response}=        Send Get Book Details Request       ${params}
    RETURN      ${response}

Attempt Get Book Details With Missing ISBN Via API
    [Documentation]     Get a single book details without ISBN.
    ${params}=      Build Get Book Details Params       ${EMPTY}
    ${response}=        Send Get Book Details Request       ${params}
    RETURN      ${response}




Build Delete Book From List Headers
    [Arguments]     ${token}
    &{headers} =        Create Dictionary       Authorization=Bearer ${token}
    RETURN      ${headers}

Build Delete Book From List Body
    [Arguments]     ${book_isbn}        ${user_id}
    &{body}=      Create Dictionary        isbn=${book_isbn}                    userId=${user_id}
    RETURN      ${bdoy}

Send Delete Book From List Request
    [Arguments]     ${body}     ${headers}
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Book       json=${body}        headers=${headers}
    RETURN      ${response}

Delete Book From List Via API
    [Documentation]     Delete a single book from list of books by book ISBN. Require an authorized user ID
    ${headers}=         Build Delete Book From List Headers         ${TOKEN}
    ${body}=        Build Delete Book From List Body        ${GIT_POCKET_GUIDE_ISBN}            ${ACCOUNT_ID}
    ${response}=            Send Delete Book From List Request      ${body}     ${headers}
    RETURN      ${response}


Build Replace Book By Another Body
    [Arguments]     ${user_id}          ${isbn}
    &{body}=        Create Dictionary           userId=${user_id}             isbn=${isbn}
    RETURN      ${body}

Build Replace Book By Another Headers
    [Arguments]     ${token}
    &{headers} =        Create Dictionary       Authorization=Bearer ${token}
    RETURN      ${token}

Send Replace Book By Another Request
    [Arguments]       ${existing_book_isbn}     ${body}     ${headers}
    ${update_book_by_another_api_with_book_isbn}=       Format String    ${UPDATE_BOOK_BY_ANOTHER_API}       ${existing_book_isbn}
    ${response}=        PUT On Session    ${ALIAS}       ${update_book_by_another_api_with_book_isbn}     json=${body}        headers=${headers}
    RETURN      ${response}

Update Book By Another Via API
    [Documentation]     Replace an existing book from the user book list with another by book ISBN. Require an authorized user ID.
    ${body}=       Build Replace Book By Another Body       ${ACCOUNT_ID}       ${SPEAKING_JAVA_SCRIPT_ISBN}
    ${headers}=     Build Replace Book By Another Headers       ${TOKEN}
    ${response}=        Send Replace Book By Another Request     ${GIT_POCKET_GUIDE_ISBN}              ${body}         ${headers}
    RETURN      ${response}

