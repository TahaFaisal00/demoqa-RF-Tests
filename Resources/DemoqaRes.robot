*** Settings ***
Library                               SeleniumLibrary

Resource                              Common.robot

Resource                              PO/ToolsQA.robot
Resource                              PO/LogIn.robot
Resource                              PO/Register.robot
Resource                              PO/BookStore.robot
Resource                              PO/Account.robot

*** Variables ***
${MAIN_FIRST_NAME}                    taha
${MAIN_LAST_NAME}                     moe
${MAIN_USERNAME}                      taha001q22
${MAIN_PASSWORD}                      Taha2001!!
${DELETE_ME_FIRST_NAME}               Delete
${DELETE_ME_LAST_NAME}                Me
${DELETE_ME_USERNAME}                 DeleteMe
${DELETE_ME_PASSWORD}                 Taha2001!!

${EMPTY_USERNAME_FIELD}                   xpath=//*[@id='userName' and @class='mr-sm-2 is-invalid form-control']
${EMPTY_PASSWORD_FIELD}                   xpath=//*[@id='password' and @class='mr-sm-2 is-invalid form-control']
${INVALID_USERNAME_OR_PASSWORD}           Invalid username or password!


&{VALID_ACCOUNT}                USERNAME=${MAIN_USERNAME}         PASSWORD=${MAIN_PASSWORD}         TEXT=${MAIN_USERNAME}

&{DELETED_ACCOUNT}              USERNAME=${DELETE_ME_USERNAME}    PASSWORD=${DELETE_ME_PASSWORD}    ERROR1=${EMPTY}                          ERROR2=${EMPTY}                    ERROR_TEXT=${INVALID_USERNAME_OR_PASSWORD}
&{EMPTY_USERNAME}               USERNAME=${EMPTY}                 PASSWORD=${MAIN_PASSWORD}         ERROR1=${EMPTY_USERNAME_FIELD}           ERROR2=${EMPTY}                    ERROR_TEXT=${EMPTY}
&{EMPTY_PASSWORD}               USERNAME=${MAIN_USERNAME}         PASSWORD=${EMPTY}                 ERROR1=${EMPTY_PASSWORD_FIELD}           ERROR2=${EMPTY}                    ERROR_TEXT=${EMPTY}
&{EMPTY_CREDENTIALS}            USERNAME=${EMPTY}                 PASSWORD=${EMPTY}                 ERROR1=${EMPTY_USERNAME_FIELD}           ERROR2=${EMPTY_PASSWORD_FIELD}     ERROR_TEXT=${EMPTY}





&{SEARCH}                        EMPTY=${EMPTY}    INVALID=xxxxxxxxxx     BOOKNAME=Git Pocket Guide    AUTHOR=Glenn Block et al.   Publisher=No Starch Press









*** Keywords ***

Using the Book Search Feature
    [Arguments]                     ${SEARCH}
    Write in the Search Bar          ${SEARCH}
    Click the Search Button

Empty Search Results
    Verify the Empty Search Results
Verify Search Results
    Verify the Invalid Search Results
Book Title Search Results
    Verify Searching by Book Title Results
Author name Search Results
    Verify Searching by Author name Results
Publisher Empty Search Results
    Verify Searching by Publisher name Results




Logging in with Invalid Credentials
    [Arguments]             ${CREDENTIALS}
    Go To                                ${URL}
    Navigate to The Book Store Application
    Navigate to Login Page
    Entering Invalid Credentials                ${CREDENTIALS}

Navigate to The Book Store Application
    ToolsQA.Varifiy that TOOLSQA Website is loaded
    ToolsQA.Click on Book Store Application

Navigate to Login Page
    BookStore.Verify that BookStore Page is Loaded
    BookStore.Click the Login Button

Entering Invalid Credentials
   [Arguments]                  ${CREDENTIALS}
   LogIn.Verify that Login Page is Loaded
   LogIn.Entering Username              ${CREDENTIALS.USERNAME}
   LogIn.Entering Password              ${CREDENTIALS.PASSWORD}
   LogIn.Clicking Login
   LogIn.Error Message                 ${CREDENTIALS.ERROR1}        ${CREDENTIALS.ERROR2}        ${CREDENTIALS.ERROR_TEXT}

Return to BookStore
    Account.Clicking Go To Book Store Button




Logging Out
    Account.Click Logout button
    Account.Verify Logging Out Done Successfully



Deleting the Account
    Account.Click Delete Account button
    Account.Confirm Deleting the Account
    Account.Verify the Deletion

Account Logged out
    Account.Verify Logging out



the Books
    BookStore.2 Books and Their Images
the books After using the Search
    BookStore.Using the Search Bar
    BookStore.the 2 Books and Their Images After Searching



    Checking a Book Details
    Click Back To Book Store button
    Checking a Second Book Details
    Click Back To Book Store button
    Using the Search Bar
    Checking a Second Book Details


























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