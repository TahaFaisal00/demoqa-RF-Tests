*** Settings ***
Library         RequestsLibrary
Library         SeleniumLibrary
Resource    ../../Resources/API_RES.robot
Suite Setup     Open Session

*** Variables ***
${BASE_URL}=             https://demoqa.com/
${TOKEN}                eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTmFtZSI6IlRhaGEwMCIsInBhc3N3b3JkIjoiVGFoYTIwMDEhISEiLCJpYXQiOjE3Nzk2MzgyNTd9.4AXB6PLXamPZDwow-u3iEdP_qmPTggD3MNymWe3G_rM
*** Test Cases ***
GET Bookstore Books - Returns 200
    [Documentation]     Get all the books with their details from the bookstore. Verify response code and message.
    [Tags]      functional      api     get      positive        bookstore
    ${response}=        Get Bookstore Books Via API
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_BOOKS}


POST a List of Books - Returns 201 with Valid Required Fields
    [Tags]      sanity      api     post        positive        bookstore
    POST Generate a Token for an Account
    &{isbn1}=       Create Dictionary               isbn=9781449325862
    &{isbn2}=       Create Dictionary                isbn=9781449331818
    @{collectionOfIsbns}=       Create List      ${isbn1}         ${isbn2}
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             collectionOfIsbns=${collectionOfIsbns}
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        POST On Session    deqoma       /BookStore/v1/Books     json=${body}        headers=${headers}
    Status Should Be    expected_status=201
    Log    message=${response.json()}

POST a List of Books - Returns 401 Unauthorized
    [Tags]      sanity      api     post        negative        bookstore
    &{isbn1}=       Create Dictionary               isbn=9781449325862
    &{isbn2}=       Create Dictionary                isbn=9781449331818
    @{collectionOfIsbns}=       Create List      ${isbn1}         ${isbn2}
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             collectionOfIsbns=${collectionOfIsbns}
    ${response}=        POST On Session    deqoma       /BookStore/v1/Books     json=${body}            expected_status=401
    Log    message=${response.json()}

POST a List of Books - Returns 500 with Missing Required Fields
    [Tags]      bug      api     post        negative        bookstore      #500 instead of 400  #: Server exposes internal stack trace and file paths in response body — security issue
    POST Generate a Token for an Account
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        POST On Session    deqoma       /BookStore/v1/Books     json=${body}        headers=${headers}      expected_status=500

POST a List of Books - Returns 400 with Invalid Required Fields
    [Tags]      sanity      api     post        negative        bookstore
    POST Generate a Token for an Account
    @{collectionOfIsbns}=       Create List      xxxxxxxxxxxxxx
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             collectionOfIsbns=${collectionOfIsbns}
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        POST On Session    deqoma       /BookStore/v1/Books     json=${body}        headers=${headers}      expected_status=400
    Log    message=${response.json()}






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




GET a Book Details by ISBN - Returns 200 with Valid ISBN
    [Tags]     sanity      api     get        positive        bookstore
    &{params}=          Create Dictionary           ISBN=9781449325862
    ${response}=        GET On Session   deqoma       /BookStore/v1/Book        params=${params}
    Status Should Be    expected_status=200
    Log    message=${response.json()}

GET a Book Details by ISBN - Returns 400 with Invalid ISBN
    [Tags]     sanity      api     get        neagtive        bookstore
    &{params}=          Create Dictionary           ISBN=xxxxxx
    ${response}=        GET On Session   deqoma       /BookStore/v1/Book        params=${params}        expected_status=400
    Log    message=${response.json()}

GET a Book Details by ISBN - Returns 500 with Missing ISBN
    [Tags]     bug      api     get        negative        bookstore       #500 instead of 400    #: Server exposes internal stack trace and file paths in response body — security issue
    &{params}=          Create Dictionary
    ${response}=        GET On Session   deqoma       /BookStore/v1/Book        params=${params}        expected_status=500
    Log    message=${response.text}






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
    [Tags]      sanity     api     put        positive        bookstore
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449337711
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable           9781449331818
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}
    Status Should Be    expected_status=200
    Log    message=${response.json()}

Update a Book by Replacing it with Another by ISBN - Returns 400 with Valid ISBN and Invalid Required Fields
    [Tags]      sanity     api     put        negative        bookstore
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=xxxxxxxx
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable           9781449331818
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}       expected_status=400
    Log    message=${response.json()}

Update a Book by Replacing it with Another by ISBN - Returns 400 with Invalid ISBN and Valid Required Fields
    [Tags]      sanity     api     put        negative        bookstore
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449337711
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable           xxxxxxxxxx
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}       expected_status=400
    Log    message=${response.json()}


Update a Book by Replacing it with Another by ISBN - Returns 500 with Missing ISBN and Valid Required Fields
    [Tags]      bug     api     put        negative        bookstore       #500 instead of 400  #: Server exposes internal stack trace and file paths in response body — security issue
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449337711
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}       expected_status=500
    Log    message=${response.text}


Update a Book by Replacing it with Another by ISBN - Returns 401 Unauthorized
    [Tags]      sanity     api     put        negative        bookstore
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449337711
    ${ISBN}=        Set Variable           9781449331818
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}              expected_status=401
    Log    message=${response.json()}


Update a Book by Replacing it with Another by ISBN - Returns 200 with ISBN of an Already Existing Book in the Required Fields
    [Tags]      bug      api     put        positive        bookstore        #it allow duplicating book in the same collection
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449325862
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable           9781449331818
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}
    Status Should Be    expected_status=200
    Log    message=${response.json()}




*** Keywords ***
POST Generate a Token for an Account
    &{body}=        Create Dictionary            userName=Taha00               password=Taha2001!!!
    ${response}=        POST On Session     deqoma       /Account/v1/GenerateToken      json=${body}
    Status Should Be    expected_status=200
    Log    message=${response.json()}
    ${Token}=       Set Variable         ${response.json()}[token]
    Set Suite Variable          ${Token}

POST a List of Books
    POST Generate a Token for an Account
    &{isbn1}=       Create Dictionary               isbn=9781449325862
    &{isbn2}=       Create Dictionary                isbn=9781449331818
    @{collectionOfIsbns}=       Create List      ${isbn1}         ${isbn2}
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             collectionOfIsbns=${collectionOfIsbns}
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        POST On Session    deqoma       /BookStore/v1/Books     json=${body}        headers=${headers}
    Status Should Be    expected_status=201
    Log    message=${response.json()}