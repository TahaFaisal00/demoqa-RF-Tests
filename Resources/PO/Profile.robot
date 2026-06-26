*** Settings ***
Library                                 Browser
Library    String

*** Variables ***
${USER_NAME_LABEL}                      id=userName-label
${LOGGED_IN_USER_NAME}                  id=userName-value

${DELETE_ALL_BOOKS_BUTTON}              css=#submit.Delete All Books
${LOG_OUT_BUTTON}                       css=button:has-text("Logout")

${NOT_LOGGED_IN_MESSAGE}                id=notLoggin-label

${DELETE_ACCOUNT_BUTTON}                css=#submit.Delete Account

${DELETE_BOOK_BUTTON}                   id="delete-record-{}"

${DELETE_ALL_BOOKS_CONFIRMATION_WINDOW}        css=#example-modal-sizes-title-sm.Delete All Books
${DELETE_ACCOUNT_CONFIRMATION_WINDOW}          css=#example-modal-sizes-title-sm.Delete Account
${DELETE_BOOK_CONFIRMATION_WINDOW}             css=#example-modal-sizes-title-sm.Delete Book

${DELETE_CONFIRMATION_WINDOW_OK_BUTTON}      id=closeSmallModal-ok

${PROFILE_PAGE_URL}                         https://demoqa.com/profile

${BOOK_STORE_LINK}                          css=[href="/books"]

${GO_TO_BOOK_STORE_BUTTON}                        id=gotoStore

${USER_NOT_FOUND_MESSAGE}                     css=#name.User not found!

${LOGIN_LINK}                               css=[href="/login"]
*** Keywords ***
Verify Profile Page Loaded
    Get Url                 ${PROFILE_PAGE_URL}

Click Delete All Books Button
    Click                               ${DELETE_ALL_BOOKS_BUTTON}

Verify Delete All Books Confirmation Window Visible
    Wait For Elements State    ${DELETE_ALL_BOOKS_CONFIRMATION_WINDOW}      visible

Click Book Store Link
    Click                             ${BOOK_STORE_LINK}

Verify Delete All Books Confirmation Window Closed
    Wait For Elements State    ${DELETE_ALL_BOOKS_CONFIRMATION_WINDOW}      hidden

Click Logout Button
    Click                       ${LOG_OUT_BUTTON}

Click Delete Account Button
    Click                       ${DELETE_ACCOUNT_BUTTON}

Verify Delete Account Confirmation Window Visible
    Wait For Elements State    ${DELETE_ACCOUNT_CONFIRMATION_WINDOW}      visible

Confirm Delete
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
