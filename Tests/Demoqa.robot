*** Settings ***
Resource                                                             ../Resources/Common.robot
Resource                                                             ../Resources/DemoqaRes.robot
Resource                                                             ../Resources/API_RES.robot

Suite Setup                                                          Run Keywords         API_RES.Open Session      AND       Common.Launch Browser
Suite Teardown                                                       Common.Close Browser
#robot -d Results  Tests/Demoqa.robot

*** Test Cases ***
Log In With Invalid Credentials
   [Documentation]      Try to log in with a multiple different invalid credentials scenarios and verify errors.
   [Tags]                                                            functional      ui      negative        login
   [Template]                                                        DemoqaRes.Verify Login Fails
   ${INVALID_ACCOUNT}
   ${EMPTY_USER_NAME}
   ${EMPTY_PASSWORD}
   ${EMPTY_CREDENTIALS}

Log In And Log Out
    [Documentation]     Creates a fresh account, Logs in, Then logs out and delete the account.
    [Tags]                                                           functional       ui     positive        account
    [Setup]     API_RES.Create Authenticated Account Via API
    Navigate To Book Store Application
    DemoqaRes.Logging In And Verify                                  ${TEST_ACCOUNT}
    DemoqaRes.Logging Out And Verify
    [Teardown]      API_RES.Delete Account Via API

Register And Delete Account
    [Documentation]     Create new account using freshly created data then delete the account. Reload the page after
    ...                 deleting it to bypass the unresponsive frontend bug then return for login page to log out
    ...                 because of another bug: you won't be logged out after deleting your account. Then
    ...                 Verify your account was deleted by trying to log in by using the same Credentials.
    [Tags]                                                           functional     ui     positive     account
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Creating New Account                                   ${TEST_ACCOUNT}
    DemoqaRes.Logging In And Verify                                  ${TEST_ACCOUNT}
    DemoqaRes.Deleting Account
    DemoqaRes.Reload Profile Page And Verify Account Deletion
    DemoqaRes.Logging Out And Verify
    DemoqaRes.Verify Login Fails                                     ${TEST_ACCOUNT}
    [Teardown]      API_RES.Delete Account Via API


User Should Be Logged Out Automatically After Account Deletion
    [Tags]                                                           bug       ui     positive       account
    DemoqaRes.Navigating to Profile and Creating a New Account       ${DELETE_ME_FIRST_NAME}    ${DELETE_ME_LAST_NAME}   ${DELETE_ME_USERNAME}    ${DELETE_ME_PASSWORD}
    DemoqaRes.Logging in                                             ${DELETE_ME_USERNAME}       ${DELETE_ME_PASSWORD}
    DemoqaRes.Deleting the Account
    DemoqaRes.Account Logged out

Search Bar - Empty Input Shows All Books
    [Tags]                                                           functional       ui     positive        bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Using the Book Search Feature                          ${SEARCH.EMPTY}
    DemoqaRes.Empty Search Results

Search Bar - Invalid Input Shows No Books
    [Tags]                                                           functional       ui     negative        bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Using the Book Search Feature                          ${SEARCH.INVALID}
    DemoqaRes.Verify Search Results

Search Bar - Search by Book Title
    [Tags]                                                           functional       ui     positive        bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Using the Book Search Feature                          ${SEARCH.BOOKNAME}
    DemoqaRes.Book Title Search Results

Search Bar - Search by Author Name
    [Tags]                                                           functional       ui     positive        bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Using the Book Search Feature                          ${SEARCH.AUTHOR}
    DemoqaRes.Author name Search Results

Search Bar - Search by Publisher Name
    [Tags]                                                           functional       ui     positive        bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Using the Book Search Feature                          ${SEARCH.Publisher}
    DemoqaRes.Publisher Empty Search Results

Books in the Book Store Should Have Retain Their Own Images When Their Position is Changed
    [Tags]                                                           bug     ui     positive     bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.the Books
    DemoqaRes.the books After using the Search

Books in the Book Store Should Retain Their Correct Details When Their Position is Changed
    [Tags]                                                           functional      ui     positive     bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Check a Book Details
    DemoqaRes.Return to BookStore From Book Details
    DemoqaRes.Check a Second Book Details
    DemoqaRes.Return to BookStore From Book Details
    DemoqaRes.Check the Second Book Details After Using the Search

Entering Website Link in Books'details
    [Tags]                                                           functional      ui     positive     bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Open the First Book and Enter the Website
    DemoqaRes.Return to BookStore From Book Details
    DemoqaRes.Open the Second Book and Enter the Website

Adding Books to the Books Collection
    [Tags]                                                           functional      ui     positive     bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Add the First Book to the Collection
    DemoqaRes.Return to BookStore From Book Details
    DemoqaRes.Add the Fourth Book to the Collection
    DemoqaRes.Navigate to Profile and Verify that the Books Are in the Collection

Adding Already Added Book to the Books Collection
    [Tags]                                                           functional      ui     negative     bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Add the First Book to the Collection
    DemoqaRes.Adding an Already Added Book to the Collection

Add a Book to the Collection then Delete All Books from the Collection
    [Tags]                                                           bug       ui     positive       bookstore
    DemoqaRes.Navigating to Profile and Logging in                   ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore From Account
    DemoqaRes.Add the First Book to the Collection
    DemoqaRes.Navigate to Profile and Delete The Collection





