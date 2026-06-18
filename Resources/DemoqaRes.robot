*** Settings ***
Library                                           SeleniumLibrary
Library                                           Browser
Resource                                          Common.robot

Resource                                          PO/ToolsQA.robot
Resource                                          PO/LogIn.robot
Resource                                          PO/Register.robot
Resource                                          PO/BookStore.robot
Resource                                          PO/Profile.robot

*** Variables ***
${MAIN_FIRST_NAME}                                taha
${MAIN_LAST_NAME}                                 moe
${MAIN_USERNAME}                                  taha001q22
${MAIN_PASSWORD}                                  Taha2001!!
${DELETE_ME_FIRST_NAME}                           Delete
${DELETE_ME_LAST_NAME}                            Me
${DELETE_ME_USERNAME}                             DeleteMe
${DELETE_ME_PASSWORD}                             Taha2001!!

&{VALID_ACCOUNT}                                  USERNAME=${MAIN_USERNAME}         PASSWORD=${MAIN_PASSWORD}         TEXT=${MAIN_USERNAME}

&{DELETED_ACCOUNT}                                USERNAME=${DELETE_ME_USERNAME}    PASSWORD=${DELETE_ME_PASSWORD}    ERROR1=${EMPTY}                          ERROR2=${EMPTY}                    ERROR_TEXT=${INVALID_USERNAME_OR_PASSWORD}
&{EMPTY_USERNAME}                                 USERNAME=${EMPTY}                 PASSWORD=${MAIN_PASSWORD}         ERROR1=${EMPTY_USERNAME_FIELD}           ERROR2=${EMPTY}                    ERROR_TEXT=${EMPTY}
&{EMPTY_PASSWORD}                                 USERNAME=${MAIN_USERNAME}         PASSWORD=${EMPTY}                 ERROR1=${EMPTY_PASSWORD_FIELD}           ERROR2=${EMPTY}                    ERROR_TEXT=${EMPTY}
&{EMPTY_CREDENTIALS}                              USERNAME=${EMPTY}                 PASSWORD=${EMPTY}                 ERROR1=${EMPTY_USERNAME_FIELD}           ERROR2=${EMPTY_PASSWORD_FIELD}     ERROR_TEXT=${EMPTY}

&{SEARCH}                                         EMPTY=${EMPTY}    INVALID=xxxxxxxxxx     BOOKNAME=Git Pocket Guide    AUTHOR=Glenn Block et al.   Publisher=No Starch Press

*** Keywords ***
Verify Search Results Contain
    [Documentation]     verify the search result by asserting the correct books are visible
    [Arguments]                                ${books}
    FOR    ${book}    IN    @{books}
        ${book_locator}=        Format String    ${BOOK_LOCATOR_BASE}           ${book}
        Wait For Elements State    ${book_locator}      visible
    END

Verify Search Results Not Contain
    [Documentation]     verify the search result by asserting the incorrect books are hidden
    [Arguments]                                ${books}
    FOR    ${book}    IN    @{books}
        ${book_locator}=        Format String    ${BOOK_LOCATOR_BASE}           ${book}
        Wait For Elements State    ${book_locator}      hidden
    END

Verify Error Message
    [Documentation]     Verify the error message or locator's element that appear when entering Invalid Credentials
    [Arguments]                                      ${account}
    IF    $account.user_name != "" AND $account.password != ""
        Verify Incorrect Credentials
    ELSE IF    $account.user_name != "" AND $account.password == ""
        Verify Password Field Required
    ELSE IF    $account.user_name == "" AND $account.password != ""
        Verify User Name Field Required
    ELSE
        Verify User Name Field Required
        Verify Password Field Required
    END

Verify User Name Field Required
    [Documentation]     Verify that user name field gets 'is-invalid' state when logging in without user name
    Wait For Elements State    ${EMPTY_USERNAME_FIELD_ERROR}        visible

Verify Password Field Required
    [Documentation]     Verify that password field gets 'is-invalid' state when logging in without password
    Wait For Elements State    ${EMPTY_PASSWORD_FIELD_ERROR}        visible

Verify Incorrect Credentials
    [Documentation]     Verify the error message that appear when trying to log in with credentials of non existent account
    Wait For Elements State    ${INVALID_USERNAME_OR_PASSWORD_ERROR}    visible

Verify Logging in
    [Documentation]     Verify the user is logged in after entering a valid account credentials
    ...     by asserting the profile username matches
   [Arguments]                                       ${user_name}
   Wait For Elements State                           ${USER_NAME_LABEL}          visible
   Get Text                                          ${LOGGED_IN_USER_NAME}    ==    ${user_name}


Click Register And Verify Account Registered
    [Documentation]     Click register button after filling user details and verify the registeration alert.
    ${alert}=      Wait For Alert      action=accept       text=User Registered Successfully.
    Click Register Button
    Wait For        ${alert}


