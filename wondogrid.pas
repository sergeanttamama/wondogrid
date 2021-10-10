//���� �׸��� ������Ʈ
//20210930,������,�׸��� ������Ʈ �ۼ�
//20211004,������,QueryToGrid �Լ� �߰�
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
    function SetColumn(StrColumn : AnsiString) : Boolean;                           //�÷� ����, �� �ʵ��','�� ������
    function SetRow(StrRow: AnsiString): Boolean;                                   //�ο� ������ ����
    function FindRow(Key: AnsiString;KeyColumn : integer): integer;                 //Ű���� �ο찪�� ����
    procedure DeleteRow(ARow: Integer);                                             //�ο� ������ ����
    function DeleteValRow(ColNo: Integer; DelVal: AnsiString): integer;             //Ư�� ���� ����
    function GetValSum(ColNo: Integer; FindVal: AnsiString): integer;               //Ư������ ���� ����
    function ValReplace(ColNo: Integer; BaseVal,ReplaceVal: AnsiString): Boolean;   //Ư������ ���������� �ٲ���
    function QueryToGrid(Query: TQuery): Boolean;                                   //Query ������Ʈ�� �޾�, �ش� �ʵ�� �ο츦 �ڵ����� ���� �ϴ� �Լ�
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;AState: TGridDrawState); override;  //dracell ������
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [twondogrid]);
end;

//�÷� ���� �Լ�, �� �ʵ��','�� ������, StrColumn : �÷����� �̸��� ��� ���ڿ��� �����Ե�.
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

//�ο� ������ ���� �Լ�,  StrRow���ڿ� ���� ���� �ο� �����͸� �޾ƿ��� ��, ',' ���ڷ� ����
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

//Ű���� �ο찪�� �����ϴ� �Լ�, Key ���ڿ� ã�� ����, KeyColumn�� Ű �÷��� ����
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

//�ο� ������ ���� �Լ�, ARow ���ڿ� ���� row�� �����Ѵ�
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

//Ư������ ������ �����ϴ� �Լ�, ã���� �� �÷��� ColNo�� �ް�,
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

//Ư�� ���� �����ϴ� �Լ�, ColNo ���ڿ� �÷�����, FindVal ���ڿ� ã�� ���ڿ��� �Է�
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

//Ư������ ���������� �ٲ��ִ� �Լ�, ColNo�� �ٲ� ���� ã�� �÷�, BaseVal�� �ٲܴ�� �Ǵ� ���ڿ�, Replaceval�� �ٲ� ���ڿ��� �ް� ��
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

//Query ������Ʈ�� �޾�, �ش� �ʵ�� �ο츦 �ڵ����� ���� �ϴ� �Լ�
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
  // Title�� �߾ӿ� ����
  if ARow = 0 then
  begin
    iX := (Rect.Left + Rect.Right) div 2;
    SetTextAlign(sg.Canvas.Handle, TA_CENTER );
    sg.Canvas.TextRect(Rect, iX, iY, sg.Cells[Acol,Arow]);
    Exit; //�÷��� ���� �ο��� ��� �׳� ���� �������� ����, �÷��� SetColumn() �Լ��� ����
  end;

  Inherited DrawCell(ACol, ARow, ARect, AState);
End;

end.
