param ([Parameter(Mandatory=$true)][string]$MacAddress)

$mac = ($MacAddress -replace '[:-]').ToUpper()
if ($mac.Length -ne 12) { throw "Invalid MAC address" }

$magic = [byte[]](,0xFF * 6)
$macBytes = 0..5 | ForEach-Object { 
    [Convert]::ToByte($mac.Substring($_ * 2, 2), 16)
}

$packet = $magic + ($macBytes * 16)
$udp = [System.Net.Sockets.UdpClient]::new()
$udp.Connect("255.255.255.255", 9)
$udp.Send($packet, $packet.Length)
$udp.Close()
