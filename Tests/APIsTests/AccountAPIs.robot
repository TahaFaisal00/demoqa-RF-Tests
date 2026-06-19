*** Settings ***
Library         RequestsLibrary
Library         SeleniumLibrary

Suite Setup     Create Session    deqoma    ${BASE_URL}

*** Variables ***
${BASE_URL}             https://demoqa.com/
${TOKEN}                eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTmFtZSI6IlRhaGEwMCIsInBhc3N3b3JkIjoiVGFoYTIwMDEhISEiLCJpYXQiOjE3Nzk2MzgyNTd9.4AXB6PLXamPZDwow-u3iEdP_qmPTggD3MNymWe3G_rM
*** Test Cases ***
POST Check if an Account is Authorized - Returns 200 with Valid Required Fields
    [Tags]      sanity      api     post        positive        account
    &{body}=        Create Dictionary            userName=Taha00               password=Taha2001!!!
    &{headers}=     Create Dictionary       Authorization=Bearer ${TOKEN}
    ${response}=        POST On Session     deqoma       /Account/v1/Authorized      json=${body}       headers=${headers}
    Status Should Be    expected_status=200
    Log    message=${response.json()}

POST Check if an Account is Authorized - Returns 400 with Invalid or Missing Required Fields
    [Tags]      sanity      api     post        negative        account
    &{body}=        Create Dictionary                           password=x
    ${response}=        POST On Session     deqoma       /Account/v1/Authorized      json=${body}       expected_status=400
    Log    message=${response.json()}


POST Check if a Non Exist Account is Authorized - Returns 404 with Valid Required Fields
    [Tags]      sanity      api     post        negative        account
    &{body}=        Create Dictionary            userName=Taha0000               password=Taha2001!!!00
    ${response}=        POST On Session     deqoma       /Account/v1/Authorized      json=${body}          expected_status=404
    Log    message=${response.json()}






POST Generate a Token for an Account - Returns 200 with Valid Required Fields
    [Tags]      sanity      api     post        positive        account
    &{body}=        Create Dictionary            userName=Taha00               password=Taha2001!!!
    ${response}=        POST On Session     deqoma       /Account/v1/GenerateToken      json=${body}
    Status Should Be    expected_status=200
    Log    message=${response.json()}
    Set Variable       ${Token}              ${response.json()}[token]
    Set Suite Variable          ${Token}

POST Generate a Token for an Account - Returns 400 with Invalid or Missing Required Fields
    [Tags]      sanity      api     post        negative        account
    &{body}=        Create Dictionary                           password=x
    ${response}=        POST On Session     deqoma       /Account/v1/Authorized      json=${body}       expected_status=400
    Log    message=${response.json()}


POST Generate a Token for Non Exist Account - Returns 404 with Valid Required Fields
    [Tags]      sanity      api     post        negative        account
    &{body}=        Create Dictionary            userName=Taha0000               password=Taha2001!!!00
    ${response}=        POST On Session     deqoma       /Account/v1/Authorized      json=${body}          expected_status=404
    Log    message=${response.json()}










POST Create an Account - Returns 201 with Valid Required Fields
    [Tags]      sanity      api     post        positive        account
    &{body}=        Create Dictionary            userName=Taha021               password=Taha2001!!!
    ${response}=        POST On Session     deqoma       /Account/v1/User      json=${body}
    Status Should Be    expected_status=201
    Log    message=${response.json()}
#"userID":"84d46a79-b0df-4066-acd2-7d7a09d87d87"
#'userID': '7187cfbe-4266-42bb-937e-09bfb4f40f50
POST Create an Account - Returns 400 with Invalid or Missing Required Fields
    [Tags]      sanity      api     post        negative        account
    &{body}=        Create Dictionary                           password=x
    ${response}=        POST On Session     deqoma       /Account/v1/User      json=${body}             expected_status=400
    Log    message=${response.json()}

POST Create an Account - Returns 406 with Already Used userName and Password
    [Tags]      sanity      api     post        negative        account
    &{body}=        Create Dictionary            userName=Taha00               password=Taha2001!!!
    ${response}=        POST On Session     deqoma       /Account/v1/User      json=${body}             expected_status=406
    Log    message=${response.json()}



Delete an Account by ID - Returns 204 with Valid accountId
    [Tags]      bug     api     delete        positive        account        #swagger doc error  # Bug 1: Swagger documents success as 200, API returns 204 # Bug 2: 204 response includes a body — violates HTTP spec (204 = No Content)
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        8c8205b6-5258-44b0-b1b0-7ad11f8db43a
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}
    Status Should Be    expected_status=204
    Log    message=${response.json()}

Delete an Already Deleted Account by ID - Returns 200 with Valid accountId
    [Tags]      bug     api      delete        positive        account          #Inconsistent behavior
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        8c8205b6-5258-44b0-b1b0-7ad11f8db43a
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=204
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=200
    Log    message=${response.json()}


Delete an Account by ID - Returns 200 with Invalid accountId
    [Tags]      bug     api      delete        positive        account         #response should return 401     #Inconsistent behavior   #204 and 401 descriptions are literally swapped.
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        x4d46xxx-xxdf-40xx-axxd2-7d7a09xxxxxx
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=200
    Log    message=${response.json()}

Delete an Account by ID - Returns 401 Unauthorized
    [Tags]      bug     api      delete        negative        account      #204 and 401 descriptions are literally swapped.
    ${UUID}=        Set Variable        84d46a79-b0df-4066-acd2-7d7a09d87d87
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=401
    Log    message=${response.json()}







GET Account Details by ID - Returns 200 with Valid accountId
    [Tags]      sanity      api     get        positive        account
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        84d46a79-b0df-4066-acd2-7d7a09d87d87
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        GET On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}
    Status Should Be    expected_status=200
    Log    message=${response.json()}

GET Account Details by ID - Returns 401 with Invalid accountId
    [Tags]      sanity      api     get        negative        account
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        x4d46xxx-xxdf-40xx-axxd2-7d7a09xxxxxx
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        GET On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=401
    Log    message=${response.json()}

GET Account Details by ID - Returns 401 Unauthorized
    [Tags]      sanity      api     get        negative        account
    ${UUID}=        Set Variable        84d46a79-b0df-4066-acd2-7d7a09d87d87
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        GET On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=401
    Log    message=${response.json()}

*** Keywords ***
POST Generate a Token for an Account
    &{body}=        Create Dictionary            userName=Taha02               password=Taha2001!!!
    ${response}=        POST On Session     deqoma       /Account/v1/GenerateToken      json=${body}
    Status Should Be    expected_status=200
    Log    message=${response.json()}
    ${Token}=       Set Variable         ${response.json()}[token]
    Set Suite Variable          ${Token}