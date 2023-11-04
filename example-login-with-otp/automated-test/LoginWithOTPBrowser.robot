*** Settings ***
Library    Browser
Library    RequestsLibrary

*** Variables ***
${USERNAME}    admin
${PASSWORD}    password

*** Test Cases ***
Test Example Login with OTP
    New Browser    chromium    headless=false    args=["--start-maximized"]
    New Context    viewport=${None}
    New Page       file:///D:/Project/ProjectAutomateTest/example-login-with-otp/front-end/index.html
    Fill Text    id=username    ${USERNAME}
    Fill Text    id=password    ${PASSWORD}
    Click    id=login-btn
    ${response} =    Wait For Response    response => response.url() === 'http://127.0.0.1:5000/login' && response.status() === 200
    Log    response: ${response}
    ${otpToken}    Set Variable    ${response["body"]["data"]["otpToken"]}
    Log    otpToken: ${otpToken}
    ${otp} =    Call GET OTP API    ${otpToken}
    Log    otp: ${otp}
    Fill Text    id=otp    ${otp}
    Click    id=otp-verify-btn
    Wait For Elements State    id=home-page    visible
    Sleep    1s

*** Keywords ***
Call GET OTP API
    [Arguments]    ${otpToken}
    Create Session    GetOTPSession    http://127.0.0.1:5000
    ${data} =    Create Dictionary    otpToken=${otpToken}
    ${headers} =    Create Dictionary    Content-Type=application/json
    ${response} =    Post On Session    GetOTPSession    /get-otp    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json_response} =    Evaluate    json.loads($response.text)
    ${otp} =    Set Variable    ${json_response["data"]["otp"]}
    [Return]    ${otp}
    