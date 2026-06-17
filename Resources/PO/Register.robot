*** Settings ***
Library                                       Browser

*** Variables ***
${FIRST_NAME_FILED}             id=firstname
${LAST_NAME_FIELD}              id=lastname
${USER_NAME_FIELD}              id=userName
${PASSWORD_FIELD}               id=password
${REGISTER_BUTTON}              id=register
${BACK_TO_LOGIN_BUTTON}              id=gotologin


*** Keywords ***
Enter First Name
    [Arguments]                       ${first_name}
    Type Text                         ${FIRST_NAME_FILED}   ${first_name}

Enter Last Name
    [Arguments]                       ${last_name}
    Type Text                         ${LAST_NAME_FIELD}     ${last_name}

Enter User Name
   [Arguments]                        ${user_name}
   Type Text                          ${USER_NAME_FIELD}         ${user_name}

Enter Password
   [Arguments]                        ${password}
   Type Text                          ${PASSWORD_FIELD}         ${password}

Click Register Button
   Click                       ${REGISTER_BUTTON}

Click Back To Login Button
    Click                    ${BACK_TO_LOGIN_BUTTON}


