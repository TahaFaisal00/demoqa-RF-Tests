*** Settings ***
Library                                 Browser
Library    String

*** Variables ***
${LOGGED_IN_USER_NAME}                  id=userName-value

${LOG_OUT_BUTTON_PROFILE_PAGE}          css=button#submit:has-text("Logout")

${NOT_LOGGED_IN_MESSAGE}                id=notLoggin-label

${DELETE_ACCOUNT_BUTTON}                css=button#submit:has-text("Delete Account")

${DELETE_BOOK_BUTTON}                   css=span#delete-record-{}

${DELETE_ACCOUNT_CONFIRMATION_WINDOW}          css=div#example-modal-sizes-title-sm:has-text("Delete Account")
${DELETE_BOOK_CONFIRMATION_WINDOW}             css=#example-modal-sizes-title-sm.Delete Book

${DELETE_CONFIRMATION_WINDOW_OK_BUTTON}      id=closeSmallModal-ok

${PROFILE_PAGE_URL}                         https://demoqa.com/profile

${BOOK_STORE_LINK}                          css=li#item-2  >>  a[href="/books"]

${GO_TO_BOOK_STORE_BUTTON}                        id=gotoStore

${USER_NOT_FOUND_MESSAGE}                     css=p#name:has-text("User not found!")

${LOGIN_LINK}                               css=li#item-0  >>   a[href="/login"]
*** Keywords ***
Verify Profile Page Loaded
    Get Url        ==         ${PROFILE_PAGE_URL}


Click Book Store Link
    Click                             ${BOOK_STORE_LINK}


Click Logout Button
    Click                       ${LOG_OUT_BUTTON_PROFILE_PAGE}

Click Delete Account Button
    Click                       ${DELETE_ACCOUNT_BUTTON}

Verify Delete Account Confirmation Window Visible
    Wait For Elements State    ${DELETE_ACCOUNT_CONFIRMATION_WINDOW}      stable
    Wait For Elements State    ${DELETE_ACCOUNT_CONFIRMATION_WINDOW}      visible

Confirm Delete
    Wait For Elements State    ${DELETE_CONFIRMATION_WINDOW_OK_BUTTON}      stable
    Click                    ${DELETE_CONFIRMATION_WINDOW_OK_BUTTON}

Verify Delete Account Confirmation Window Closed
    Wait For Elements State    ${DELETE_ACCOUNT_CONFIRMATION_WINDOW}      hidden

Click Delete Book Button
    [Arguments]     ${book}
    ${book_delete_button}       Format String    ${DELETE_BOOK_BUTTON}  ${book.isbn}
    Click    ${book_delete_button}

Verify Delete Book Confirmation Window Visible
    Wait For Elements State    ${DELETE_BOOK_CONFIRMATION_WINDOW}       visible

Verify Delete Book Confirmation Window Closed
    Wait For Elements State    ${DELETE_BOOK_CONFIRMATION_WINDOW}       hidden

Click Login Link
    Click    ${LOGIN_LINK}

Verify User Not Found Message
    Wait For Elements State    ${USER_NOT_FOUND_MESSAGE}   visible

Verify User Logged Out Message
    Wait For Elements State    ${NOT_LOGGED_IN_MESSAGE}      visible

Verify Account Logged In
   [Arguments]                                       ${user_name}
   Wait For Elements State                           ${LOGGED_IN_USER_NAME}          visible
   Get Text                                          ${LOGGED_IN_USER_NAME}    ==    ${user_name}

