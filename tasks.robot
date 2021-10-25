*** Settings ***
Documentation   Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Resource  keywords.robot
Resource  Preview.robot


*** Variables ***
${order_number}

*** Keywords  ***
Fill the form
  [Arguments]    ${localrow}
    ${head}=    Convert To Integer    ${localrow}[Head]
    ${body}=    Convert To Integer    ${localrow}[Body]
    ${legs}=    Convert To Integer    ${localrow}[Legs]
    ${address}=    Convert To String    ${localrow}[Address]
    Select From List By Value   id:head   ${head}
    Click Element   id-body-${body}
    Input Text      id:address    ${address}
    Input Text      xpath:/html/body/div/div/div[1]/div/div[1]/form/div[3]/input  ${legs}

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Get the URL from vault and Open the robot order website
    ${orders} =  Get Orders 
    FOR  ${row}  IN  @{orders}
      Close the annoying modal
      Fill the form  ${row}
      Preview the robot
      Submit the order
      ${pdf}=  Store the receipt as a PDF file  ${row}[Order number]
      ${screenshot}=  Take a screenshot of the robot  ${row}[Order number]
      Embed the robot screenshot to the receipt PDF file  ${screenshot}  ${pdf}
      Go to order another robot
    END
    Create a ZIP file of the receipts
    [Teardown]  Close Browser
