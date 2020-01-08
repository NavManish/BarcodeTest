codeunit 50000 GenerateBarCode
{
    trigger OnRun()
    begin

    end;

    procedure GenerateBarcode(var Barcode: Record Barcode)
    begin
        DoGenerateBarcode(Barcode);
    end;

    local procedure DoGenerateBarCode(var Barcode: Record Barcode)
    var
        Arguments: Record RESTWebServiceArguments temporary;
    begin
        if Barcode.Type = Barcode.Type::" " then begin
            Clear(Barcode.Picture);
            Exit;
        end;

        InitArguments(Arguments, Barcode);
        if not CallWebService(Arguments) then
            exit;

        SaveResult(Arguments, Barcode);
    end;

    local procedure InitArguments(var Argument: Record RESTWebServiceArguments temporary; Barcode: Record Barcode)
    var
        BaseURL: Text;
        TypeHelper: Codeunit "Type Helper";
    begin
        BaseURL := 'http://barcodes4.me';

        if Barcode.Type = Barcode.Type::qr then
            Argument.URL := StrSubstNo('%1/barcode/qr/%2.%3?value=%4&size=%5&ecclevel=%6',
                                        BaseURL,
                                        TypeHelper.UrlEncode(Barcode.Value),
                                        GetOptionStringValue(Barcode.PictureType, Barcode.FieldNo(PictureType)),
                                        TypeHelper.UrlEncode(Barcode.Value),
                                        GetOptionStringValue(Barcode.Size, Barcode.FieldNo(size)),
                                        GetOptionStringValue(Barcode.ECCLevel, Barcode.FieldNo(ECCLevel))
            )
        else
            Argument.URL := StrSubstNo('%1/barcode/%2/%3.%4?istextdrawn=%5&isborderdrawn=%6&isreversecolor=%7',
                                       BaseURL,
                                       GetOptionStringValue(Barcode.Type, Barcode.FieldNo(Type)),
                                       TypeHelper.UrlEncode(Barcode.Value),
                                       GetOptionStringValue(Barcode.PictureType, Barcode.FieldNo(PictureType)),
                                       Format(Barcode.IncludeText, 0, 2),
                                       Format(Barcode.ReverseColors, 0, 2)
            );

        Argument.RestMethod := Argument.RestMethod::get;
    end;

    local procedure CallWebService(var Argument: Record RESTWebServiceArguments temporary) Success: Boolean
    var
        RESTWebService: codeunit RESTWebServiceCode;
    begin
        Success := RESTWebService.CallRESTWebService(Argument);
    end;

    local procedure SaveResult(var Arguments: Record RESTWebServiceArguments temporary; var Barcode: Record Barcode)
    var
        ResponseContent: HttpContent;
        InStr: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        Arguments.GetResponseContent(ResponseContent);
        TempBlob.CreateInStream(InStr);
        ResponseContent.ReadAs(InStr);
        Clear(Barcode.Picture);
        Barcode.Picture.ImportStream(InStr, Barcode.Value);
    end;

    local procedure GetOptionStringValue(Value: Integer; fieldNo: Integer): Text
    var
        FieldRec: Record Field;
    begin
        FieldRec.Get(Database::Barcode, fieldNo);
        exit(SelectStr(Value + 1, FieldRec.OptionString))
    end;

    var
        myInt: Integer;
}