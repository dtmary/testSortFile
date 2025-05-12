unit uMainGenerate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtDlgs, Vcl.ExtCtrls, Vcl.NumberBox,
  System.ImageList, Vcl.ImgList, Vcl.ComCtrls;
type

  TfmGenerate = class(TForm)
    stfDialog: TSaveTextFileDialog;
    edtFileName: TEdit;
    ActionList1: TActionList;
    SpeedButton1: TSpeedButton;
    actGenerate: TAction;
    StatusBar: TStatusBar;
    ImageList: TImageList;
    Panel1: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    ActCancel: TAction;
    edtSize: TNumberBox;
    LinkLabel1: TLinkLabel;
    ActSetFilePath: TAction;
    ProgressBar: TProgressBar;
    lbGen: TLinkLabel;
    procedure ActSetFilePathExecute(Sender: TObject);
    procedure actGenerateExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure stopaction;
  private
    { Private declarations }
     bstop:boolean;
  public
    { Public declarations }
  end;

const
  MEGABITE = 1024*1024;

var
  fmGenerate: TfmGenerate;
  function GetFileSize(FileName: string): Int64;

implementation

{$R *.dfm}

procedure TfmGenerate.stopaction;
begin
  bstop := true;
  lbGen.Visible := false;
  ProgressBar.Visible := false;
  actGenerate.Enabled := true;
  ActCancel.Enabled := false;
end;

procedure TfmGenerate.ActCancelExecute(Sender: TObject);
begin
  stopaction;
end;

procedure TfmGenerate.actGenerateExecute(Sender: TObject);
var
  f:TextFile;
  sWrite:string;
  count:longInt;
  fileName:String;
  needFileSize:Int64;
  cureileSize:int64;
begin
  bstop := false;
  actGenerate.Enabled := false;
  ActCancel.Enabled := true;
  fileName := edtFileName.Text;
  AssignFile(f, fileName);
  rewrite(f);
  needFileSize := StrToInt(edtSize.text)*MEGABITE;
  lbGen.Visible := true;
  ProgressBar.Visible := true;
  ProgressBar.Max := StrToInt(edtSize.text);
  try
    count := 0;
    needFileSize := MEGABITE*StrToInt(edtSize.text);
    cureileSize := 0;
    WriteLn(f,'1.Мама мыла раму');
    WriteLn(f,'2.Шла по телеку реклама');
    WriteLn(f,'4.Шла по телеку реклама');
    WriteLn(f,'3.Кончилась реклама');
    WriteLn(f,'4.Мама есть, но нету рамы');
    WriteLn(f,'15.Шла Саша по шоссе');
    while ((cureileSize <= needFileSize) and not(bstop)) do
    begin
      cureileSize := GetFileSize(fileName);
      sWrite := IntToStr(random(2000000)) + '.'+ IntToStr(random(1000));
      WriteLn(f,sWrite);
      count := count + 1;
      if (count mod 200000) = 0 then
      begin
        StatusBar.Panels[0].Text := intToStr(count);
        StatusBar.Panels[1].Text := IntToStr(trunc(GetFileSize(fileName)/MEGABITE)) + ' из '+ edtSize.text+'МБ';
        ProgressBar.Position := trunc(GetFileSize(fileName)/MEGABITE);
        Application.ProcessMessages;
      end;
    end;
  finally
    closeFile(f);
  end;
  stopaction;
end;

procedure TfmGenerate.ActSetFilePathExecute(Sender: TObject);
begin
  if stfDialog.Execute then
    edtFileName.Text := stfDialog.Files[0];
end;

procedure TfmGenerate.FormCreate(Sender: TObject);
begin
  bstop := false;
end;

function GetFileSize(FileName: string): Int64;
var
  info: TWin32FileAttributeData;
begin
try
  if not getFileAttributesEX(Pchar(FileName),GetFileExInfoStandard, @info)  then
    EXIT;
  result := Int64(info.nFileSizeLow);
except
  Result := -1;
end;

end;

end.
