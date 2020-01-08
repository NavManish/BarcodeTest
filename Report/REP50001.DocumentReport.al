report 50100 DocumentReport
{
    Caption = 'Barcode Document Report';
    RDLCLayout = '.\Report\BarcodeDocumentReport.rdl';
    DefaultLayout = RDLC;
    PreviewMode = Normal;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(CopyLoop; Integer)
        {
            DataItemTableView = sorting (Number);
            dataitem(PageLoop; Integer)
            {
                DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                dataitem("Sales Header"; "Sales Header")
                {
                    RequestFilterFields = "No.";
                    column(Header_No; "No.")
                    {
                    }
                    column(Header_Document_Type; "Document Type")
                    {
                    }
                    column(CompanyInfo; CompanyInfo.Picture)
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompAddr1; CompAddr[1])
                    {
                    }
                    column(CompAddr2; CompAddr[2])
                    {
                    }
                    column(CompAddr3; CompAddr[3])
                    {
                    }
                    column(CompAddr4; CompAddr[4])
                    {
                    }
                    column(CompAddr5; CompAddr[5])
                    {
                    }

                    column(CompAddr6; CompAddr[6])
                    {
                    }

                    column(CompAddr7; CompAddr[7])
                    {
                    }

                    column(CompAddr8; CompAddr[8])
                    {
                    }
                    column(ShipAddr1; ShipAddr[1])
                    {
                    }

                    column(ShipAddr2; ShipAddr[2])
                    {
                    }

                    column(ShipAddr3; ShipAddr[3])
                    {
                    }

                    column(ShipAddr4; ShipAddr[4])
                    {
                    }

                    column(ShipAddr5; ShipAddr[5])
                    {
                    }

                    column(ShipAddr6; ShipAddr[6])
                    {
                    }

                    column(ShipAddr7; ShipAddr[7])
                    {
                    }

                    column(ShipAddr8; ShipAddr[8])
                    {
                    }

                    column(OutputNo; OutputNo)
                    {
                    }

                    column(TempBlob; TempBlob.Blob)
                    {
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemLink = "Document Type" = field ("Document Type"), "Document No." = field ("No.");
                        column(Type; Type)
                        {
                        }
                        column(Document_No_; "Document No.")
                        {
                        }
                        column(Line_No_; "Line No.")
                        {
                        }
                        column(Item_No; "No.")
                        {
                        }
                        column(Description; Description)
                        {
                        }
                        column(Quantity; Quantity)
                        {
                        }
                        column(Amount_Including_VAT; "Amount Including VAT")
                        {
                        }
                    }
                    trigger OnPreDataItem()
                    var
                    begin
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        FormatAddr.GetCompanyAddr("Responsibility Center", ResponsibilityCenter, CompanyInfo, CompAddr);
                        FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");
                        FormatAddr.SalesHeaderShipTo(ShipAddr, CustAddr, "Sales Header");
                        Barcode.DoGenerateBarcode("No.", 5, TempBlob);
                    end;

                    trigger OnPostDataItem()
                    begin
                    end;
                }
            }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                NoOfLoops := ABS(NoOfCopies) + 1;
                CopyText := '';
                SETRANGE(Number, 1, NoOfLoops);
                OutputNo := 1;
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                IF Number > 1 THEN BEGIN
                    CopyText := FormatDocument.GetCOPYText;
                    OutputNo += 1;
                END;
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(NoOfCopies; NoOfCopies)
                    {
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CalcFields(Picture)
    end;

    trigger OnPreReport()
    begin
    end;

    trigger OnPostReport()
    begin
    end;

    var
        CompanyInfo: Record "Company Information";
        TempBlob: Record TempBlob temporary;
        Barcode: Codeunit Barcode;
        FormatAddr: Codeunit "Format Address";
        ResponsibilityCenter: Record "Responsibility Center";
        FormatDocument: Codeunit "Format Document";
        ShipAddr: array[8] of Text;
        CustAddr: array[8] of Text;
        CompAddr: array[8] of Text;
        BilltoLbl: Label 'Bill-to Address';
        ShiptoLbl: Label 'Ship-to Address';
        NoOfLoops: Integer;
        NoOfCopies: Integer;
        CopyText: Text;
        OutputNo: Integer;

}