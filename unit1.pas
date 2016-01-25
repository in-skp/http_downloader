unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, httpsend;

const
  HTTP_RESPONSE_OK = 200;
  Links : array[1..28] of string = (
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/niftyStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxInfraStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/juniorNiftyStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/nseliquidStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/niftyMidcap50StockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxitStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/bankNiftyStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxRealtyStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxEnergyStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxFMCGStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxMNCStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/ni15StockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxPharmaStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxPSEStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxPSUStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxServiceStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/etfStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/iLStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/goldEtfStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cbmSecListStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxCommoditiesStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxConsumptionStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cpseStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxFinanceStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxAutoStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxDividendOpptStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxMediaStockWatch.json',
    'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/cnxMetalStockWatch.json'
      );
type

  { TForm1 }

  TForm1 = class(TForm)
    ApplicationProperties1: TApplicationProperties;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    procedure ApplicationProperties1Minimize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    { private declarations }
    FilePath : string;

  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

{function GetPage(aURL: string): string;
var
  Response: TStringStream;
  HTTP: TIdHTTP;
begin
  Result := '';
  Response := TStringStream.Create('');
  try
    HTTP := TIdHTTP.Create(nil);
    try
      HTTP.Get(aURL, Response);
      if HTTP.ResponseCode = HTTP_RESPONSE_OK then begin
        Result := Response.DataString;
      end else begin
        // TODO -cLogging: add some logging
      end;
    finally
      HTTP.Free;
    end;
  finally
    Response.Free;
  end;
end;}

procedure TForm1.Button1Click(Sender: TObject);
var
httpClient: string;
begin
 //httpClient := GetPage('http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/niftyStockWatch.json');
 memo1.Lines.Add(httpClient);
end;

procedure TForm1.ApplicationProperties1Minimize(Sender: TObject);
begin
  WindowState:= wsMinimized;
  Hide;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  httpClient: THTTPSend;
  Header : TStringList;
  i : integer;
  FileName : string;
  RemoveStr : string = 'http://www.nseindia.com/live_market/dynaContent/live_watch/stock_watch/';
begin
  Timer1.Enabled:=False;
  Header := TStringList.Create;
  Header.Add('Accept: text/html');  // + row !!!!!!!!!!!


  Memo1.lines.clear;
  for i:= Low(Links) to High(Links) do
  begin
    httpClient:= THTTPSend.Create;
    FileName := Trim(StringReplace(Links[i],RemoveStr,'',[]));
    FileName := FormatDateTime('ddmmyyhhmmsszzz',now) + FileName ;
    httpClient.Headers.AddStrings(Header);  // + row !!!!!!!!!!!
    memo1.Lines.Add('Proessing data for '+Links[i]);
    if httpClient.HTTPMethod('GET', Links[i]) then
      httpClient.Document.SaveToFile(FilePath+FileName);
    memo1.Lines.Add('Data saved to '+FilePath+FileName);
    httpClient.Free;
    Application.ProcessMessages;
  end;
  Timer1.Enabled:=True;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  sDate : string;
begin
  FilePath := ExtractFilePath(Application.ExeName)+'\output\';
  sDate:= FormatDateTime('dd-mm-yyyy',now) + '\';
  FilePath:= FilePath + sDate;
  if not DirectoryExists(FilePath) then CreateDir(FilePath);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Timer1.Enabled:=True;
  Application.Minimize;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Button2Click(Self);
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  if WindowState = wsMinimized then
  begin
    WindowState:= wsNormal;
    Show;
  end;
end;

end.

