<#
.SYNOPSIS
    This script debloat Windows 11 by removing unnecessary apps and services.
.DESCRIPTION
    #TODO: Add description
.PARAMETER ParameterName
    #TODO: Add prameter description
.EXAMPLE
    #TODO: Add example
.NOTES
    #TODO: Add notes
#>

function Remove-3DViewer {
    # Remove 3D Viewer for all Users
    Get-AppxPackage *3dviewer* -AllUsers | Remove-AppxPackage    
}

function Install-3DViewer {
    # Install 3D Viewer
    Get-AppxPackage *3dviewer* -AllUsers | Add-AppxPackage
}

function Remove-FeedbackHub {
    # Remove Feedback Hub for all Users
    Get-AppxPackage *feedbackhub* -AllUsers | Remove-AppxPackage    
}

function Install-FeebackHub {
    # Install Feedback Hub
    Get-AppxPackage *feedbackhub* -AllUsers | Add-AppxPackage
}

function Remove-FreshPaint {
    # Remove Fresh Paint for all Users
    Get-AppxPackage *freshpaint* -AllUsers | Remove-AppxPackage    
}

function Install-FreshPaint {
    # Install Fresh Paint
    Get-AppxPackage *freshpaint* -AllUsers | Add-AppxPackage
}
function Remove-GetHelp {
    # Remove Get Help for all Users
    Get-AppxPackage *gethelp* -AllUsers | Remove-AppxPackage    
}

#Call all remove functions
Remove-3DViewer
Remove-FeedbackHub
Remove-FreshPaint
Remove-GetHelp