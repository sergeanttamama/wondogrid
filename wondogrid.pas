//개인 그리드 프로젝트
//20210930,원도연,그리드 컴포넌트 작성
//20211004,원도연,QueryToGrid 함수 추가
unit wondogrid;

interface

uses
  SysUtils, Classes, Controls, Grids, DBTables;

type
  twondogrid = class(TStringGrid)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function SetColumn(StrColumn : AnsiString) : Boolean;                           //컬럼 셋팅, 각 필드는','로 구분함
    function SetRow(StrRow: AnsiString): Boolean;                                   //로우 데이터 셋팅
    function FindRow(Key: AnsiString;KeyColumn : integer): integer;                 //키값의 로우값을 리턴
    procedure DeleteRow(ARow: Integer);                                             //로우 데이터 삭제
    function DeleteValRow(ColNo: Integer; DelVal: AnsiString): integer;             //특정 값을 삭제
    function GetValSum(ColNo: Integer; FindVal: AnsiString): integer;               //특정값의 갯수 리턴
    function ValReplace(ColNo: Integer; BaseVal,ReplaceVal: AnsiString): Boolean;   //특정값을 수정값으로 바꿔줌
    function QueryToGrid(Query: TQuery): Boolean;                                   //Query 컴포넌트를 받아, 해당 필드와 로우를 자동으로 셋팅 하는 함수
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;AState: TGridDrawState); override;  //dracell 재정의
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [twondogrid]);
end;

//컬럼 셋팅 함수, 각 필드는','로 구분함, StrColumn : 컬럼들의 이름이 담긴 문자열이 들어오게됨.
function twondogrid.SetColumn(StrColumn: AnsiString): Boolean;
var
  tmpstrlist : TStringList;
  i,r : integer;
begin
  try
    try
      result := true;
      self.RowCount  := 0;
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
  finally
    tmpstrlist.Free;
  end;
end;

//로우 데이터 셋팅 함수,  StrRow인자에 현재 행의 로우 데이터를 받아오게 됨, ',' 문자로 구분
function twondogrid.SetRow(StrRow: AnsiString): Boolean;
var
  tmpstrlist : TStringList;
  i,r : integer;
begin
  try
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
  finally
    tmpstrlist.free;
  end;
end;

//키값의 로우값을 리턴하는 함수, Key 인자에 찾을 값을, KeyColumn에 키 컬럼을 넣음
function twondogrid.FindRow(Key: AnsiString;KeyColumn : integer): integer;
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

//로우 데이터 삭제 함수, ARow 인자에 받은 row를 삭제한다
procedure twondogrid.DeleteRow(ARow: Integer);
var
  i: Integer;
begin
  for i := ARow to Self.RowCount - 2 do
  begin
    Self.Rows[i].Assign(Self.Rows[i + 1]);
  end;
  Self.RowCount := Self.RowCount - 1;
end;

//특정값의 갯수를 리턴하는 함수, 찾고자 할 컬럼을 ColNo로 받고,
function twondogrid.GetValSum(ColNo : Integer; FindVal : AnsiString) : integer;
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

//특정 값을 삭제하는 함수, ColNo 인자에 컬럼값을, FindVal 인자에 찾을 문자열을 입력
function twondogrid.DeleteValRow(ColNo : Integer; DelVal : AnsiString) : integer;
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

//특정값을 수정값으로 바꿔주는 함수, ColNo에 바꿀 값을 찾는 컬럼, BaseVal에 바꿀대상에 되는 문자열, Replaceval에 바꿀 문자열을 받게 됨
function twondogrid.ValReplace(ColNo : Integer; BaseVal, ReplaceVal : AnsiString) : Boolean;
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

//Query 컴포넌트를 받아, 해당 필드와 로우를 자동으로 셋팅 하는 함수
function twondogrid.QueryToGrid(Query : TQuery) : Boolean;
var
  i, r : integer;
  FieldCount  : Integer;
  RecordCount : Integer;
begin
  FieldCount  := Query.FieldCount;
  RecordCount := Query.RecordCount;
  for i := 0 to FieldCount-1 do
  begin
    for r := 0 to RecordCount-1 do
    begin

    end;
  end;
end;

procedure twondogrid.DrawCell(ACol, ARow: Longint; ARect: TRect;AState: TGridDrawState);
var
 iX, iY : Integer;
begin
  iY := Rect.Top + 4;
  // Title은 중앙에 정렬
  if ARow = 0 then
  begin
    iX := (Rect.Left + Rect.Right) div 2;
    SetTextAlign(sg.Canvas.Handle, TA_CENTER );
    sg.Canvas.TextRect(Rect, iX, iY, sg.Cells[Acol,Arow]);
    Exit; //컬럼이 들어가는 로우의 경우 그냥 빠져 나가도록 수정, 컬럼은 SetColumn() 함수로 셋팅
  end;

  Inherited DrawCell(ACol, ARow, ARect, AState);
End;

end.
