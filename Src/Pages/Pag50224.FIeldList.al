page 50224 "Field List"
{

    Caption = 'Field List';
    PageType = List;
    SourceTable = field;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = All;
                }
                field("Type Name"; Rec."Type Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
