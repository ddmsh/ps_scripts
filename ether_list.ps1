Get-NetAdapter -Physical | 
    Where-Object { $_.MediaType -eq "802.3" } | 
    ForEach-Object {
        $config = Get-NetIPConfiguration -InterfaceAlias $_.Name
        [PSCustomObject]@{
            Name = $_.Name
            MAC = $_.MacAddress
            IP = ($config.IPv4Address.IPAddress -join ", ")
            Subnet = $config.IPv4Address.PrefixLength
            Gateway = $config.IPv4DefaultGateway.NextHop
            DNS = ($config.DNSServer.ServerAddresses -join ", ")
        }
    } | Format-Table -AutoSize
