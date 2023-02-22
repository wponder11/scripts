<#
 #Description
  Script will check MDM enrollment status and type
 
 #Usage
  . .\get-mdmstatus.ps1    

 #MOD_HISTORY
  Version:1
  Created: 02-15-2023
    
 #AUTHOR: Warren Ponder
#>

function Invoke-TranslateMDMEnrollmentType {
    [OutputType([String])]
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory=$False)]
        [Int]$Id
    )
    switch($Id){
        0 {"Not enrolled"}
        6 {"MDM enrolled"}
        13 {"Azure AD joined"}
    }
}

#Locate correct Enrollment Key
$EnrollmentKey = Get-Item -Path HKLM:\SOFTWARE\Microsoft\Enrollments\* | Get-ItemProperty | Where-Object -FilterScript {$null -ne $_.UPN}
if($EnrollmentKey){
    Add-Member -InputObject $EnrollmentKey -MemberType NoteProperty -Name EnrollmentTypeText -Value (Invoke-TranslateMDMEnrollmentType -Id ($EnrollmentKey.EnrollmentType))
    Write-Output "Enrollment Type: $($EnrollmentKey.EnrollmentTypeText)"
}  
else{
    Write-Output "Device is not enrolled in MDM"
