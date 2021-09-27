page 50222 "IT GM Inbox Handl. Def. Dimen."
{

    Caption = 'IT GM Inbox Handled Default Dimensions';
    PageType = List;
    SourceTable = "IT GM Inbox Handl Def. Dimens.";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ToolTip = 'Specifies the value of the Dimension Code field';
                    ApplicationArea = All;
                }
                field("Dimension Value Code"; Rec."Dimension Value Code")
                {
                    ToolTip = 'Specifies the value of the Dimension Value Code field';
                    ApplicationArea = All;
                }
                field("Value Posting"; Rec."Value Posting")
                {
                    ToolTip = 'Specifies the value of the Value Posting field';
                    ApplicationArea = All;
                }
                field("Allowed Values Filter"; Rec."Allowed Values Filter")
                {
                    ToolTip = 'Specifies the value of the Allowed Values Filter field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
