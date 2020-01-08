codeunit 50002 JsonMethods
{
    trigger OnRun()
    begin

    end;

    procedure GetJsonvalueAsText(var JsonObject: JsonObject; Property: Text) Value: Text
    var
        JsonValue: JsonValue;
    begin
        if not GetJsonValue(JsonObject, Property, JsonValue) then
            exit;
        value := JsonValue.AsText();
    end;

    procedure GetJsonValue(var JsonObject: JsonObject; Property: Text; var JsonValue: JsonValue): Boolean
    var
        JsonToken: JsonToken;
    begin
        If not JsonObject.Get(Property, JsonToken) then
            exit;

        JsonValue := JsonToken.AsValue();

    end;

    var
        myInt: Integer;
}