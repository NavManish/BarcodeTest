page 50001 BarcodeCard
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Barcode;
    Caption = 'Barcode Card';
    DataCaptionExpression = Value;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Value; Value)
                {
                    ApplicationArea = All;

                }
                field(Type; Type)
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();

                    end;
                }
                field(PictureType; PictureType)
                { }
            }
            group(Options)
            {
                Caption = 'Options';
                group(Barcode)
                {
                    Visible = Type <> Type::QR;
                    field(Width; Width) { }
                    field(Height; Height) { }
                    field(IncludeText; IncludeText) { }
                    field(Border; Border) { }
                    field(ReverseColors; ReverseColors) { }
                }
                group(QRCode)
                {
                    Visible = Type = Type::QR;
                    field(ECCLevel; ECCLevel) { }
                    field(Size; Size) { }
                }
            }
        }
        area(FactBoxes)
        {
            part(BarcodePicture; BarcodePicture)
            {
                SubPageLink = PrimaryKey = field(PrimaryKey);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateBarcode)
            {
                CaptionML = ENU = 'Generate Barcode';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction();
                begin
                    GenerateBarcode;
                end;
            }
        }
    }
}