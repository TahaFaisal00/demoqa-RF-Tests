*** Settings ***
Library                                 Browser

*** Variables ***
${USER_NAME_LABEL}                      id=userName-label
${LOGGED_IN_USER_NAME}                  id=userName-value

${DELETE_ALL_BOOKS_BUTTON}              id=submit

${DELETE_ALL_BOOKS_CONFIRMATION_WINDOW}         id=example-modal-sizes-title-sm

${DELETE_ALL_BOOKS_CONFIRMATION_OK_BUTTON}      id=closeSmallModal-ok

${PROFILE_PAGE_URL}                         https://demoqa.com/profile
*** Keywords ***
Verify Profile Page Loaded
    Get Url                 ${PROFILE_PAGE_URL}

Verify that the First Book is in the Collection
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']

Verify that the Fourth Book is in the Collection
    Element Should Be Visible           xpath=//*[text()='Speaking JavaScript']

Click Delete All Books Button
    Click                               ${DELETE_ALL_BOOKS_BUTTON}

Verify Confirm Delete All Books Window
    Wait For Elements State    ${DELETE_ALL_BOOKS_CONFIRMATION_WINDOW}      visible

Confirm Delete All Books
    Click                               ${DELETE_ALL_BOOKS_CONFIRMATION_OK_BUTTON}


Verify That The First Book Is Deleted
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']

Clicking Go To Book Store Button
    Click Element                       xpath=//*[text()='Go To Book Store']

Click Logout button
    Click Element                       xpath=//*[text()='Logout']

Verify Logging Out Done Successfully
    Wait Until Page Contains            Login in Book Store

Click Delete Account button
    Click Element                       xpath=//*[text()='Delete Account']

Confirm Deleting the Account
    Wait Until Page Contains            Do you want to delete your account?
    Click Element                       xpath=//*[text()='OK']

Verify the Deletion
    [Arguments]                         ${User}
    Page Should Not Contain             ${User}

Verify Logging out
    Wait Until Page Contains            Login


