#region DSC Configuration Definitions
Configuration IISWebSite
{
    param 
    (
        [System.String[]]
        $NodeName = "localhost"
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration, xWebAdministration, xNetworking

    Node $NodeName
    {
        #region Windows Features

        # Web Server (IIS)
        WindowsFeature Web-Server
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        # Web Server (IIS) > Web Server > Management Tools
        WindowsFeature Web-Mgmt-Tools
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Tools'
            DependsOn = '[WindowsFeature]Web-Server'
        }

        # Web Server (IIS) > Web Server > Management Tools > IIS Management Console
        WindowsFeature Web-Mgmt-Console
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Console'
            DependsOn = '[WindowsFeature]Web-Mgmt-Tools'
        }
        #endregion Windows Features
        
        #region Website Configuration
        xWebsite DefaultSite
        {
            Ensure          = 'Present'
            Name            = 'Default Web Site'
            PhysicalPath    = 'C:\inetpub\wwwroot'
            DependsOn       = '[WindowsFeature]Web-Server'
            BindingInfo = @(
            MSFT_xWebBindingInformation
            {
                Protocol              = 'HTTP' 
                Port                  = '8080'
                IPAddress             = '*'
            })
        }
        #endregion Website Configuration

        #region Firewall Configuration
        xFirewall Firewall
        {
            Name                  = 'Allow 8080 port'
            DisplayName           = 'Allow 8080 port'
            Ensure                = 'Present'
            Enabled               = 'True'
            Action                = 'Allow'
            Profile               = 'Public'
            Direction             = 'Inbound'
            LocalPort             = '8080'
            Protocol              = 'TCP'
            Description           = 'Firewall Rule for 8080 port'
        }
        #endregion Firewall Configuration
    }
}
#endregion DSC Configuration Definitions
