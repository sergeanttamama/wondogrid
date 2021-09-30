//개인 그리드 프로젝트
//20210930,원도연,그리드 컴포넌트 작성
unit wondogrid;

interface

uses
  SysUtils, Classes, Controls, Grids;

type
  twondogrid = class(TStringGrid)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function SetColumn(StrColumn : AnsiString) : Boolean;                       //컬럼 셋팅, 각 필드는','로 구분함
    function SetRow(StrRow: AnsiString): Boolean;                               //로우 데이터 셋팅
    function FindRow(Key: AnsiString;KeyColumn : integer): integer;             //키값의 로우값을 리턴
    procedure DeleteRow(ARow: Integer);                                         //로우 데이터 삭제
    function DeleteValRow(ColNo: Integer; DelVal: AnsiString): integer;             //특정 값을 삭제
    function GetValSum(ColNo: Integer; FindVal: AnsiString): integer;               //특정값의 갯수 리턴
    function ValReplace(ColNo: Integer; BaseVal,ReplaceVal: AnsiString): Boolean;   //특정값을 수정값으로 바꿔줌
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [twondogrid]);
end;

{ twondogrid }

function twondogrid.SetColumn(StrColumn: AnsiString): Boolean;//컬럼 셋팅, 각 필드는','로 구분함
var
  tmpstrlist : TStringList;
  i,r : integer;
begin
  try
    result := true;
    self.RowCount  := 0;
    //self.FixedRows := 0;
    tmpstrlist := TStringlist.Create;
    tmpstrlist.Clear;
    tmpstrlist.Delimiter := ',';
    tmpstrlist.DelimitedText := StrColumn;
    Self.ColCount := tmpstrlist.Count;
    for i := 0 to tmpstrlist.Count-1 do
    begin
      Self.Cells[i,0] := tmpstrlist[i];
    end;
  except
    result := False;
  end;
end;

function twondogrid.SetRow(StrRow: AnsiString): Boolean;//로우 데이터 셋팅
var
  tmpstrlist : TStringList;
  i,r : integer;
begin
  try
    result := true;
    i := self.RowCount;
    self.RowCount := self.RowCount + 1;
    tmpstrlist := TStringlist.Create;
    tmpstrlist.Clear;
    tmpstrlist.Delimiter := ',';
    tmpstrlist.DelimitedText := StrRow;
    Self.ColCount := tmpstrlist.Count;
    for r := 1 to self.ColCount do
    begin
      Self.Cells[r-1,i] := tmpstrlist[r-1];
    end;
    if self.rowcount > 1 then
    begin
      self.FixedRows := 1;
    end;
  except
    result := False;
  end;
end;

function twondogrid.FindRow(Key: AnsiString;KeyColumn : integer): integer;//키값의 로우값을 리턴
var
  returnrow : integer;
  i,r : integer;
begin
  try
    for i := 1 to self.RowCount-1 do
    begin
      if self.Cells[KeyColumn,i] = Key then
      begin
        result := i;
      end;
    end;
  except
  end;
end;

procedure twondogrid.DeleteRow(ARow: Integer);//로우 데이터 삭제
var
  i: Integer;
begin
  for i := ARow to Self.RowCount - 2 do
  begin
    Self.Rows[i].Assign(Self.Rows[i + 1]);
  end;
  Self.RowCount := Self.RowCount - 1;
end;

function twondogrid.GetValSum(ColNo : Integer; FindVal : AnsiString) : integer;//특정 값을 삭제
var
  i, r : integer;
begin
  r := 0;
  for i := 0 to Self.rowcount -1 do
  begin
    if Self.cells[ColNo,i] = FindVal then
    begin
      r := r + 1;
    end;
  end;
  Result := r;
end;



function twondogrid.DeleteValRow(ColNo : Integer; DelVal : AnsiString) : integer;//특정값의 갯수 리턴
var
  i, r : integer;
begin
  r := 0;
  for i := 0 to Self.rowcount -1 do
  begin
    if Self.cells[ColNo,i] = DelVal then
    begin
      DeleteRow(i);
    end;
  end;
  Result := r;
end;



function twondogrid.ValReplace(ColNo : Integer; BaseVal, ReplaceVal : AnsiString) : Boolean;//특정값을 수정값으로 바꿔줌
var
  i, r : integer;
begin
  result := True;
  try
    for i := 0 to Self.rowcount -1 do
    begin
      if Self.cells[ColNo,i] = BaseVal then
      begin
        Self.cells[ColNo,i] := ReplaceVal;
      end;
    end;
  except
    result := False;
  end;
end;

end.
