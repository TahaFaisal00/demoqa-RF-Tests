*** Settings ***
Library                                 Browser
Library                                 String
*** Variables ***
${BOOK_STORE_URL}                       https://demoqa.com/books

${LOGIN_BUTTON_IN_BOOK_STORE}                   id=login

${SEARCH_BAR}                                   id=searchBox


${BOOK_LOCATOR_BASE}                            css=a[href="{}"]
${BOOK_URL_BASE}                                https://demoqa.com{}

${GIT_POCKET_GUIDE_BOOK}                        /books?search=9781449325862
${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}     /books?search=9781449331818
${SPEAKING_JAVASCRIPT_BOOK}                     /books?search=9781449365035


*** Keywords ***
Verify BookStore Page Loaded
   Get Url                              ${BOOK_STORE_URL}

Open Book Details Page
    [Arguments]                                ${book}
    ${book_location}=       Format String      ${BOOK_LOCATOR_BASE}       ${book}
    Click                                      ${book_location}

Verify Book Page Loaded
    [Arguments]                                ${book}
    ${book_url}=            Format String      ${BOOK_URL_BASE}       ${book}
    Get Url                                    ${book_url}

Click Login Button In Book Store
   Click                                       ${LOGIN_BUTTON_IN_BOOK_STORE}

Use Search Bar
    [Arguments]                                ${search}
    Type Text                                  ${SEARCH_BAR}        ${search}

Click Add To Your Collection button
    Click Element                       xpath=//*[text()='Add To Your Collection']

Verify That Book Was Added Successfully
    Alert Should Be Present             Book added to your collection.

Navigate to Profile Page
    Click Element                       xpath=//*[text()='Profile']

Verify That Book Was Already Added to Your Collection
    Alert Should Be Present             Book already present in the your collection!



Enter the First Book Website
    Click Element                       xpath=//*[text()='http://chimera.labs.oreilly.com/books/1230000000561/index.html']
    Switch Window                       NEW
    Wait Until Page Contains            Build the skills your teams need
    Switch Window                       MAIN

Enter the Second Book Website
    Click Element                       xpath=//*[text()='http://www.addyosmani.com/resources/essentialjsdesignpatterns/book/']
    Switch Window                       NEW
    Wait Until Page Contains            Learning JavaScript Design Patterns
    Wait Until Page Contains            A JavaScript and React Developer's Guide 2nd Edition


2 Books and Their Images
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage0-DrW2Lhj5.jpg']
    Element Should Be Visible           xpath=//*[text()='Learning JavaScript Design Patterns']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage1-CeLeymOA.jpg']

Using the Search Bar
    Input Text                          xpath=//*[@id='searchBox']      Learning JavaScript Design Patterns
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

the 2 Books and Their Images After Searching
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[@src='/assets/bookimage0-DrW2Lhj5.jpg']
    Element Should Be Visible           xpath=//*[text()='Learning JavaScript Design Patterns']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage1-CeLeymOA.jpg']

Checking a Book Details
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Wait Until Page Contains            9781449325862
    Page Should Contain                 Git Pocket Guide
    Page Should Contain                 Richard E. Silverman
    Page Should Contain                 234
    Page Should Contain                 This pocket guide is the perfect

Click Back To Book Store button
    Click Element                       xpath=//*[text()='Back To Book Store']

Checking a Second Book Details
    Click Element                       xpath=//*[text()='Learning JavaScript Design Patterns']
    Wait Until Page Contains            9781449331818
    Page Should Contain                 Learning JavaScript Design Patterns
    Page Should Contain                 Addy Osmani
    Page Should Contain                 254
    Page Should Contain                 With Learning JavaScript Design Patterns

Click on Login button
   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']

   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store





