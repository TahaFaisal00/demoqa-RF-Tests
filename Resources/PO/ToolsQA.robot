*** Settings ***
Library                                  Browser

*** Keywords ***
Verify TOOLSQA Page loaded
   Wait For Elements State    css=a[href="https://demoqa.com"]      visible

Click Book Store Link
   Click                      css=a[href="/books"]











