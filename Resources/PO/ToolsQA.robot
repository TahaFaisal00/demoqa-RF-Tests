*** Settings ***
Library                                  SeleniumLibrary



*** Keywords ***
Verify that TOOLSQA Website is loaded
   Wait Until Page Contains Element      xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible         xpath=//*[text()='Book Store Application']

Click on Book Store Application
   Click Element                         xpath=//*[text()='Book Store Application']
   Wait Until Page Contains              Author










