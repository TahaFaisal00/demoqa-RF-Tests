*** Settings ***
Library         RequestsLibrary
Library         SeleniumLibrary

Suite Setup     Create Session    deqoma    ${BASE_URL}

*** Variables ***
${BASE_URL}=             https://demoqa.com/
${TOKEN}                eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTmFtZSI6IlRhaGEwMCIsInBhc3N3b3JkIjoiVGFoYTIwMDEhISEiLCJpYXQiOjE3Nzk2MzgyNTd9.4AXB6PLXamPZDwow-u3iEdP_qmPTggD3MNymWe3G_rM
*** Test Cases ***
GET Books from bookStore - Returns 200
    [Tags]
    POST Generate a Token for an Account
    ${response}=        GET On Session     deqoma       /BookStore/v1/Books
    Status Should Be    expected_status=200
    Log    message=${response.json()}




POST a List of Books - Returns 201 with Valid Required Fields
    [Tags]
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
    [Tags]
    &{isbn1}=       Create Dictionary               isbn=9781449325862
    &{isbn2}=       Create Dictionary                isbn=9781449331818
    @{collectionOfIsbns}=       Create List      ${isbn1}         ${isbn2}
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             collectionOfIsbns=${collectionOfIsbns}
    ${response}=        POST On Session    deqoma       /BookStore/v1/Books     json=${body}            expected_status=401
    Log    message=${response.json()}

POST a List of Books - Returns 500 with Missing Required Fields
    [Tags]      bug         #500 instead of 400         #: Server exposes internal stack trace and file paths in response body — security issue
    POST Generate a Token for an Account
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        POST On Session    deqoma       /BookStore/v1/Books     json=${body}        headers=${headers}      expected_status=500

POST a List of Books - Returns 400 with Invalid Required Fields
    [Tags]
    POST Generate a Token for an Account
    @{collectionOfIsbns}=       Create List      xxxxxxxxxxxxxx
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             collectionOfIsbns=${collectionOfIsbns}
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        POST On Session    deqoma       /BookStore/v1/Books     json=${body}        headers=${headers}      expected_status=400
    Log    message=${response.json()}


Delete




GET a Book Details by ISBN - Returns 200 with Valid ISBN
    [Tags]
    &{params}=          Create Dictionary           ISBN=9781449325862
    ${response}=        GET On Session   deqoma       /BookStore/v1/Book        params=${params}
    Status Should Be    expected_status=200
    Log    message=${response.json()}

GET a Book Details by ISBN - Returns 200 with Invalid ISBN
    [Tags]
    &{params}=          Create Dictionary           ISBN=xxxxxx
    ${response}=        GET On Session   deqoma       /BookStore/v1/Book        params=${params}        expected_status=400
    Log    message=${response.json()}

GET a Book Details by ISBN - Returns 500 with Missing ISBN
    [Tags]    bug        #500 instead of 400         #: Server exposes internal stack trace and file paths in response body — security issue
    &{params}=          Create Dictionary
    ${response}=        GET On Session   deqoma       /BookStore/v1/Book        params=${params}        expected_status=500
    Log    message=${response.text}


Delete

Update a Book by Replacing it with Another by ISBN - Returns 200 with Valid ISBN and Valid Required Fields
    [Tags]
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449337711
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable           9781449331818
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}
    Status Should Be    expected_status=200
    Log    message=${response.json()}


Update a Book by Replacing it with Another by ISBN - Returns 200 with Valid ISBN and Invalid Required Fields
    [Tags]
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=xxxxxxxx
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable           9781449331818
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}       expected_status=400
    Log    message=${response.json()}

Update a Book by Replacing it with Another by ISBN - Returns 400 with Invalid ISBN and Valid Required Fields
    [Tags]
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449337711
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable           xxxxxxxxxx
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}       expected_status=400
    Log    message=${response.json()}


Update a Book by Replacing it with Another by ISBN - Returns 500 with Missing ISBN and Valid Required Fields
    [Tags]      bug         #500 instead of 400         #: Server exposes internal stack trace and file paths in response body — security issue
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449337711
    &{headers} =        Create Dictionary       Authorization=Bearer ${Token}
    ${ISBN}=        Set Variable
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}        headers=${headers}       expected_status=500
    Log    message=${response.text}


Update a Book by Replacing it with Another by ISBN - Returns 401 Unauthorized
    [Tags]
    POST a List of Books
    &{body}=        Create Dictionary           userId=84d46a79-b0df-4066-acd2-7d7a09d87d87             isbn=9781449337711
    ${ISBN}=        Set Variable           9781449331818
    ${response}=        PUT On Session    deqoma       /BookStore/v1/Books/${ISBN}     json=${body}              expected_status=401
    Log    message=${response.json()}


Update a Book by Replacing it with Another by ISBN - Returns 200 with Invalid ISBN and ISBN of an Already Existing Book in the Required Fields
    [Tags]      bug         #it allow duplicating book in the same collection
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