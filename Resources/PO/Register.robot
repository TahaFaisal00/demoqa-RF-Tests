*** Settings ***
Library                                       Browser


*** Keywords ***
Enter First Name
    [Arguments]                       ${first_name}
    Type Text                         id=firstname    ${first_name}

Enter Last Name
    [Arguments]                       ${last_name}
    Type Text                         id=lastname     ${last_name}

Enter User Name
   [Arguments]                        ${user_name}
   Type Text                          id=userName         ${user_name}

Enter Password
   [Arguments]                        ${password}
   Type Text                          id=password         ${password}

Click Register Button
   Click                       id=register

Verify User Registration
   Alert Should Be Present            User Registered Successfully.

Click Back to Login Button
    Click Element                     xpath=//*[text()='Back to Login']


