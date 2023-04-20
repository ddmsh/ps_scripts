# Get network adapters list
$adapters = Get-NetAdapter -Physical | Where-Object { $_.MediaType -eq "802.3" }

# Create custom adapter objects with Name, MAC Address, IP Address, Subnet Mask, Gateway, 1st DNS, and 2nd DNS properties
$customAdapters = $adapters | ForEach-Object {
    $adapterName = $_.Name
    $macAddress = $_.MacAddress
    $ipConfig = Get-NetIPConfiguration -InterfaceAlias $adapterName
    $ipAddresses = ($ipConfig | Select-Object -ExpandProperty IPv4Address).IPAddress
    $subnetMask = ($ipConfig | Select-Object -ExpandProperty IPv4Address).PrefixLength
    $gateway = ($ipConfig | Select-Object -ExpandProperty IPv4DefaultGateway).NextHop
    $dnsServers = $ipConfig.DNSServer.ServerAddresses

    New-Object -TypeName PSObject -Property @{
        Name = $adapterName
        MAC = $macAddress
        "IP Addresses" = ($ipAddresses -join ", ")
        Subnet = $subnetMask
        Gateway = $gateway
        DNS = $dnsServers[0]
        "2nd DNS" = $dnsServers[1]
    }
} | Select-Object Name, MAC, "IP Addresses", Subnet, Gateway, DNS, "2nd DNS"

# Display adapter information in a table
$customAdapters | Format-Table -AutoSize
