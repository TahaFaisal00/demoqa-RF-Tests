*** Settings ***
Library                 SeleniumLibrary


*** Variables ***
${URL}=                 https://demoqa.com/
${BROWSER}              chrome

*** Keywords ***
Launch Browser
    Open Browser        ${URL}          ${BROWSER}
    Set Selenium Speed                   1s

Close Browser
    Close All Browsers