Logging in with Invalid Credentials
    [Arguments]                                  ${CREDENTIALS}
    Go To                                        ${URL}
    Navigate to The Book Store Application
    Navigate to Login Page
    Entering Invalid Credentials                 ${CREDENTIALS}

Navigate to The Book Store Application
    ToolsQA.Verify that TOOLSQA Website is loaded
    ToolsQA.Click on Book Store Application

Navigate to Login Page
    BookStore.Verify that BookStore Page is Loaded
    BookStore.Click the Login Button

Entering Invalid Credentials
   [Arguments]                                   ${CREDENTIALS}
   LogIn.Verify that Login Page is Loaded
   LogIn.Entering Username                       ${CREDENTIALS.USERNAME}
   LogIn.Entering Password                       ${CREDENTIALS.PASSWORD}
   LogIn.Clicking Login
   LogIn.Error Message                           ${CREDENTIALS.ERROR1}        ${CREDENTIALS.ERROR2}        ${CREDENTIALS.ERROR_TEXT}


Using the Book Search Feature
    [Arguments]                                  ${SEARCH}
    Write in the Search Bar                      ${SEARCH}

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

Return to BookStore From Account
    Profile.Clicking Go To Book Store Button

Logging Out
    Profile.Click Logout button
    Profile.Verify Logging Out Done Successfully

Deleting the Account
    Profile.Click Delete Account button
    Profile.Confirm Deleting the Account
    Profile.Verify the Deletion                  ${DELETE_ME_USERNAME}

Account Logged out
    Profile.Verify Logging out

the Books
    BookStore.2 Books and Their Images

the books After using the Search
    BookStore.Using the Search Bar
    BookStore.the 2 Books and Their Images After Searching

Check a Book Details
    BookStore.Checking a Book Details

Return to BookStore From Book Details
    BookStore.Click Back To Book Store button

Check a Second Book Details
    BookStore.Checking a Second Book Details

Check the Second Book Details After Using the Search
    BookStore.Using the Search Bar
    BookStore.Checking a Second Book Details

Open the First Book and Enter the Website
    BookStore.Click on the First Book
    BookStore.Enter the First Book Website

Open the Second Book and Enter the Website
    BookStore.Click on the Second Book
    BookStore.Enter the Second Book Website

Add the First Book to the Collection
    BookStore.Click on the First Book
    BookStore.Click Add To Your Collection button
    BookStore.Verify That Book Was Added Successfully

Add the Fourth Book to the Collection
    BookStore.Click on the Fourth Book
    BookStore.Click Add To Your Collection button
    BookStore.Verify That Book Was Added Successfully

Navigate to Profile and Verify that the Books Are in the Collection
    BookStore.Navigate to Profile Page
    Profile.Verify that the First Book is in the Collection
    Profile.Verify that the Fourth Book is in the Collection

Adding an Already Added Book to the Collection
    BookStore.Click Add To Your Collection button
    BookStore.Verify That Book Was Already Added to Your Collection

Navigate to Profile and Delete The Collection
   BookStore.Navigate to Profile Page
   Profile.Click Delete All Books Button
   Profile.Confirm Deletion
   Profile.Verify That The First Book Is Deleted

Navigating to Profile and Logging in
   [Arguments]                                   ${USERNAME}         ${PASSWORD}
   ToolsQA.Verify that TOOLSQA Website is loaded
   ToolsQA.Click on Book Store Application
   BookStore.Click on Login button
   LogIn.Verify that Login Page is Loaded
   LogIn.Entering Username                       ${USERNAME}
   LogIn.Entering Password                       ${PASSWORD}
   LogIn.Clicking Login
   LogIn.Verify Logging in                       ${USERNAME}

Logging in
   [Arguments]                                   ${USERNAME}         ${PASSWORD}
   LogIn.Verify that Login Page is Loaded
   LogIn.Entering Username                       ${USERNAME}
   LogIn.Entering Password                       ${PASSWORD}
   LogIn.Clicking Login
   LogIn.Verify Logging in                       ${USERNAME}

Navigating to Profile and Creating a New Account
   [Arguments]                                   ${First_Name}     ${Last_name}     ${USERNAME}      ${PASSWORD}
   ToolsQA.Verify that TOOLSQA Website is loaded
   ToolsQA.Click on Book Store Application
   BookStore.Click on Login button
   LogIn.Verify that Login Page is Loaded
   LogIn.Click New User button
   Register.Entering First Name                  ${First_Name}
   Register.Entering Last name                   ${Last_name}
   Register.Entering Username                    ${USERNAME}
   Register.Entering Password                    ${PASSWORD}
   Register.Clicking Register Button
   Register.Verify User Registration
   Register.Click Back to Login Button

