pageextension 50203 "IT GM G/L Account" extends "Chart of Accounts"
{
    actions
    {
        addbefore(IndentChartOfAccounts)
        {
            action("Replicate")
            {
                ApplicationArea = All;
                Image = "Invoicing-Send";
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ReplicateGl: Report "IT GM Replicate GL Account";
                    RecGL: Record "G/L Account";
                begin
                    Clear(RecGL);
                    CurrPage.SetSelectionFilter(RecGL);
                    if RecGL.FindSet() then begin
                        Clear(ReplicateGl);
                        ReplicateGl.SetTableView(RecGL);
                        ReplicateGl.Run();
                        Rec.Replicated := true;
                        Rec.Modify();
                    end;
                end;
            }
        }
    }
}
