*** Settings ***
Library  RPA.Browser.Selenium
Library  RPA.Tables
Library  RPA.HTTP
Library  RPA.FileSystem
Library  RPA.Dialogs
Library  RPA.Archive
Library  RPA.Excel.Files
Library  RPA.Robocloud.Secrets
Library  RPA.PDF

*** Variables ***
${GLOBAL_RETRY_AMOUNT}=    10x
${GLOBAL_RETRY_INTERVAL}=    1s
${order_number}

*** Keywords ***
Preview the robot
  Click Element    id:preview
  Wait Until Element Is Visible    id:robot-preview-image

*** Keywords ***
Submit the order and keep checking until success
  Click Element    id:order
  Element Should Be Visible  id:receipt
  Element Should Be Visible  id:order-completion

*** Keywords ***
Submit the order
  Wait Until Keyword Succeeds    ${GLOBAL_RETRY_AMOUNT}    ${GLOBAL_RETRY_INTERVAL}     Submit the order and keep checking until success

*** Keywords ***
Store the receipt as a PDF file
    [Arguments]    ${order_number}
    Wait Until Element Is Visible    id:order-completion
    ${order_number}=    Get Text    xpath://div[@id="receipt"]/p[1]
    #Log    ${order_number}
    ${receipt_html}=    Get Element Attribute    id:order-completion    outerHTML
    Html To Pdf  ${receipt_html}  ${CURDIR}${/}output${/}receipts${/}${order_number}.pdf
    [Return]  ${CURDIR}${/}output${/}receipts${/}${order_number}.pdf

*** Keywords ***
Take a screenshot of the robot
    [Arguments]    ${order_number}
    Screenshot     id:robot-preview-image    ${CURDIR}${/}output${/}${order_number}.PNG
    [Return]       ${CURDIR}${/}output${/}${order_number}.PNG

*** Keywords ***
Embed the robot screenshot to the receipt PDF file
    [Arguments]    ${screenshot}   ${pdf}
    Open Pdf       ${pdf}
    Add Watermark Image To Pdf    ${screenshot}    ${pdf}
    Close Pdf      ${pdf}

*** Keywords ***
Go to order another robot
  Click Element    id:order-another

*** Keywords ***
Create a ZIP file of the receipts
    Archive Folder With Zip  ${CURDIR}${/}output${/}receipts   ${CURDIR}${/}output${/}receipt.zip
