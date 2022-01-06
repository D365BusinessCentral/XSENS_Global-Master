page 50200 "IT Azure Blob Storage Setup"
{
    PageType = Card;
    SourceTable = "IT Blob Storage Account";
    Caption = 'GM Azure Blob Storage Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Account Url"; Rec."Account Url")
                {
                    ApplicationArea = All;
                }
                field("SaS Token"; Rec."SaS Token")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
            group(Containers)
            {
                field("Root Container"; Rec."Root Container GM")
                {
                    ApplicationArea = All;
                }
                field("Success Container"; Rec."Success Container GM")
                {
                    ApplicationArea = All;
                }
                field("Failed Container"; Rec."Failed Container GM")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;

}
