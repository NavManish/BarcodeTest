table 50001 RESTWebServiceArguments
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; PrimaryKey; Integer) { }
        field(2; RestMethod; Option)
        {
            OptionMembers = get,post,delete,patch,put;
        }
        field(3; URL; Text[250]) { }
        field(4; Accept; Text[30]) { }
        field(5; ETag; Text[250]) { }
        field(6; UserName; text[50]) { }
        field(7; Password; text[50]) { }
        field(100; BlobField; Blob) { }
    }
    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    var
        RequestContent: HttpContent;
        RequestContentSet: Boolean;
        ResponseHeaders: HttpHeaders;
    procedure SetRequestContent(var value: HttpContent)
    begin
        RequestContent := value;
        RequestContentSet := true;
    end;
    procedure HasRequestContent(): Boolean
    begin
        exit(RequestContentSet);
    end;
    procedure GetRequestContent(var value: HttpContent)
    begin
        value := RequestContent;
    end;
    procedure SetResponseContent(var value: HttpContent)
    var
        InStr: InStream;
        OutStr: OutStream;
    begin
        BlobField.CreateInStream(InStr);
        value.ReadAs(InStr);

        BlobField.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
    end;
    procedure HasResponseContent(): Boolean
    begin
        exit(BlobField.HasValue);
    end;
    procedure GetResponseContent(var value: HttpContent)
    var
        Instr: InStream;
    begin
        BlobField.CreateInStream(Instr);
        value.Clear();
        value.WriteFrom(Instr);
    end;
    procedure GetResponseContentAsText() ReturnValue: Text
    var
        InStr: InStream;
        Line: text;
    begin
        if not HasResponseContent() then
            exit;

        BlobField.CreateInStream(InStr);
        InStr.ReadText(ReturnValue);

        while not InStr.EOS do begin
            InStr.ReadText(Line);
            ReturnValue += Line;
        end;
    end;
    procedure SetResponseHeader(var value: HttpHeaders)
    begin
        ResponseHeaders := value;
    end;
    procedure GetResponseHeader(var value: HttpHeaders)
    begin
        value := ResponseHeaders;
    end;
    
    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}