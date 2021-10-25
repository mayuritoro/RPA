*** Settings ***
Library  RPA.Browser.Selenium
Library  RPA.Tables
Library  RPA.HTTP
Library  RPA.FileSystem
Library  RPA.Archive
Library  RPA.Robocloud.Secrets
Library  RPA.JSON
Library  RPA.Dialogs
Library  RPA.Excel.Files

*** Keywords ***
Get the URL from vault and Open the robot order website
    Get the URL from vault and Open the robot order website
    ${url}=    Get Secret    credentials
    Log        ${url}
    Open Available Browser      ${url}[robotsparebin]

*** Keywords ***
Get orders.csv URL from User
  Create Form    Orders.csv URL
  Add Text Input    URL    url
  &{response}    Request Response
  [Return]    ${response["url"]}

*** Keywords ***
Get Orders
  ${CSV_FILE_URL}=    Get orders.csv URL from User
    Download        ${CSV_FILE_URL}           overwrite=True
  ${table}=  Read Table From Csv  orders.csv  dialect=excel
  FOR  ${row}  IN  @{table}
    Log  ${row}
  END
  [Return]  ${table}

*** Keywords ***
Close the annoying modal
  Click Button  OK


