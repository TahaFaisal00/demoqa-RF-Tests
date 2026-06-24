*** Settings ***
Library         RequestsLibrary
Library         SeleniumLibrary
Resource    ../../Resources/API_RES.robot
Suite Setup     Open Session

*** Test Cases ***
GET Bookstore Books - Returns 200
    [Documentation]     Get all the books with their details from the bookstore. Verify response code and message.
    [Tags]      functional      api     get      positive        bookstore
    ${response}=        Get Bookstore Books Via API
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_BOOKS}


Create List Of Books - Valid Fields - Returns 201
    [Documentation]     Create list of book using the given books ISBNs. Requires authorized account.
    ...                 Verify response and code.
    [Tags]      functional      api     post        positive        bookstore
    [Setup]     Create Authenticated Account Via API
    ${response}=        Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    Verify Resposne Code    ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_BOOKS}
    [Teardown]      Delete Account Via API

Create List Of Books - Unauthorized - Returns 401
    [Documentation]     Create list of book using the given books ISBNs using unauthorized account.
    ...                 Verify response and code.
    [Tags]      functional      api     post        negative        bookstore
    [Setup]     Create Account Via API
    ${response}=        Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    Verify Resposne Code    ${NOT_AUTHORIZED_CODE}
    Verify Response Message    ${response}    ${NOT_AUTHORIZED_MESSAGE}
    Generate Token Via API
    [Teardown]      Delete Account Via API

Create List Of Books - Missing Fields - Returns 400
    [Documentation]     Create list of book without providing books ISBNs. Verify Response code and message.
    ...                 BUG: when sending a request without the required field the API should return json type error message.
    ...                 but the API is returning text/html type content that is leaking internal paths, Sequelize, MySQL.
    [Tags]      bug      api     post        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Create List Of Books With Missing Field Via API
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Headers Content type      ${response}        ${CONTENT_TYPE_TEXT_HTML}
    [Teardown]      Delete Account Via API

Create List Of Books - Invalid Fields - Returns 400
    [Documentation]     Create list of book using invalid book ISBN. Requires authorized account.
    ...                 Verify response and code.
    [Tags]      functional      api     post        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    ${response}=        Create List Of Books Via API        ${INVALID_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}    ${BOOK_ISBN_NOT_AVAILABLE_MESSAGE}
    [Teardown]      Delete Account Via API






Delete a List of Books From an Account by User ID - Return 204 with Valid userID
    [Tags]      bug      api     delete        positive        bookstore     #04 documents a response body that doesn't exist — misleading to any developer reading it
    POST a List of Books
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{params}=      Create Dictionary           UserId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Books       params=${params}        headers=${headers}
    Status Should Be    expected_status=204


Delete a List of Books That Was Never Created From an Account by User ID - Return 204 with Valid userID
    [Tags]      bug      api     delete        positive        bookstore          #Inconsistent behavior
    POST Generate a Token for an Account
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{params}=      Create Dictionary           UserId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Books       params=${params}        headers=${headers}
    Status Should Be    expected_status=204


Delete an Already Deleted List of Books From an Account by User ID - Return 204 with Valid userID
    [Tags]     bug      api     delete        positive        bookstore              #Inconsistent behavior
    POST Generate a Token for an Account
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{params}=      Create Dictionary           UserId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Books       params=${params}        headers=${headers}
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Books       params=${params}        headers=${headers}
    Status Should Be    expected_status=204

Delete a List of Books From an Account by User ID - Return 401 with Invalid userID
    [Tags]      sanity      api     delete        negative        bookstore
    POST a List of Books
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{params}=      Create Dictionary           UserId=xxd46axx-b0df-40xx-xxd2-7d7a09d8xxxx
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Books       params=${params}        headers=${headers}      expected_status=401
    Log    message=${response.json()}

Delete a List of Books From an Account by User ID - Return 401 Unauthorized
    [Tags]      sanity      api     delete        negative        bookstore
    POST a List of Books
    &{params}=      Create Dictionary           UserId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Books       params=${params}        expected_status=401




GET Book Details - Valid ISBN - Returns 200
    [Documentation]     Get a specific book details with Valid ISBN. Verify Response code and message.
    [Tags]     functional      api     get        positive        bookstore
    ${response}=        Get Book Details Via API        ${GIT_POCKET_GUIDE_ISBN}
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_ISBN}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_TITLE}

GET Book Details - Invalid ISBN - Returns 400
    [Documentation]     Get a specific book details with Invalid ISBN. Verify Response code and message.
    [Tags]     functional      api     get        neagtive        bookstore
    ${response}=        Get Book Details Via API            ${INVALID_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}    ${BOOK_ISBN_NOT_AVAILABLE_MESSAGE}

