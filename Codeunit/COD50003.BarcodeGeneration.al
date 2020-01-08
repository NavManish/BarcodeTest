codeunit 50003 Barcode
{
    procedure DoGenerateBarcode(var Barcode: Code[100]; BarcodeType: Integer; var tempb: Record TempBlob temporary)
    begin
        Clear(tempb);
        // Empty Barcode Value
        if Barcode = '' then
            exit;
        // Barcode Type Selection
        case BarcodeType of
            0:
                BarcodeTypeValue := 'c39';
            1:
                BarcodeTypeValue := 'c128a';
            2:
                BarcodeTypeValue := 'c128b';
            3:
                BarcodeTypeValue := 'c1218c';
            4:
                BarcodeTypeValue := 'i2of5';
            5:
                BarcodeTypeValue := 'qr';
            else
                Error(Err000);
        end;

        //Generate URL For Request
        InitArguments(Barcode);

        // Webservice Calling
        if not CallWebService() then
           exit;
        //Transefer Call
        tempb := tempblb;
    end;
    local procedure InitArguments(Barcode: Code[100])
    var
        BaseURL: Text;
    begin
        BaseURL := 'http://barcodes4.me';
        if BarcodeTypeValue = 'qr' then
            RequestURL := StrSubstNo('%1/barcode/qr/%2.%3?value=%4&size=%5&ecclevel=%6',
                                        BaseURL,
                                        Barcode,
                                        'png',
                                        Barcode,
                                        1,
                                        0)
        else
            RequestURL := StrSubstNo('%1/barcode/%2/%3.%4',
                                        BaseURL,
                                        BarcodeTypeValue,
                                        Barcode,
                                        'png');
        RequestMethod := RequestMethod::get;
    end;

    local procedure CallWebService() Success: Boolean

    begin
        Success := CallRESTWebService();
    end;

    procedure CallRESTWebService(): Boolean
    var
        Client: HttpClient;
        AuthHeaderValue: HttpHeaders;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        TempBlob: Record TempBlob temporary;
    begin
        RequestMessage.Method := Format(RequestMethod);
        RequestMessage.SetRequestUri(RequestURL);
        RequestMessage.GetHeaders(Headers);
        Client.Send(RequestMessage, ResponseMessage);
        Headers := ResponseMessage.Headers;
        SetResponseHeaders(Headers);
        Content := ResponseMessage.Content;
        SetResponseContent(Content);
        EXIT(ResponseMessage.IsSuccessStatusCode);
    end;
    procedure SetResponseHeaders(var value: HttpHeaders)
    begin
        ResponseHeaders := value;
    end;
    procedure SetResponseContent(var value: HttpContent)
    var
        InStr: InStream;
        OutStr: OutStream;
    begin
        tempblb.Blob.CreateInStream(InStr);
        value.ReadAs(InStr);
        tempblb.Blob.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
    end;

    var
        RequestURL: Text[250];
        RequestMethod: Option get,post,delete,patch,put;
        ResponseHeaders: HttpHeaders;
        tempblb: Record TempBlob temporary;
        BarcodeTypeValue: Text;
        Err000: Label 'Please take integer value between 0 to 5.';

}