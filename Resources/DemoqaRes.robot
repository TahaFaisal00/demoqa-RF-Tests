*** Settings ***
Library                                           Browser
Resource                                          Common.robot

Resource                                          PO/ToolsQA.robot
Resource                                          PO/LogIn.robot
Resource                                          PO/Register.robot
Resource                                          PO/BookStore.robot
Resource                                          PO/Profile.robot

Resource                                          API_RES.robot

Resource                                          UI_TestData.robot
*** Keywords ***
Reload Profile Page And Verify Account Deletion
    [Documentation]     Used to bypass the frontend bug of the delete confirmation window stays open after clicking ok.
    Reload
    Verify Profile Page Loaded
    Wait For Elements State    ${USER_NOT_FOUND_MESSAGE}    visible

Verify Account Logged Out
    [Documentation]     Verify account logged out after clicking logout button and navigating back to profile page.
    Verify Login Page Loaded
    Click Profile Page Link
    Wait For Elements State    ${NOT_LOGGED_IN_MESSAGE}      visible

Verify Book Not In Book Collection
    [Documentation]     Verify deleted book is removed from the book collection in profile page.
    [Arguments]                         ${books}
    FOR    ${book}    IN    @{books}
        ${book_location}=        Format String      ${BOOK_LOCATOR_BASE}        ${book}
        Wait For Elements State    ${book_location}     hidden
    END

Confirm Delete Book And Verify Book Deleted
    [Documentation]     Click OK in the book deletion confirmation window and verify book deleted alert.
    [Arguments]
    ${alert}=       Wait For Alert    action=accept    text=Confirm Delete.
    Profile.Confirm Delete
    Wait For        ${alert}


Verify Book In Book Collection
    [Documentation]     Verify added book exists in the book collection in profile page
    [Arguments]                         ${books}
    FOR    ${book}    IN    @{books}
        ${book_location}=        Format String      ${BOOK_LOCATOR_BASE}        ${book}
        Wait For Elements State    ${book_location}     visible
    END

Verify Book Image
    [Documentation]     Verify that a book have the position-bound image instead of it's own.
    ...     Documents the image/position bug
    [Arguments]         ${book}       ${expected_image}
    ${src}=     Get Image Src       ${book}
    Should Contain    ${src}    ${expected_image}


Verify Book Details
    [Documentation]     Verify book details including ISBN, Sub Title, Author and Publisher in details page.
    [Arguments]                               ${book}
    Get Text    id=ISBN-wrapper >> id=userName-value    ==   ${book.isbn}
    Get Text    id=subtitle-wrapper >> id=userName-value    =   ${book.sub_title}
    Get Text    id=author-wrapper >> id=userName-value    =   ${book.author}
    Get Text    id=publisher-wrapper >> id=userName-value    =   ${book.publisher}

Click Add Book To Collection And Verify Book Already Added
    [Documentation]     Click Add book to collection button in book details page of an already added book and verify the book already added alert.
    ${alert}=       Wait For Alert           action=accept      text=Book already present in the your collection!
    Click Add To Your Collection Button
    Wait For        ${alert}

Click Add Book To Collection And Verify Book Added
    [Documentation]     Click Add book to collection button in book details page and verify the book added alert.
    ${alert}=       Wait For Alert           action=accept      text=Book added to your collection.
    Click Add To Your Collection Button
    Wait For        ${alert}

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

Verify Login Error
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

Navigate To Book Store Application
    [Documentation]     Navigates from main page to book store application and verify its page loaded.
    ToolsQA.Click Book Store Link
    BookStore.Verify BookStore Page Loaded

Navigate To Login Page
    [Documentation]     Navigates to login page and verify its page loaded.
    Profile.Click Login Link
    LogIn.Verify Login Page Loaded

Navigate From Login Page To Register Page
    [Documentation]     Navigates from login page to register page and verify its page loaded.
    LogIn.Click New User Button
    Register.Verify Register Page Loaded

Navigate To Book Store
    [Documentation]     Navigates to book store page and verify its page loaded.
    Profile.Click Book Store Link
    BookStore.Verify BookStore Page Loaded

Navigate To Profile Page
    [Documentation]     Navigates to profile page and verify its page loaded.
    BookStore.Click Profile Page Link
    Profile.Verify Profile Page Loaded

Logging In And Verify
    [Documentation]     Navigate to login page and enter valid credentials and log in and verify it.
    [Arguments]                     ${account}
    Navigate To Login Page
    Log In With Credentials         ${account}
    Verify Logging in               ${account.user_name}

Logging Out And Verify
    [Documentation]     Logs out from the account page and verify it. after signing out the website takes you to login page
    ...                the keyword goes back to profile page and verify that account is logged out.
    Navigate To Login Page
    Profile.Click Logout Button
    Verify Account Logged Out

Creating New Account
    [Documentation]     Creates new account using freshly created fake details then goes back to login page.
    [Arguments]         ${account}
    ${test_account}=            API_RES.Create Account Details
    VAR        &{TEST_ACCOUNT}        &{test_account}       scope=TEST
    Navigate To Login Page
    Navigate From Login Page To Register Page
    Register.Enter First Name    ${account.first_name}
    Register.Enter Last Name    ${account.last_name}
    Register.Enter User Name    ${account.user_name}
    Register.Enter Password    ${account.password}
    Click Register And Verify Account Registered

Deleting Account
    [Documentation]     Delete account from profile page, and Bypass the frontend bug of confirmation window stays open.
    ...                 then navigate to login page.
    Profile.Click Delete Account Button
    Profile.Verify Delete Account Confirmation Window Visible
    Profile.Confirm Delete

Logging in with Invalid Credentials
    [Documentation]     Navigate to login page, and Log in with Invalid credentials and verify the error message or
    ...                 the fields attributes.
    [Arguments]                                  ${account}
    Navigate To Login Page
    Reload
    Log In With Credentials                ${account}
    Verify Login Error                           ${account}

Log In With Credentials
    [Documentation]     Enter user name and password and click login button.
    [Arguments]         ${account}
    LogIn.Enter User Name           ${account.user_name}
    LogIn.Enter Password            ${account.password}
    LogIn.Click Login In Login Page

the Books
    BookStore.2 Books and Their Images

the books After using the Search
    BookStore.Using the Search Bar
    BookStore.the 2 Books and Their Images After Searching

Check a Book Details
    BookStore.Checking a Book Details

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

