param (
    [Parameter(Mandatory=$true)]
    [string]$MacAddress
)

function Send-WOL {
    param (
        [string]$MacAddress,
        [string]$BroadcastAddress = "255.255.255.255",
        [int]$Port = 9
    )

    $mac = $MacAddress -replace "[:-]"
    if ($mac.Length -ne 12) {
        Write-Error "Invalid MAC address format"
        return
    }

    $macByteArray = [byte[]]::new(102)
    $macBytes = 0..5 | ForEach-Object { [byte]::Parse($mac.Substring($_ * 2, 2), [System.Globalization.NumberStyles]::HexNumber) }
    
    for ($i = 0; $i -lt 6; $i++) { $macByteArray[$i] = 0xFF }
    for ($i = 6; $i -lt 102; $i += 6) { $macBytes.CopyTo($macByteArray, $i) }
    
    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Connect($BroadcastAddress, $Port)
    $null = $udpClient.Send($macByteArray, $macByteArray.Length)
    $udpClient.Close()
}

Send-WOL $MacAddress

# .\wake_on_lan.ps1 -MacAddress "00-00-00-00-00-00"
