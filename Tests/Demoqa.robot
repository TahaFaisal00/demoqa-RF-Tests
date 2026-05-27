*** Settings ***
Library                                SeleniumLibrary
Resource                               ../Resources/Common.robot
Resource                               ../Resources/DemoqaRes.robot
Suite Setup                            Common.Launch Browser
Suite Teardown                         Common.Close Browser


*** Variables ***




*** Test Cases ***

Logging in with a Multiple Invalid Credentials Scenarios
   [Tags]                               functional      ui      negative        login
   [Template]                           DemoqaRes.Logging in with Invalid Credentials
   ${DELETED_ACCOUNT}
   ${EMPTY_USERNAME}
   ${EMPTY_PASSWORD}
   ${EMPTY_CREDENTIALS}



Logging in with a Deleted Account Credentials
   [Tags]                               functional      ui      negative        login
   DemoqaRes.Navigate to The Book Store Application

   DemoqaRes.Navigate to Login Page
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         ${DELETE_ME_USERNAME}
   Input Text                           xpath=//*[@id='password']         ${DELETE_ME_PASSWORD}
   Click Element                        xpath=//*[@id='login']
   Page Should Not Contain              ${DELETE_ME_USERNAME}

Logging in with Empty userName
   [Tags]                               functional      ui      negative        login
   DemoqaRes.Navigate to The Book Store Application

   DemoqaRes.Navigate to Login Page
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         ${EMPTY}
   Input Text                           xpath=//*[@id='password']         ${DELETE_ME_PASSWORD}
   Click Element                        xpath=//*[@id='login']
   Wait Until Element Is Visible             xpath=//*[@id='userName' and @class='mr-sm-2 is-invalid form-control']

Logging in with Empty Password
   [Tags]                               functional      ui      negative        login
   DemoqaRes.Navigate to The Book Store Application

   DemoqaRes.Navigate to Login Page
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         ${DELETE_ME_USERNAME}
   Input Text                           xpath=//*[@id='password']         ${EMPTY}
   Click Element                        xpath=//*[@id='login']
   Wait Until Element Is Visible             xpath=//*[@id='password' and @class='mr-sm-2 is-invalid form-control']

Logging in with Empty userName and Password
   [Tags]                               functional      ui      negative        login
   DemoqaRes.Navigate to The Book Store Application

   DemoqaRes.Navigate to Login Page
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         ${EMPTY}
   Input Text                           xpath=//*[@id='password']         ${EMPTY}
   Click Element                        xpath=//*[@id='login']
   Wait Until Element Is Visible             xpath=//*[@id='userName' and @class='mr-sm-2 is-invalid form-control']
   Wait Until Element Is Visible             xpath=//*[@id='password' and @class='mr-sm-2 is-invalid form-control']








Logging Out of the Account
    [Tags]                              functional       ui     positive        account
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Logging Out

Delete the Account
    [Tags]                              bug     ui     positive     account
    DemoqaRes.Navigate to The Book Store Application
    DemoqaRes.Creating a New Account              ${DELETE_ME_FIRST_NAME}    ${DELETE_ME_LAST_NAME}   ${DELETE_ME_USERNAME}    ${DELETE_ME_PASSWORD}
    DemoqaRes.Logging in                          ${DELETE_ME_USERNAME}       ${DELETE_ME_PASSWORD}
    DemoqaRes.Deleting the Account

User Should Be Logged Out Automatically After Account Deletion
    [Tags]                              bug       ui     positive       account
    DemoqaRes.Navigate to The Book Store Application
    DemoqaRes.Creating a New Account              ${DELETE_ME_FIRST_NAME}    ${DELETE_ME_LAST_NAME}   ${DELETE_ME_USERNAME}    ${DELETE_ME_PASSWORD}
    DemoqaRes.Logging in                          ${DELETE_ME_USERNAME}       ${DELETE_ME_PASSWORD}
    DemoqaRes.Deleting the Account
    DemoqaRes.Account Logged out

Search Bar - Empty Input Shows All Books
    [Tags]                              functional       ui     positive        bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Navigate to The Book Store Application
    DemoqaRes.Using the Book Search Feature            ${SEARCH.EMPTY}
    DemoqaRes.Empty Search Results

