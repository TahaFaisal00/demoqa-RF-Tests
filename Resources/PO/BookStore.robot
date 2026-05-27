*** Settings ***
Library                               SeleniumLibrary
Resource                              Resources/Common.robot



*** Variables ***
${MAIN_FIRST_NAME}                    taha
${MAIN_LAST_NAME}                     moe
${MAIN_USERNAME}                      taha001q22
${MAIN_PASSWORD}                      Taha2001!!
${DELETE_ME_FIRST_NAME}               Delete
${DELETE_ME_LAST_NAME}                Me
${DELETE_ME_USERNAME}                 DeleteMe
${DELETE_ME_PASSWORD}                 Taha2001!!




*** Keywords ***

Verify that BookStore Page is Loaded
   Wait Until Element Is Visible        xpath=//span[text()='Login']
Click the Login Button
   Click Element                        xpath=//span[text()='Login']





Write in the Search Bar
    [Arguments]                         ${SEARCH}
    Input Text                          xpath=//*[@id='searchBox']       ${SEARCH}

Click the Search Button
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

Verify the Empty Search Results
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Be Visible           xpath=//*[text()='Speaking JavaScript']
    Element Should Be Visible           xpath=//*[text()='Eloquent JavaScript, Second Edition']

Verify the Invalid Search Results
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']

Verify Searching by Book Title Results
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']

Verify Searching by Author name Results
    Element Should Be Visible           xpath=//*[text()='Designing Evolvable Web APIs with ASP.NET']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']

Verify Searching by Publisher name Results
    Element Should Be Visible           xpath=//*[text()='Eloquent JavaScript, Second Edition']
    Element Should Be Visible           xpath=//*[text()='Understanding ECMAScript 6']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']



2 Books and Their Images
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage0-DrW2Lhj5.jpg']
    Element Should Be Visible           xpath=//*[text()='Learning JavaScript Design Patterns']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage1-CeLeymOA.jpg']
Using the Search Bar
    Input Text                          xpath=//*[@id='searchBox']      Learning JavaScript Design Patterns
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button
the 2 Books and Their Images After Searching
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[@src='/assets/bookimage0-DrW2Lhj5.jpg']
    Element Should Be Visible           xpath=//*[text()='Learning JavaScript Design Patterns']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage1-CeLeymOA.jpg']



Checking a Book Details
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Wait Until Page Contains            9781449325862
    Page Should Contain                 Git Pocket Guide
    Page Should Contain                 Richard E. Silverman
    Page Should Contain                 234
    Page Should Contain                 This pocket guide is the perfect

Click Back To Book Store button
    Click Element                       xpath=//*[text()='Back To Book Store']

Checking a Second Book Details
    Click Element                       xpath=//*[text()='Learning JavaScript Design Patterns']
    Wait Until Page Contains            9781449331818
    Page Should Contain                 Learning JavaScript Design Patterns
    Page Should Contain                 Addy Osmani
    Page Should Contain                 254
    Page Should Contain                 With Learning JavaScript Design Patterns
































Logging in
   [Arguments]                          ${USERNAME}         ${PASSWORD}
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         ${USERNAME}
   Input Text                           xpath=//*[@id='password']         ${PASSWORD}
   Click Element                        xpath=//*[@id='login']
   Wait Until Page Contains             ${USERNAME}

Creating a New Account
   [Arguments]                          ${First_Name}     ${Last_name}     ${USERNAME}      ${PASSWORD}
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,

   Click Button                         xpath=//*[text()='New User']

    Input Text                          xpath=//*[@id='firstname']    ${First_Name}
    Input Text                          xpath=//*[@id='lastname']     ${Last_name}
    Input Text                          xpath=//*[@id='userName']     ${USERNAME}
    Input Text                          xpath=//*[@id='password']     ${PASSWORD}

   Click Button                         xpath=//*[text()='Register']
   Alert Should Be Present              User Registered Successfully.