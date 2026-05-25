*** Settings ***
Library                 SeleniumLibrary
Resource                ../Resources/Common.robot
Suite Setup             Common.Launch Browser
Suite Teardown          Common.Close Browser


*** Variables ***




*** Test Cases ***
Register to Book Store
   [Tags]                               smoke       ui     positive
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,

   Click Button                         xpath=//*[text()='New User']

    Input Text                          xpath=//*[@id='firstname']    taha
    Input Text                          xpath=//*[@id='lastname']     moe
    Input Text                          xpath=//*[@id='userName']     taha001q22
    Input Text                          xpath=//*[@id='password']     Taha2001!!

   Click Button                         xpath=//*[text()='Register']
   Alert Should Be Present              User Registered Successfully.


Checking the "Logout" Button
    [Tags]                              sanity       ui     positive
    Logging in
    Click Element                       xpath=//*[text()='Logout']
    Wait Until Page Contains            Login in Book Store


Search Bar - Empty Input Shows All Books
    [Tags]                              sanity       ui     positive
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Input Text                          xpath=//*[@id='searchBox']      ${EMPTY}
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Be Visible           xpath=//*[text()='Speaking JavaScript']
    Element Should Be Visible           xpath=//*[text()='Eloquent JavaScript, Second Edition']
Search Bar - Invalid Input Shows No Books
    [Tags]                              sanity       ui     positive
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']

    Input Text                          xpath=//*[@id='searchBox']    xxxxxxxxxx
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']
Search Bar - Search by Book Title
    [Tags]                              sanity       ui     positive
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Input Text                          xpath=//*[@id='searchBox']    Git Pocket Guide
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']
Search Bar - Search by Author Name
    [Tags]                              sanity       ui     positive
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Input Text                          xpath=//*[@id='searchBox']    Glenn Block et al.
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Be Visible           xpath=//*[text()='Designing Evolvable Web APIs with ASP.NET']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']
Search Bar - Search by Publisher Name
    [Tags]                              sanity       ui     positive
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Input Text                          xpath=//*[@id='searchBox']    No Starch Press
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Be Visible           xpath=//*[text()='Eloquent JavaScript, Second Edition']
    Element Should Be Visible           xpath=//*[text()='Understanding ECMAScript 6']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']









*** Keywords ***
Logging in
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         taha001q22
   Input Text                           xpath=//*[@id='password']         Taha2001!!
   Click Element                        xpath=//*[@id='login']
   Wait Until Page Contains             taha001q22