Search Bar - Invalid Input Shows No Books
    [Tags]                              functional       ui     negative        bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Navigate to The Book Store Application
    DemoqaRes.Using the Book Search Feature           ${SEARCH.INVALID}
    DemoqaRes.Verify Search Results

Search Bar - Search by Book Title
    [Tags]                              functional       ui     positive        bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Navigate to The Book Store Application
    DemoqaRes.Using the Book Search Feature            ${SEARCH.BOOKNAME}
    DemoqaRes.Book Title Search Results

Search Bar - Search by Author Name
    [Tags]                              functional       ui     positive        bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Navigate to The Book Store Application
    DemoqaRes.Using the Book Search Feature           ${SEARCH.AUTHOR}
    DemoqaRes.Author name Search Results

Search Bar - Search by Publisher Name
    [Tags]                              functional       ui     positive        bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Navigate to The Book Store Application
    DemoqaRes.Using the Book Search Feature            ${SEARCH.Publisher}
    DemoqaRes.Publisher Empty Search Results









Books in the Book Store Should Have Retain Their Own Images When Their Position is Changed
    [Tags]                              bug     ui     positive     bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Navigate to The Book Store Application
    DemoqaRes.the Books
    DemoqaRes.the books After using the Search

Books in the Book Store Should Retain Their Correct Details When Their Position is Changed
    [Tags]                              functional      ui     positive     bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    DemoqaRes.Return to BookStore
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Wait Until Page Contains            9781449325862
    Page Should Contain                 Git Pocket Guide
    Page Should Contain                 Richard E. Silverman
    Page Should Contain                 234
    Page Should Contain                 This pocket guide is the perfect

    Click Element                       xpath=//*[text()='Back To Book Store']

    Click Element                       xpath=//*[text()='Learning JavaScript Design Patterns']
    Wait Until Page Contains            9781449331818
    Page Should Contain                 Learning JavaScript Design Patterns
    Page Should Contain                 Addy Osmani
    Page Should Contain                 254
    Page Should Contain                 With Learning JavaScript Design Patterns

    Click Element                       xpath=//*[text()='Back To Book Store']

    Input Text                          xpath=//*[@id='searchBox']      Learning JavaScript Design Patterns
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Click Element                       xpath=//*[text()='Learning JavaScript Design Patterns']
    Wait Until Page Contains            9781449331818
    Page Should Contain                 Learning JavaScript Design Patterns
    Page Should Contain                 Addy Osmani
    Page Should Contain                 254
    Page Should Contain                 With Learning JavaScript Design Patterns

Entering Website Link in Books'details
    [Tags]                              functional      ui     positive     bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Click Element                       xpath=//*[text()='http://chimera.labs.oreilly.com/books/1230000000561/index.html']
    Switch Window                       NEW
    Wait Until Page Contains            Build the skills your teams need
    Switch Window                       MAIN

    Click Element                       xpath=//*[text()='Back To Book Store']

    Click Element                       xpath=//*[text()='Learning JavaScript Design Patterns']
    Click Element                       xpath=//*[text()='http://www.addyosmani.com/resources/essentialjsdesignpatterns/book/']
    Switch Window                       NEW
    Wait Until Page Contains            Learning JavaScript Design Patterns
    Wait Until Page Contains            A JavaScript and React Developer's Guide 2nd Edition

Adding Books to the Books Collection
    [Tags]                              functional      ui     positive     bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book added to your collection.
    Click Element                       xpath=//*[text()='Back To Book Store']

    Click Element                       xpath=//*[text()='Speaking JavaScript']
    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book added to your collection.
    Click Element                       xpath=//*[text()='Back To Book Store']

    Click Element                       xpath=//*[text()='Profile']
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Be Visible           xpath=//*[text()='Speaking JavaScrip']

Adding Already Added Book to the Books Collection
    [Tags]                              functional      ui     negative     bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book added to your collection.

    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book already present in the your collection!

Add a Book to the Collection then Delete All Books from the Collection
    [Tags]                              bug       ui     positive       bookstore
    DemoqaRes.Logging in                          ${MAIN_USERNAME}        ${MAIN_PASSWORD}
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book added to your collection.

    Click Element                       xpath=//*[text()='Profile']

    Click Element                       xpath=//*[text()='Delete All Books']
    Wait Until Page Contains            Do you want to delete all books?
    Click Element                       xpath=//*[text()='OK']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']





