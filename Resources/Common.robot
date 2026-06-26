*** Settings ***
Library             Browser

*** Variables ***
${URL}                  https://demoqa.com/
${BROWSER}              chromium
${WINDOWS_WIDTH}        1366
${WINDOWS_HEIGHT}       768

*** Keywords ***
Launch Suite Browser
    [Documentation]     Opens the browser in headless mode. Used as suite setup.
    New Browser         ${BROWSER}           headless=${True}

Start Clean Session
    [Documentation]     Opens a new page for the website URL with a fresh cookies and storage. Used as test setup.
    New Context     viewport={'width':${WINDOWS_WIDTH} , 'height':${WINDOWS_HEIGHT}}        tracing=True        recordVideo={'dir': 'video/'}
    New Page        ${URL}       wait_until=commit
    Wait For Elements State    text=Book Store Application    visible    timeout=15s

End Session
    [Documentation]     Drops the context: Deletes the cookies and storage and close the page. Used as test teardown
    Close Context           save_trace=True
    # Run the trace through: playwright show-trace (Get-ChildItem C:\development\demoqa\log\browser\traces\trace_context=*.zip | Sort-Object LastWriteTime | Select-Object -Last 1).FullName
Shutdown Browser
    [Documentation]     Closes the whole browser. Used as Suite Teardown
    Close Browser
