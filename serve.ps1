$prefix = 'http://localhost:5500/'
Add-Type -AssemblyName System.Net
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Serving $(Get-Location) at $prefix"

function Get-ContentType([string]$f) {
  switch ([System.IO.Path]::GetExtension($f).ToLower()) {
    '.html' { 'text/html' }
    '.css'  { 'text/css' }
    '.js'   { 'application/javascript' }
    '.png'  { 'image/png' }
    '.jpg'  { 'image/jpeg' }
    '.jpeg' { 'image/jpeg' }
    '.svg'  { 'image/svg+xml' }
    default { 'application/octet-stream' }
  }
}

while ($true) {
  $ctx = $listener.GetContext()
  $req = $ctx.Request
  $path = $req.Url.LocalPath
  if ([string]::IsNullOrEmpty($path) -or $path -eq '/') { $file = 'index.html' }
  else { $file = $path.TrimStart('/') }

  $full = Join-Path (Get-Location) $file
  if (Test-Path $full) {
    $bytes = [System.IO.File]::ReadAllBytes($full)
    $ctx.Response.ContentType = Get-ContentType $full
    $ctx.Response.ContentLength64 = $bytes.Length
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $ctx.Response.StatusCode = 404
    $msg = [System.Text.Encoding]::UTF8.GetBytes("Not Found")
    $ctx.Response.OutputStream.Write($msg,0,$msg.Length)
  }
  $ctx.Response.OutputStream.Close()
  $ctx.Response.Close()
}