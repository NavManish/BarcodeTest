report 50000 BarcodeList
{
    Caption = 'Barcode List Report';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Report\BarcodeList.rdl';
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            column(No_; "No.")
            {  }
            column(temp; temp.Blob)
            {}

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Barcode.DoGenerateBarcode("Sales Header"."No.", 5, temp);
            end;
        }
    }

    var
        temp: Record TempBlob temporary;
        Barcode: Codeunit Barcode;
}

