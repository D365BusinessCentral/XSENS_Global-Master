pageextension 50204 Items extends "Item List"
{
    actions
    {
        addbefore("Item Journal")
        {
            action("Replicate")
            {
                ApplicationArea = All;
                Image = "Invoicing-Send";
                PromotedCategory=Process;
                Promoted = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ReplicateItems: Report "IT GM Replicate Items";
                    RecItem: Record Item;
                begin
                    Clear(RecItem);
                    CurrPage.SetSelectionFilter(RecItem);
                    if RecItem.FindSet() then begin
                        Clear(ReplicateItems);
                        ReplicateItems.SetTableView(RecItem);
                        ReplicateItems.Run();
                        Rec.Replicated := true;
                        Rec.Modify();
                    end;
                end;
            }
        }
    }
}
