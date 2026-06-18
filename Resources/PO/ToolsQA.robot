*** Settings ***
Library                       Browser

*** Variables ***
${WEBISTE_LOGO}               css=a[href="https://demoqa.com"]
${BOOK_STORE_LINK}            css=a[href="/books"]

${MAIN_PAGE_URL}              https://demoqa.com/

*** Keywords ***
Verify TOOLSQA Page loaded
   Wait For Elements State    ${WEBISTE_LOGO}      visible
   Get Url                    ${MAIN_PAGE_URL}

Click Book Store Link
   Click                      ${BOOK_STORE_LINK}











