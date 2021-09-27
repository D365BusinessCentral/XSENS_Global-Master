page 50203 "IT Global Data Distrib. Setup"
{

    ApplicationArea = All;
    Caption = 'GM Global Data Distrib. Setup';
    PageType = List;
    SourceTable = "IT GM Data Distribution Setup";
    UsageCategory = Administration;
    //MultipleNewLines = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field';
                    ApplicationArea = All;
                }
                field("Source Entity"; Rec."Source Entity")
                {
                    ToolTip = 'Specifies the value of the Source Entity field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Destination Entity Type"; Rec."Destination Entity Type")
                {
                    ApplicationArea = All;
                }
                field("Destination Entity"; Rec."Destination Entity")
                {
                    ToolTip = 'Specifies the value of the Destination Entity field';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Source Entity" := CompanyName;
    end;
}
