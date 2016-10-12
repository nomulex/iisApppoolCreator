# iisApppoolCreator
This is a simple powershell script that creates App Pools in IIS 
I used these sources 
http://geekswithblogs.net/QuandaryPhase/archive/2013/02/24/create-iis-app-pool-and-site-with-windows-powershell.aspx
https://gist.github.com/DamianMac/8211c53211136e88e9fe

You however need to run powershell with elevated previllages and also run the commmands below 
Import-Module ServerManager; Add-WindowsFeature Web-Scripting-Tools
 Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  -Scope Process -Force
 Get-ExecutionPolicy
