*** Settings ***
Library                                 Browser
Library                                 String
*** Variables ***
${BOOK_STORE_URL}                       https://demoqa.com/books

${LOGIN_BUTTON_IN_BOOK_STORE}                   id=login

${SEARCH_BAR}                                   id=searchBox
${SUBMIT_SEARCH_BUTTON}                         xpath=//button[contains(class,'btn-outline-secondary')]

${BOOK_LOCATOR_BASE}                            css=a[href="{}"]
${BOOK_URL_BASE}                                https://demoqa.com{}

${GIT_POCKET_GUIDE_BOOK}                        /books?search=9781449325862
${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}     /books?search=9781449331818
${SPEAKING_JAVASCRIPT_BOOK}                     /books?search=9781449365035
${UNDERSTANDING_ECMASCRIPT_BOOK}                     /books?search=9781593277574

@{ALL_BOOKS}                                    ${GIT_POCKET_GUIDE_BOOK}        ${LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK}
...                                             ${SPEAKING_JAVASCRIPT_BOOK}             ${UNDERSTANDING_ECMASCRIPT_BOOK}

${ADD_TO_YOUR_COLLECTION_BUTTON}                css=#addNewRecordButton.Add To Your Collection
${BACK_TO_BOOK_STORE_BUTTON}                    css=#addNewRecordButton.Back To Book Store

${PROFILE_PAGE_LINK}                            css=a[href="/profile"]

&{GIT_POCKET_GUIDE_BOOK_DETAILS}                        isbn=9781449325862   sub_title=A Working Introduction     author=Richard E. Silverman   publisher=O'Reilly Media
&{LEARNING_JAVASCRIPT_DESIGN_PATTERNS_BOOK_DETAILS}     isbn=9781449331818   sub_title=A JavaScript and jQuery Developer's Guide     author=Addy Osmani   publisher=O'Reilly Media
&{SPEAKING_JAVASCRIPT_BOOK_DETAILS}                     isbn=9781449365035   sub_title=An In-Depth Guide for Programmers     author=Axel Rauschmayer   publisher=O'Reilly Media
&{UNDERSTANDING_ECMASCRIPT_DETAILS}                     isbn=9781593277574   sub_title=The Definitive Guide for JavaScript Developers     author=Nicholas C. Zakas   publisher=No Starch Press

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

Use Search Bar
    [Arguments]                                ${search}
    Type Text                                  ${SEARCH_BAR}        ${search}
    Click                                      ${SUBMIT_SEARCH_BUTTON}

Click Add To Your Collection Button
    Click                                      ${ADD_TO_YOUR_COLLECTION_BUTTON}

Click Profile Page Link
    Click                                      ${PROFILE_PAGE_LINK}

Verify Book Page Loaded
    [Arguments]                                ${book}
    ${book_url}=        Format String          ${BOOK_URL_BASE}       ${book}
    Get Url                                    ${book_url}

Get Image Src
    [Arguments]         ${book}
    ${book_locator}=      Format String    ${BOOK_LOCATOR_BASE}       ${book}
    ${img}=     Set Variable        css=tr:has(a[href="${book_locator}"]) img
    Wait For Elements State    ${img}            visible
    ${src}=     Get Attribute    ${img}       src
    RETURN      ${src}

