*** Settings ***
Library                       Browser

*** Variables ***
${WEBISTE_LOGO}               css=a[href="https://demoqa.com"]
${BOOK_STORE_LINK}            css=a[href="/books"]

*** Keywords ***
Verify TOOLSQA Page loaded
   Wait For Elements State    ${WEBISTE_LOGO}      visible

Click Book Store Link
   Click                      ${BOOK_STORE_LINK}











