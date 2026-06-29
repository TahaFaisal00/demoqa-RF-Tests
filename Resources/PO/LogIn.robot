*** Settings ***
Library                                              Browser

*** Variables ***
${LOGIN_PAGE_URL}                                    https://demoqa.com/login

${USER_NAME_FIELD}                                   id=userName
${PASSWORD_FIELD}                                    id=password

${LOGIN_BUTTON}                                      css=#login

${NEW_USER_BUTTON}                                   id=newUser

${EMPTY_USERNAME_FIELD_ERROR}                           css=#userName.is-invalid
${EMPTY_PASSWORD_FIELD_ERROR}                           css=#password.is-invalid
${INVALID_USERNAME_OR_PASSWORD_ERROR}                   text="Invalid username or password!"

${ALREADY_LOGGED_IN_MESSAGE}                            id=loading-label

${LOG_OUT_BUTTON_LOGIN_PAGE}                           css=button#submit:has-text("Log out")
*** Keywords ***
Verify Login Page Loaded
   Get Url                         ==                  ${LOGIN_PAGE_URL}

Enter User Name
   [Arguments]                                       ${user_name}
   Type Text                                         ${USER_NAME_FIELD}      ${user_name}

Enter Password
   [Arguments]                                       ${password}
   Type Text                                         ${PASSWORD_FIELD}       ${password}

Click Login In Login Page
   Click                                             ${LOGIN_BUTTON}

Click New User Button
   Click                                             ${NEW_USER_BUTTON}

Verify Empty User Name Field Invalid State
    Wait For Elements State    ${EMPTY_USERNAME_FIELD_ERROR}        visible

Verify Empty Password Field Invalid State
    Wait For Elements State    ${EMPTY_PASSWORD_FIELD_ERROR}        visible

Verify Invalid Log In Message
    Wait For Elements State    ${INVALID_USERNAME_OR_PASSWORD_ERROR}    visible

Verify Account Already Logged In Message
    Wait For Elements State    ${ALREADY_LOGGED_IN_MESSAGE}     visible

Click Logout Button
    Click                       ${LOG_OUT_BUTTON_LOGIN_PAGE}

