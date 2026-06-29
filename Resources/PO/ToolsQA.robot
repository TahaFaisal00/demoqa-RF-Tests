*** Settings ***
Library                       Browser

*** Variables ***
${BOOK_STORE_APPLICATION_LINK}            css=a[href="/books"]

*** Keywords ***

Click Book Store Application Link
   Click                      ${BOOK_STORE_APPLICATION_LINK}











