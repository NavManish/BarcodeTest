codeunit 50001 RESTWebServiceCode
{
    trigger OnRun()
    begin

    end;

    procedure CallRESTWebService(var Parameters: Record RESTWebServiceArguments): Boolean
    var

        Client: HttpClient;
        AuthHeaderValue: HttpHeaders;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        AuthText: text;
        TempBlob: Codeunit "Temp Blob";
        OutStr : OutStream;
        Base64 : Codeunit "Base64 Convert";
    begin
        RequestMessage.Method := Format(Parameters.RestMethod);
        RequestMessage.SetRequestUri(Parameters.URL);

        RequestMessage.GetHeaders(Headers);

        If Parameters.Accept <> '' then 
          Headers.Add('Accept',Parameters.Accept);

        If Parameters.UserName <> '' then begin 
            AuthText := StrSubstNo('%1:%2',Parameters.UserName,Parameters.Password);
            TempBlob.CreateOutStream(OutStr,TextEncoding::Windows); 
            OutStr.WriteText(AuthText);
            Headers.Add('Authorization',StrSubstNo('Basic %1',Base64.ToBase64(AuthText)));
        end;

        if Parameters.ETag <> '' then
          Headers.Add('If-Match',Parameters.ETag);

        if Parameters.HasRequestContent() then begin
            Parameters.GetRequestContent(Content);
            RequestMessage.Content := Content;
         end;

         Client.Send(RequestMessage,ResponseMessage);

         Headers := ResponseMessage.Headers;
         Parameters.SetResponseHeader(Headers);

         Content := ResponseMessage.Content;
         Parameters.SetResponseContent(Content);

         Exit(ResponseMessage.IsSuccessStatusCode);

    end;
}