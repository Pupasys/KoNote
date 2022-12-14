; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "KoNote"
#define MyAppVersion "2.2.1"
#define MyAppPublisher "Konode"
#define MyAppURL "http://www.konode.ca"
#define MyAppExeName "KoNote.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{61F5BC5A-7700-44B1-A712-19C42AE5BDC6}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={userappdata}\{#MyAppName}
DisableDirPage=no
DefaultGroupName={#MyAppName}
OutputBaseFilename=konote-{#MyAppVersion}-win-setup
OutputDir=..\dist
SetupIconFile=..\dist\temp\nwjs-win\KoNote-win-ia32\src\icon.ico
LicenseFile=eula.txt
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Files]
Source: "..\dist\temp\nwjs-win\KoNote-win-ia32\KoNote.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\dist\temp\nwjs-win\KoNote-win-ia32\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
;Filename: "{app}\uninstall.exe"; Flags: runhidden
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; todo: add option to perform fresh installation instead of ugprade
Filename: "{app}\uninstall.exe"; Flags: runhidden

;[InstallDelete]
;Type: filesandordirs; Name: "{app}\data"

[Code]
var
  TypePage: TInputOptionWizardPage;
  DataDirPage: TInputDirWizardPage;
  DataDirPageID: Integer;

procedure InitializeWizard;
begin
  TypePage := CreateInputOptionPage(2,
    'Installation Type', 'Choose the setup type for this system',
    'Standard installation is recommended for most users. Select advanced installation to specify a custom location for the database.'#13#10,
    True, False);
  TypePage.Add('Standard Installation');
  TypePage.Add('Advanced Installation');
  TypePage.SelectedValueIndex := 0;

  DataDirPage := CreateInputDirPage(wpSelectDir,
    'Select Destination Location', 'Where should {#MyAppName} install its database?',
    '{#MyAppName} will store its database in the following folder.'#13#10,
    False, '');
  DataDirPage.Add('To continue, click Next. If you would like to select a different folder, click Browse.'#13#10);
  DataDirPage.Values[0] := GetPreviousData('DataDir', ExpandConstant('{userappdata}\{#MyAppName}')); 
  DataDirPageID := DataDirPage.ID;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  { Store the selected db folder for further reinstall/upgrade }
  SetPreviousData(PreviousDataKey, 'DataDir', DataDirPage.Values[0]);
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  if PageID = DataDirPageID then
    { if standard install is selected, skip the page }
    Result := TypePage.SelectedValueIndex = 0;
  if PageID = wpSelectDir then
    Result := TypePage.SelectedValueIndex = 0;
end;

procedure CurPageChanged(CurPageID: Integer);
var DataDirConfig: String;

begin
  if CurPageID = wpFinished then
	begin
		DataDirConfig := '{"backend": {"type": "file-system","dataDirectory": "' + DataDirPage.Values[0] + '\data"}}';
    StringChangeEx(DataDirConfig, '\', '/', True);
    SaveStringToFile(ExpandConstant('{app}\src\config\customer.json'), DataDirConfig, False);
	end;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var
  S: String;
begin
  { Fill the 'Ready Memo' with the normal settings and the custom settings }
  S := '';
  S := S + MemoDirInfo + NewLine;
  S := S + NewLine;
  S := S + 'Database location:' + NewLine;
  S := S + Space + DataDirPage.Values[0] + NewLine;
  S := S + NewLine;
  
  S := S + MemoTasksInfo;

  Result := S;
end;
