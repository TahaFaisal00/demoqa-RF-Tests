*** Settings ***
Library                               SeleniumLibrary
Resource                              Resources/Common.robot



*** Variables ***
${MAIN_FIRST_NAME}                    taha
${MAIN_LAST_NAME}                     moe
${MAIN_USERNAME}                      taha001q22
${MAIN_PASSWORD}                      Taha2001!!
${DELETE_ME_FIRST_NAME}               Delete
${DELETE_ME_LAST_NAME}                Me
${DELETE_ME_USERNAME}                 DeleteMe
${DELETE_ME_PASSWORD}                 Taha2001!!




*** Keywords ***
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
    Page Should Not Contain             ${DELETE_ME_USERNAME}



Verify Logging out
    Wait Until Page Contains            Login




Logging in
   [Arguments]                          ${USERNAME}         ${PASSWORD}
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         ${USERNAME}
   Input Text                           xpath=//*[@id='password']         ${PASSWORD}
   Click Element                        xpath=//*[@id='login']
   Wait Until Page Contains             ${USERNAME}

Creating a New Account
   [Arguments]                          ${First_Name}     ${Last_name}     ${USERNAME}      ${PASSWORD}
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,

   Click Button                         xpath=//*[text()='New User']

    Input Text                          xpath=//*[@id='firstname']    ${First_Name}
    Input Text                          xpath=//*[@id='lastname']     ${Last_name}
    Input Text                          xpath=//*[@id='userName']     ${USERNAME}
    Input Text                          xpath=//*[@id='password']     ${PASSWORD}

   Click Button                         xpath=//*[text()='Register']
   Alert Should Be Present              User Registered Successfully.