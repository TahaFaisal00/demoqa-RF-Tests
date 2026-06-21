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

Delete Account Does Not Close Confirmation Window
    [Documentation]     Create new account using freshly created data then delete the account. Verify the UI doesn't
    ...                 update and delete confirmation window stays open.
    [Tags]                                                           bug     ui     negative     account
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Creating New Account                                   ${TEST_ACCOUNT}
    DemoqaRes.Logging In And Verify                                  ${TEST_ACCOUNT}
    DemoqaRes.Deleting Account
    DemoqaRes.Verify Delete Confirmation Window Persists After Confirm
    [Teardown]      API_RES.Delete Account Via API

Delete Account Does Not automatically Log Out The User
    [Documentation]     Create new account using freshly created data then delete the account. Verify that after
    ...                 Deleting the account and navigating to Profile page the account will still be logged in
    ...                 even though it's deleted and you must manually log out.
    [Tags]                                                           bug       ui     negative       account
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Creating New Account                                   ${TEST_ACCOUNT}
    DemoqaRes.Logging In And Verify                                  ${TEST_ACCOUNT}
    DemoqaRes.Deleting Account
    DemoqaRes.Reload Profile Page And Verify Account Deletion
    DemoqaRes.Verify Account Still Signed In After Deletion
    [Teardown]      API_RES.Delete Account Via API

Search Bar - Empty Input Shows All Books
    [Documentation]     Use the search bar with empty value and verify that all books will remain visible
    ...                 and the UI won't crash
    [Tags]                                                           functional       ui     positive        bookstore
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Search Book Store    ${ALL_BOOKS}    ${EMPTY}
    DemoqaRes.Verify Search Results Contain    ${ALL_BOOKS}

Search Bar - Invalid Input Shows No Books
    [Documentation]     use the search bar with a non existent book name and verify that no book is shown.
    [Tags]                                                           functional       ui     negative        bookstore
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Search Book Store       ${ALL_BOOKS}   ${NONEXISTENT_BOOK_SEARCH}
    DemoqaRes.Verify No Books Found

Search Bar - Search By Book Title
    [Documentation]     Use the search bar with an existing book title and verify that the book is shown
    ...                 and all the others books are not visible.
    [Tags]                                                           functional       ui     positive        bookstore
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Search Book Store                    ${ALL_BOOKS}    ${GIT_POCKET_GUIDE_BOOK_DETAILS.title}
    DemoqaRes.Verify Search Results Contain    ${GIT_POCKET_GUIDE_BOOK}
    DemoqaRes.Verify Search Results Not Contain    ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
    ...                                            ${SPEAKING_JAVASCRIPT_BOOK}    ${UNDERSTANDING_ECMASCRIPT_BOOK}

Search Bar - Search By Author Name
    [Documentation]     Use the search bar with an existing book author and verify that the book is shown
    ...                 and all the others books are not visible.
    [Tags]                                                           functional       ui     positive        bookstore
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Search Book Store                    ${ALL_BOOKS}    ${SPEAKING_JAVASCRIPT_BOOK.author}
    DemoqaRes.Verify Search Results Contain       ${SPEAKING_JAVASCRIPT_BOOK}
    DemoqaRes.Verify Search Results Not Contain    ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
    ...                                            ${GIT_POCKET_GUIDE_BOOK}   ${UNDERSTANDING_ECMASCRIPT_BOOK}

Search Bar - Search by Publisher Name
    [Documentation]     Use the search bar with an existing book publisher and verify that the book is shown
    ...                 and all the others books are not visible.
    [Tags]                                                           functional       ui     positive        bookstore
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Search Book Store                    ${ALL_BOOKS}    ${GIT_POCKET_GUIDE_BOOK.publisher}
    DemoqaRes.Verify Search Results Contain       ${GIT_POCKET_GUIDE_BOOK}       ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
    ...                                            ${SPEAKING_JAVASCRIPT_BOOK}
    DemoqaRes.Verify Search Results Not Contain    ${UNDERSTANDING_ECMASCRIPT_BOOK}

Books In Book Store Does Not Retain Their Own Images When Their Position Changed
    [Documentation]     Verify the first and second book images, then search for the second book to hide the
    ...                 first book make the second book in the first book position, then verify that the second book
    ...                 have the first book image now.
    [Tags]                                                           bug     ui     positive     bookstore
    DemoqaRes.Navigate To Book Store Application
    Verify Book Image                              ${GIT_POCKET_GUIDE_BOOK}    ${FIRST_BOOK_IMAGE_SRC}
    Verify Book Image                              ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}    ${SECOND_BOOK_IAMGE_SRC}
    DemoqaRes.Search Book Store                    ${ALL_BOOKS}    ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK.title}
    DemoqaRes.Verify Search Results Contain        ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
    DemoqaRes.Verify Search Results Not Contain    ${GIT_POCKET_GUIDE_BOOK}
    Verify Book Image                              ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}    ${FIRST_BOOK_IMAGE_SRC}

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





