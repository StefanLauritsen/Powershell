function New-VesselHotFolderSetup
{
    <#
        .Synopsis
           TBD-Synopsis
        .DESCRIPTION
           TBD-DESCRIPTION
        .EXAMPLE
           Create new Vessel for Development
           New-VesselHotFolderSetup -Environment "Development" -IMO 1234567
        .EXAMPLE
           Create new Vessel for Production, skipping confirmation request
           New-VesselHotFolderSetup -Environment "Production" -IMO 9214444 -Confirm
        .NOTES
           Author: Stefan Scheffmann Lauritsen @ Atea Denmark
           Version: MLIT-FileCatalyst.psm1 v1.0.0
           Date: 17/1/2016
           Comments:
    
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
        HelpMessage="Define environment to manage - Production | Pre-Production | Development")]
        [String]$Environment = "TBD",
                 
        [Parameter(Mandatory=$True,
        HelpMessage="Define vessel IMO")]
        [String]$IMO = 0000000,

        [Parameter(Mandatory=$false,
        HelpMessage="Skip confirmation step")]
        [Switch]$Confirm

    )
    Process
    {

        
        # $VesselServername used with #Verify Java version 8.0.101*,          
        $VesselServername = $IMO+"vsfile"
        #$VesselServername = "localhost"

        #Setting the Install Drive to Vessels C:\ & Data Drive to Vessels E:\
        $InstallDrive="\\"+$VesselServername+"\C$"
        $DataDrive="\\"+$VesselServername+"\E$"
        
        $ScriptRoot="\\Svmcifsbal02\icewarpvessels_prod\FileCatalyst-Admin\FC-Installation-Vessel"
        #$ScriptRoot = "c:\temp"

        #Environment/ScriptRoot selection
        $EnvironmentSelected = $false
        While (!$EnvironmentSelected)
        {
        if ($Environment -eq "Production")
        {
            $VesselsFile = $ScriptRoot+"\Production-Vessels.ini"
            $EnvironmentHost = "10.255.159.172"            
            $EnvironmentSelected = $True
        }
        elseif ($Environment -eq "Pre-Production")
        {
            $VesselsFile = $ScriptRoot+"\PreProduction-Vessels.ini"
            $EnvironmentHost = "10.255.153.36"  
            $EnvironmentSelected = $True    
        }
        elseif ($Environment -eq "Development")
        {
            $VesselsFile = $ScriptRoot+"\Development-Vessels.ini"
            $EnvironmentHost = "127.0.0.1"  
            $EnvironmentSelected = $True    
        }
        else
        {
               Write-host "Please pick between one of these Environments: Production | Pre-Production | Development" -ForegroundColor Yellow
               $EnvironmentSelected = $false
               $Environment = Read-Host "Environment"
        }
        }


                #Import Copy-Files.ini to 2D Array
                $CreateFolders = get-content $ScriptRoot"\Create-Folders.ini"
                         
                    $FolderArray=@()
                        
                    Foreach ($element in $CreateFolders) {
                    $element=$element.Replace("%DataDrive%",$DataDrive)
                    $element=$element.Replace("%InstallDrive%",$InstallDrive)
                    $element=$element.Replace("%ScriptRoot%",$ScriptRoot)
                    #$element=$element.split(",")
                    $FolderArray+= ,@( $element)
                }
                #Test above step in CMDlet - (Import Copy-Files.ini to 2D Array):
      #          Foreach ($Folder in $FolderArray) { write-host $Folder }


        
      #  $FolderArray = @(
      #                  #FC Application folders
      #                  $InstallDrive+"\FileCatalyst",
      #                  $InstallDrive+"\FileCatalyst\HotFolder",
      #                  #FC Data and Script Folders
      #                  $DataDrive+"\FileCatalyst",
      #                  $DataDrive+"\FileCatalyst\Reports",
      #                  $DataDrive+"\FileCatalyst\Scripts",
      #                  #FC Application HotFolders
      #                  $DataDrive+"\Common",
      #                  $DataDrive+"\Common\AutoMail",
      #                  $DataDrive+"\Common\AutoMail\winadmi\in",
      #                  $DataDrive+"\Common\AutoMail\winadmi\out",
      #                  $DataDrive+"\Common\Post\News",
      #                  $DataDrive+"\Common\RMQS",
      #                  $DataDrive+"\Common\Spos",
      #                  $DataDrive+"\Common\Spos\News",
      #                  $DataDrive+"\Common\VesselBunker",
      #                  $DataDrive+"\Common\VesselBunker\Import",
      #                  $DataDrive+"\Common\AutoMail\SeaHealth\Updates\In",
      #                  $DataDrive+"\Common\AutoMail\SeaHealth\Updates\Out",
      #                  #FC IT Ops HotFolders
      #                  $DataDrive+"\FileCatalyst\ITOPS-In",
      #                  $DataDrive+"\FileCatalyst\ITOPS-Out",
      #                  #FC Mail HotFolders
      #                  $DataDrive+"\FileCatalyst\Mail-In",
      #                  $DataDrive+"\FileCatalyst\Mail-Out"
      #                      )

                        #Import Copy-Files.ini to 2D Array
                        $CopyFiles = get-content $ScriptRoot"\Copy-Files.ini"
                         
                           $CopyArray=@()
                        
                            Foreach ($elements in $CopyFiles) {
                            $elements=$elements.Replace("%DataDrive%",$DataDrive)
                            $elements=$elements.Replace("%InstallDrive%",$InstallDrive)
                            $elements=$elements.Replace("%ScriptRoot%",$ScriptRoot)
                            $elements=$elements.split(",")
                            $CopyArray+= ,@( $elements[0],$elements[1])
                        }
                        #Test above step in CMDlet - (Import Copy-Files.ini to 2D Array):
              #          Foreach ($Copy in $CopyArray) { write-host $Copy[0] "copy to" $Copy[1] }



      #  $CopyArray = @(
      #                 #Copy FC files
      #                 ("$ScriptRoot\FC-Install-files\HotFolder\*.*",
      #                     "$InstallDrive\FileCatalyst\HotFolder\"),
      #                 #Copy Links to desktop...
      #                 ("$ScriptRoot\FC-Install-files\FileCatalyst-HotFolder.lnk",
      #                     "$InstallDrive\Users\Public\Desktop"),
      #                 ("$ScriptRoot\FC-Install-files\Admin-FileCatalyst-Hotfolder.lnk",
      #                     "$InstallDrive\Users\Public\Desktop"),
      #                 #Copy FC settings..."
      #                 ("$ScriptRoot\FC-Install-files\Settings\*.xml",
      #                     "$InstallDrive\FileCatalyst\HotFolder"),
      #                 ("$ScriptRoot\FC-Install-files\Settings\*.conf",
      #                     "$InstallDrive\FileCatalyst\HotFolder"),
      #                 #Copy FC Scripts...
      #                 ("$ScriptRoot\FC-Install-files\Settings\*.cmd",
      #                     "$DataDrive\FileCatalyst\Scripts")
      #                     )
      #


      
        #Define array of existing Vessels based on selected Environment
        $Vessels = get-content $VesselsFile
        

        #Check if Vessel already exist
        $Vessels | ForEach-Object { if ($_ -eq $IMO) {$VesselExist = $true} }
        if (!$VesselExist)
        {
               
        #If -Confirm parameter not used, ask for confirmation.
        if(!$Confirm -and $EnvironmentSelected)
        {
            Write-Host "WARNING: You are about to add new site IMO" $IMO "to the" $Environment -foregroundcolor Yellow
            $ConfirmInput = Read-Host "Are you sure you want to proceed? If Yes, type ""Y"""
            if ($ConfirmInput -eq "Y") { $Confirm = $True }
            Else { Write-Host "Deployment aborted" -ForegroundColor Red }
         }
        #If setup changes confirmed, execute script
        If($Confirm -and $EnvironmentSelected)
        {

        #Check connection to Vessel server
        if (Test-Path $InstallDrive)
        {

        #Verify Java version 8.0.101*
        $JavaVersions = @(Get-WmiObject -Class Win32_Product -ComputerName $VesselServername -Filter "Name like 'Java%'" | Select -Expand Version)

            foreach ($JavaVersion in $JavaVersions) 
            {
                write-host "Java version " $JavaVersion "installed"
                if ($JavaVersion -like "8.0.101*")
                {
                    write-host "Java version 8.0.101* installed"
                    $JavaCompliant = $true
                } 
            }
            if ($JavaCompliant -eq $true)
            {
                write-host "Java version 8.0.101 already installed on" $IMO"vsfile"   
            }
            else
            {
                Write-Host "Starting Java version 8.0.101 installation"
                $InstallJava = "\\svmcifsbal02\icewarpvessels_prod\FileCatalyst-Admin\FC-Installation-Vessel\jre-8u101-windows-x64.exe /s INSTALLDIR=C:\FileCatalyst\Java STATIC=1"
                ([WMICLASS]"\\$VesselServername\ROOT\CIMV2:Win32_Process").Create($InstallJava)

            }

            Write-host "Installing from $PSScriptRoot"
            Write-host "Installing FileCatalyst HotFolder to" $InstallDrive"\FileCatalyst\HotFolder"
            Write-host  "Creating folders..."
            
            #Create folder structure on Vessel
            Foreach ($CreatePath in  $FolderArray)
            {
                If(!(Test-Path $CreatePath))
                {
                    try { New-Item $CreatePath -ItemType Directory -ErrorAction SilentlyContinue }
                    catch { Write-host "Something went wrong creating Path:" $CreatePath}
                }
                Else
                {
                    Write-Host $CreatePath "already exist"
                }
            }
            #Copy File structure to Vessel
            Foreach ($Copy in $CopyArray)
            {
                If(!(Test-Path $Copy[1]))
                {
                    try { Copy-Item $Copy[0] $Copy[1] -ErrorAction SilentlyContinue }
                    catch { write-host "Something went wrong, please verify files in:" $Copy[1] }
                }
                Else
                {
                    Write-Host $Copy[0] "already exist on Vessel"
                }
            }
 
  
            #Set Vessel Login
            Write-Host "Setting Vessel Login"
            $IMOUSER = $IMO+"FILECAT"
            (Get-Content $InstallDrive"\FileCatalyst\HotFolder\sites.xml") | foreach-object {$_ -replace "TEMPLATE", $IMOUSER } | Set-Content $InstallDrive"\FileCatalyst\HotFolder\sites.xml"


            #Set FileCatalyst Server Site IP
            (Get-Content $InstallDrive"\FileCatalyst\HotFolder\sites.xml") | foreach-object {$_ -replace "10.255.159.172", $EnvironmentHost } | Set-Content $InstallDrive"\FileCatalyst\HotFolder\sites.xml"


            #Install & Start FC HotFolder Service
            Write-Host "Installing FileCatalyst HotFolder service"

            Write-Host  $InstallFCHotFolderService "cmd.exe -c '$InstallDrive\FileCatalyst\HotFolder\install_fchotfolder_service.bat'"
            #$InstallFCHotFolderService = "cmd.exe -c '$InstallDrive\FileCatalyst\HotFolder\install_fchotfolder_service.bat'"
            #([WMICLASS]"\\$VesselServername\ROOT\CIMV2:Win32_Process").Create($InstallFCHotFolderService)


           Write-Host "Start service FileCatalyst HotFolder" 
           Try {Get-Service -Name "FileCatalyst HotFolder" -ComputerName $VesselServername | Start-service}
           Catch { Write-Host "Service could not be started" -ForegroundColor Red}   
           
           #Add Vessel to Vessels file (Production | PreProduction | Development )
           Add-Content $VesselsFile -Value $IMO
           
           #Console: Installation completed
           Write-Host "Installation completed! Please review any errors occoured during installation."       
        }
        else
        {
        write-host "Could not etablish connection to" $VesselServername "- Deployment aborted - $installdrive" -ForegroundColor Red
        }
        }
        }
        else
        {
        Write-Host "Vessel" $VesselServername "already installed - Deployment aborted" -ForegroundColor Red
        }

    }

}
function Get-VesselHotFolderSetup
{
}
function Update-VesselHotFolderSetup
{
}
function Remove-VesselHotFolderSetup
{

    #        @echo off
    #        set FCDRIVE=C:
    #        set DATADRIVE=E:
    #        echo UnInstalling FileCatalyst HotFolder from %FCDRIVE%\FileCatalyst\HotFolder
    #        echo Stop service...
    #        net stop "FileCatalyst HotFolder"
    #        echo Remove service...
    #        call %FCDRIVE%\FileCatalyst\HotFolder\uninstall_fchotfolder_service.bat
    #        echo Deleting App files...
    #        del %FCDRIVE%\Users\Public\Desktop\FileCatalyst-HotFolder.lnk
    #        del %FCDRIVE%\Users\Public\Desktop\Admin-FileCatalyst-HotFolder.lnk
    #        del %FCDRIVE%\FileCatalyst\HotFolder\*.* /s /q
    #        rmdir /s /q %FCDRIVE%\FileCatalyst\HotFolder
    #        
    #        echo Deleting Data files...
    #        del %DATADRIVE%\FileCatalyst\*.* /s /q
    #        rmdir /s /q %DATADRIVE%\FileCatalyst
    #        
    #        pause




#Remove Vessels from Vessel file
(Get-Content $VesselsFile) | foreach-object {$_ -replace $IMO, "" } | Set-Content $VesselsFile

#Remove empty lines from Vessel file
(Select-String -Pattern "\w" -Path $VesselsFile) | ForEach-Object { $_.line } | Set-Content $VesselsFile


}
function Get-HotFolderDetails
{
}
function Set-HotFolderDetails
{
}

