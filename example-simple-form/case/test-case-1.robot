*** Settings ***
Documentation       Test: Fill and Submit Form

Library             Screenshot
Library             SeleniumLibrary

*** Variables ***
${URL}          file:///D:/Project/ProjectAutomateTest/example-simple-form/app/index.html
${BROWSER}      firefox


*** Keywords ***
Open App
    Open Browser    ${URL}    ${BROWSER}

Fill Name
    Input Text       id=name     John Doe

Fill Gender
    Click Element   id=male

Fill Subject
    Select From List by Value    id=subject    math

Fill Favorite
    Click Element   id=football
    Click Element   id=tennis

*** Test Cases ***

Open App Case
    Open App
    Capture Page Screenshot    01-open-app-case-success.png

Fill Name Case
    Fill Name
    Capture Page Screenshot    02-fill-name-case-success.png

Fill Gender Case
    Fill Gender
    Capture Page Screenshot    03-fill-gender-case-success.png

Fill Subject Case
    Fill Subject
    Capture Page Screenshot    04-fill-subject-case-success.png

Fill Favorite Case
    Fill Favorite
    Capture Page Screenshot    05-fill-favorite-case-success.png

Submit Case
    Click Element   css=input[type='submit']
    Wait Until Page Contains      Success! All fields are filled.
    Capture Page Screenshot       06-submit-case-success.png
