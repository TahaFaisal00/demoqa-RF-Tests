*** Settings ***
Resource                                                             ../Resources/DemoqaRes.robot
Suite Setup                                                          Run Keywords         API_RES.Open Session      AND       Common.Launch Suite Browser
Suite Teardown                                                       Common.Shutdown Browser
#robot -d Results  Tests/UI_Tests.robot
#Run the trace through: playwright show-trace (Get-ChildItem C:\development\demoqa\log\browser\traces\trace_context=*.zip | Sort-Object LastWriteTime | Select-Object -Last 1).FullName
*** Test Cases ***
Log In With Invalid Credentials
   [Documentation]      Try to log in with a multiple different invalid credentials scenarios and verify errors.
   [Tags]                                                            functional      ui      negative        login
   [Setup]                                                           Run Keywords       Common.Start Clean Session      DemoqaRes.Navigate To Book Store Application
   [Template]                                                        DemoqaRes.Verify Login Fails
   ${INVALID_ACCOUNT}
   ${EMPTY_USER_NAME}
   ${EMPTY_PASSWORD}
   ${EMPTY_CREDENTIALS}
   [Teardown]                                                        Common.End Session

Log In And Log Out
    [Documentation]     Creates a fresh account, Logs in, Then logs out and delete the account.
    [Tags]                                                           functional       ui     positive        account
    [Setup]      Run Keywords       API_RES.Create Authenticated Account Via API            Common.Start Clean Session
    DemoqaRes.Navigate To Book Store Application
    DemoqaRes.Logging In And Verify                                  ${TEST_ACCOUNT}
    DemoqaRes.Logging Out And Verify
    [Teardown]       Run Keywords       API_RES.Delete Account Via API          Common.End Session

Log In And Delete Account
    [Documentation]     Creating new account Via API using freshly created data, because
    ...                 of BUG: ReCaptcha error message appear randomly without a visible UI test.
    ...                 And Signing in then deleting the account via API to bypass delete confirmation window
    ...                 intermittently appear and disappear bug then return for login page to log out
    ...                 because of another BUG: you won't be logged out after deleting your account. Then
    ...                 Verify your account was deleted by trying to log in by using the same Credentials.
    [Tags]                                                           functional     ui     positive     account
    [Setup]     DemoqaRes.Start Session And Create Account Then Open Book Store Application
    DemoqaRes.Logging In And Verify                                  ${TEST_ACCOUNT}
    API_RES.Authenticate Account And Delete It Via API
    DemoqaRes.Navigate To Login Page
    DemoqaRes.Logging Out From Deleted Account And Verify
    DemoqaRes.Verify Login Fails                                     ${TEST_ACCOUNT}
    [Teardown]      Run Keyword And Ignore Error         DemoqaRes.Delete Authenticated account And Close Session

Search Bar - Empty Input Shows All Books
    [Documentation]     Use the search bar with empty value and verify that all books will remain visible
    ...                 and the UI won't crash
    [Tags]                                                           functional       ui     positive        bookstore
    [Setup]     DemoqaRes.Start Session Then Open Book Store Application
    DemoqaRes.Search Book Store    ${ALL_BOOKS}    ${EMPTY}
    DemoqaRes.Verify Search Results Contain    @{ALL_BOOKS}
    [Teardown]         Common.End Session

Search Bar - Invalid Input Shows No Books
    [Documentation]     use the search bar with a non existent book name and verify that no book is shown.
    [Tags]                                                           functional       ui     negative        bookstore
    [Setup]     DemoqaRes.Start Session Then Open Book Store Application
    DemoqaRes.Search Book Store       ${ALL_BOOKS}   ${NONEXISTENT_BOOK_SEARCH}
    DemoqaRes.Verify No Books Found
    [Teardown]         Common.End Session

Search Bar - Search By Book Title
    [Documentation]     Use the search bar with an existing book title and verify that the book is shown
    ...                 and all the others books are not visible.
    [Tags]                                                           functional       ui     positive        bookstore
    [Setup]     DemoqaRes.Start Session Then Open Book Store Application
    DemoqaRes.Search Book Store                    ${ALL_BOOKS}    ${GIT_POCKET_GUIDE_BOOK_DETAILS.title}
    DemoqaRes.Verify Search Results Contain    ${GIT_POCKET_GUIDE_BOOK}
    DemoqaRes.Verify Search Results Not Contain    ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
    ...                                            ${SPEAKING_JAVASCRIPT_BOOK}    ${UNDERSTANDING_ECMASCRIPT_BOOK}
    [Teardown]         Common.End Session