GET Book Details - Missing ISBN - Returns 500
    [Documentation]     Get a book details without ISBN. Verify Response code and message. BUG: when sending a request
    ...                 without the required field the API should return 400 with a json type error message.
    ...                 but the API is returning 500 - internal server error. And a text/html type content that
    ...                 is leaking internal paths, Sequelize, MySQL.
    [Tags]     bug      api     get        negative        bookstore       #500 instead of 400    #: Server exposes internal stack trace and file paths in response body — security issue
    ${response}=        Attempt Get Book Details With Missing ISBN Via API
    Verify Resposne Code    ${INTERNAL_SERVER_ERROR_CODE}
    Verify Response Headers Content type      ${response}        ${CONTENT_TYPE_TEXT_HTML}


Delete a Book From a List of Books of an Account - Return 204 with Valid Required Fields
    [Tags]    bug      api     delete        positive        bookstore     #04 documents a response body that doesn't exist — misleading to any developer reading it
    POST a List of Books
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{body}=      Create Dictionary        isbn=9781449331818                     userId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Book       json=${body}        headers=${headers}
    Status Should Be    expected_status=204
    #Log    message=${response.json()}


Delete a Book That Was Never Added to the Collection - Return 400 with Valid Required Fields
    [Tags]      bug      api     delete        negative        bookstore     # Inconsistent behavior between the two DELETE endpoints + The API returns 400 Bad Request with But 400 means your request is malforme
    POST Generate a Token for an Account
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{body}=      Create Dictionary        isbn=9781449331818                     userId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Book       json=${body}        headers=${headers}       expected_status=400


Delete an ALready Deleted Book From a List of Books of an Account - Return 400 with Valid Required Fields
    [Tags]    bug      api     delete        negative        bookstore     # Inconsistent behavior between the two DELETE endpoints + The API returns 400 Bad Request with But 400 means your request is malforme
    POST a List of Books
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{body}=      Create Dictionary        isbn=9781449331818                     userId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Book       json=${body}        headers=${headers}       expected_status=204
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Book       json=${body}        headers=${headers}       expected_status=400




Delete a Book From a List of Books of an Account - Return 401 with Invalid Required Field
    [Tags]      sanity     api     delete        negative        bookstore
    POST a List of Books
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{params}=      Create Dictionary           UserId=xxd46axx-b0df-40xx-xxd2-7d7a09d8xxxx
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Books       params=${params}        headers=${headers}      expected_status=401
    Log    message=${response.json()}


Delete a Book From a List of Books of an Account - Return 500 with Missing Required Field
    [Tags]      bug     api     delete        negative        bookstore        #500 instead of 400         #: Server exposes internal stack trace and file paths in response body — security issue
    POST a List of Books
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    &{body}=      Create Dictionary                            userId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Book       json=${body}        headers=${headers}       expected_status=500
    Log    message=${response.text}


Delete a Book From a List of Books of an Account - Return 401 Unauthorized
    [Tags]      sanity     api     delete        negative        bookstore
    POST a List of Books
    &{body}=      Create Dictionary        isbn=9781449331818                     userId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    ${response}=     DELETE On Session      deqoma            /BookStore/v1/Book       json=${body}             expected_status=401
    Log    message=${response.json()}





Update a Book by Replacing it with Another by ISBN - Returns 200 with Valid ISBN and Valid Required Fields
    [Documentation]     Replace a book from the book collection of a user with a new book by ISBN.
    ...                 Verify response message and code.
    [Tags]      functional     api     put        positive        bookstore
    [Setup]     Create Authenticated Account Via API
    Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Update Book By Another Via API   ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}        ${SPEAKING_JAVA_SCRIPT_ISBN}
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}        ${RESPONSE_FIELD_BOOKS}
    [Teardown]      Delete Account Via API

Update a Book by Replacing it with Another by ISBN - Returns 400 with Valid ISBN and Invalid Required Fields
    [Documentation]     Replace a book from the book collection of a user with an invalid book ISBN.
    ...                 Verify response message and code.
    [Tags]      functional     api     put        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Update Book By Another Via API   ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}        ${INVALID_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}        ${BOOK_ISBN_NOT_AVAILABLE_MESSAGE}
    [Teardown]      Delete Account Via API

Update a Book by Replacing it with Another by ISBN - Returns 500 with Missing ISBN and Valid Required Fields
    [Documentation]     Replace a book from the book collection of a user with a new book without its ISBN.
    ...                 Verify response message and code.
    ...                 BUG: when sending a request without the required field the API should return json type error message.
    ...                 but the API is returning text/html type content that is leaking internal paths, Sequelize, MySQL.
    [Tags]      bug     api     put        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Attempt Update Book By Another Without New Book ISBN Via API         ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Headers Content type      ${response}        ${CONTENT_TYPE_TEXT_HTML}
    [Teardown]      Delete Account Via API

Update a Book by Replacing it with Another by ISBN - Returns 200 with ISBN of an Already Existing Book in the Required Fields
    [Documentation]      Replace a book from the book collection of a user with an ISBN of a book that already exist
    ...                 in the book collection. Verify response message and code.
    ...                 BUG: the API allows duplicating book in the same collection.
    [Tags]      bug      api     put        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Update Book By Another Via API   ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}        ${GIT_POCKET_GUIDE_ISBN}
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}        ${RESPONSE_FIELD_BOOKS}
    [Teardown]      Delete Account Via API