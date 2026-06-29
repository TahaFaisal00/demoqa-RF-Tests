*** Settings ***
Resource            ../../Resources/DemoqaRes.robot
Suite Setup         Run Keywords         API_RES.Open Session            Common.Launch Suite Browser
Suite Teardown      Common.Shutdown Browser

*** Test Cases ***
Full User Experience Via UI
    [Documentation]     Verifies the full user lifecycle: creat an account and authorize it Via API, UI login,
    ...                 add two books to book collection, verify both present, then delete the account and verify
    ...                 deletion.
    [Setup]     Start Session And Create Account Then Open Book Store Application
    Logging In And Verify                                        ${TEST_ACCOUNT}
    DemoqaRes.Navigate To Book Store
    DemoqaRes.Verify Books Loaded                                ${ALL_BOOKS}
    DemoqaRes.Open Book Page                                     ${GIT_POCKET_GUIDE_BOOK}
    DemoqaRes.Verify Book Details                                ${BOOK_DETAILS_LOCATORS}       ${GIT_POCKET_GUIDE_BOOK_DETAILS}
    DemoqaRes.Click Add Book To Collection And Verify Book Added
    DemoqaRes.Navigate From Book Details To Book Store
    DemoqaRes.Open Book Page                                               ${SPEAKING_JAVASCRIPT_BOOK}
    DemoqaRes.Verify Book Details                                ${BOOK_DETAILS_LOCATORS}       ${SPEAKING_JAVASCRIPT_BOOK_DETAILS}
    DemoqaRes.Click Add Book To Collection And Verify Book Added
    DemoqaRes.Navigate To Profile Page
    DemoqaRes.Verify Book In Book Collection                 ${GIT_POCKET_GUIDE_BOOK}        ${SPEAKING_JAVASCRIPT_BOOK}
    DemoqaRes.Delete Account Then Reload Profile Page And Verify Account Deletion
    [Teardown]     Run Keyword And Ignore Error          Delete Authenticated account And Close Session








