page 50002 BarcodePicture
{
    PageType = CardPart;
    Caption = 'BarcodePicture';
    SourceTable = Barcode;
    
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Picture;Picture)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
        }
    }
    
}