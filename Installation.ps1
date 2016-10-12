Import-Module WebAdministration
$iisAppPoolName =  Read-Host -Prompt 'Please Enter the app pool name'
$iisAppPoolDotNetVersion = "v4.0"
$iisAppUrl = Read-Host -Prompt 'Please Enter the site url'
$directoryPath =  Read-Host -Prompt 'Please Enter the driectory path of the app pool to be created'

Write-Host "Now sit back and relax as we create your app pool: $iisAppPoolName"

#We create the directory if it does not exist 

Write-Host "Creating directory...$directoryPath"
 md -Force $directoryPath | Out-Null

# New-Item -ItemType Directory -Force -Path  $directoryPath


#navigate to the app pools root
cd IIS:\AppPools\

Write-Host "Creating apppool...$iisAppPoolName"

#check if the app pool exists
if (!(Test-Path $iisAppPoolName -pathType container))
{
    #create the app pool
    $appPool = New-Item $iisAppPoolName
    $appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value $iisAppPoolDotNetVersion
}

#navigate to the sites root
cd IIS:\Sites\

Write-Host "Creating creating site...$iisAppName"

#check if the site exists
if (Test-Path $iisAppPoolName -pathType container)
{
    return
}

#create the site
$iisApp = New-Item $iisAppPoolName -bindings @{protocol="http";bindingInformation=":80:" + $iisAppUrl} -physicalPath $directoryPath
$iisApp | Set-ItemProperty -Name "applicationPool" -Value $iisAppPoolName


Write-Host "Setting Directory Rights "


    $acl = Get-Acl $directoryPath
    $inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $propagation = [system.security.accesscontrol.PropagationFlags]"None"

    $permission = 'IIS_IUSRS',"FullControl", $inherit, $propagation, "Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($accessRule)
    
    $permission = 'NETWORK SERVICE',"FullControl", $inherit, $propagation, "Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($accessRule)
    
    $permission = 'LOCAL SERVICE',"FullControl", $inherit, $propagation, "Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($accessRule)   

    $permission = "IIS APPPOOL\$iisAppPoolName","FullControl", $inherit, $propagation, "Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($accessRule)  

    $permission = "IUSR","FullControl", $inherit, $propagation, "Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($accessRule) 
    
   Set-Acl $directoryPath   $acl 
