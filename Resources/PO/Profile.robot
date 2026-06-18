*** Settings ***
Library                                 Browser

*** Variables ***
${USER_NAME_LABEL}                      id=userName-label
${LOGGED_IN_USER_NAME}                  id=userName-value

${DELETE_ALL_BOOKS_BUTTON}              css=#submit.Delete All Books
${LOG_OUT_BUTTON}                       css=#submit.Logout
${DELETE_ACCOUNT_BUTTON}                css=#submit.Delete Account

${DELETE_ALL_BOOKS_CONFIRMATION_WINDOW}        css=#example-modal-sizes-title-sm.Delete All Books
${DELETE_ACCOUNT_CONFIRMATION_WINDOW}          css=#example-modal-sizes-title-sm.Delete Account

${DELETE_ALL_BOOKS_CONFIRMATION_OK_BUTTON}      id=closeSmallModal-ok

${PROFILE_PAGE_URL}                         https://demoqa.com/profile

${BOOK_STORE_LINK}                          id=item-2

${GO_TO_BOOK_STORE_BUTTON}                        id=gotoStore
*** Keywords ***
Verify Profile Page Loaded
    Get Url                 ${PROFILE_PAGE_URL}

Verify that the First Book is in the Collection
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']

Verify that the Fourth Book is in the Collection
    Element Should Be Visible           xpath=//*[text()='Speaking JavaScript']

Click Delete All Books Button
    Click                               ${DELETE_ALL_BOOKS_BUTTON}

Verify Delete All Books Confirmation Window Visible
    Wait For Elements State    ${DELETE_ALL_BOOKS_CONFIRMATION_WINDOW}      visible

Confirm Delete All Books
    Click                               ${DELETE_ALL_BOOKS_CONFIRMATION_OK_BUTTON}

Click Book Store Link
    Click                             ${BOOK_STORE_LINK}

Click Go To Book Store Button
    Click                              ${GO_TO_BOOK_STORE_BUTTON}

Verify Delete All Books Confirmation Window Closed
    Wait For Elements State    ${DELETE_ALL_BOOKS_CONFIRMATION_WINDOW}      hidden

Click Logout Button
    Click                       ${LOG_OUT_BUTTON}

Click Delete Account Button
    Click                       ${DELETE_ACCOUNT_BUTTON}

Verify Delete Account Confirmation Window Visible
    Wait For Elements State    ${DELETE_ACCOUNT_CONFIRMATION_WINDOW}      visible

Verify Delete Account Confirmation Window Closed
    Wait For Elements State    ${DELETE_ACCOUNT_CONFIRMATION_WINDOW}      hidden




Verify That The First Book Is Deleted
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']



Verify Logging Out Done Successfully
    Wait Until Page Contains            Login in Book Store



Confirm Deleting the Account
    Wait Until Page Contains            Do you want to delete your account?
    Click Element                       xpath=//*[text()='OK']

Verify the Deletion
    [Arguments]                         ${User}
    Page Should Not Contain             ${User}

Verify Logging out
    Wait Until Page Contains            Login