Search Bar - Search By Author Name
    [Documentation]     Use the search bar with an existing book author and verify that the book is shown
    ...                 and all the others books are not visible.
    [Tags]                                                           functional       ui     positive        bookstore
    [Setup]     DemoqaRes.Start Session Then Open Book Store Application
    DemoqaRes.Search Book Store                    ${ALL_BOOKS}    ${SPEAKING_JAVASCRIPT_BOOK_DETAILS.author}
    DemoqaRes.Verify Search Results Contain       ${SPEAKING_JAVASCRIPT_BOOK}
    DemoqaRes.Verify Search Results Not Contain    ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
    ...                                            ${GIT_POCKET_GUIDE_BOOK}   ${UNDERSTANDING_ECMASCRIPT_BOOK}
    [Teardown]         Common.End Session

Search Bar - Search by Publisher Name
    [Documentation]     Use the search bar with an existing book publisher and verify that the book is shown
    ...                 and all the others books are not visible.
    [Tags]                                                           functional       ui     positive        bookstore
    [Setup]     DemoqaRes.Start Session Then Open Book Store Application
    DemoqaRes.Search Book Store                    ${ALL_BOOKS}    ${GIT_POCKET_GUIDE_BOOK_DETAILS.publisher}
    DemoqaRes.Verify Search Results Contain       ${GIT_POCKET_GUIDE_BOOK}       ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
    ...                                            ${SPEAKING_JAVASCRIPT_BOOK}
    DemoqaRes.Verify Search Results Not Contain    ${UNDERSTANDING_ECMASCRIPT_BOOK}
    [Teardown]         Common.End Session

Books In Book Store Does Not Retain Their Own Images When Their Position Changed
    [Documentation]     Verify the first and second book images, then search for the second book to hide the
    ...                 first book make the second book in the first book position, then verify that the second book
    ...                 have the first book image now.
    [Tags]                                                           bug     ui     positive     bookstore
    [Setup]     DemoqaRes.Start Session Then Open Book Store Application
    DemoqaRes.Verify Book Image                              ${GIT_POCKET_GUIDE_BOOK}    ${FIRST_BOOK_IMAGE_SRC}
    DemoqaRes.Verify Book Image                              ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}    ${SECOND_BOOK_IMAGE_SRC}
    DemoqaRes.Search Book Store                    ${ALL_BOOKS}    ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK_DETAILS.title}
    DemoqaRes.Verify Search Results Contain        ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
    DemoqaRes.Verify Search Results Not Contain    ${GIT_POCKET_GUIDE_BOOK}
    DemoqaRes.Verify Book Image                              ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}    ${FIRST_BOOK_IMAGE_SRC}
    [Teardown]      Common.End Session

Add Book To Books Collection And Delete It
    [Documentation]     Add book To book collection then delete it with single book delete button of the book and
    ...                 verify it's deletion.
    [Tags]                                                           functional      ui     positive     bookstore
    [Setup]      DemoqaRes.Start Session And Create Account Then Open Book Store Application
    DemoqaRes.Logging In And Verify                    ${TEST_ACCOUNT}
    DemoqaRes.Navigate To Book Store
    DemoqaRes.Verify Books Loaded                                ${ALL_BOOKS}
    DemoqaRes.Open Book Page                                     ${GIT_POCKET_GUIDE_BOOK}
    DemoqaRes.Verify Book Details                                ${BOOK_DETAILS_LOCATORS}       ${GIT_POCKET_GUIDE_BOOK_DETAILS}
    DemoqaRes.Click Add Book To Collection And Verify Book Added
    DemoqaRes.Navigate To Profile Page
    DemoqaRes.Verify Book In Book Collection                     ${GIT_POCKET_GUIDE_BOOK}
    DemoqaRes.Delete Single Book                                 ${GIT_POCKET_GUIDE_BOOK_DETAILS}
    DemoqaRes.Verify Book Not In Book Collection                 ${GIT_POCKET_GUIDE_BOOK}
    [Teardown]      Run Keyword And Ignore Error        DemoqaRes.Delete Authenticated account And Close Session









