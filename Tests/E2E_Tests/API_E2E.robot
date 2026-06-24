*** Settings ***
Resource            ../../Resources/API_RES.robot
Suite Setup         Open Session

*** Test Cases ***
Full User Experience
    [Documentation]     Verifies the full user lifecycle: creating an account, authorizing it, adding a book
    ...                 list, replacing a book, and deleting the account.
    ${response}=        Create Account Via API
    Verify Create Account Succeeds           ${response}
    ${response}=        Generate Token Via API
    Verify Generate Token Succeeds           ${response}
    ${response}=        Check Account Authorization Via API
    Verify Account Authorization Succeeds    ${response}
    ${response}=        Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    Verify Books In Response    ${response}                 ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Update Book By Another Via API    ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}    ${SPEAKING_JAVA_SCRIPT_ISBN}
    Verify Book Replaced        ${response}     ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}         ${SPEAKING_JAVA_SCRIPT_ISBN}
    [Teardown]        Delete Account Via API












