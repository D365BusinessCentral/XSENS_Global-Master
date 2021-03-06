pageextension 50202 ITDimensionValues extends "Dimension Values"
{
    layout
    {
        addafter("Dimension Value Type")
        {
            field(Global; Rec.Global)
            {
                ApplicationArea = All;
            }
            field(Replicated; Rec.Replicated)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addbefore("Indent Dimension Values")
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
                    ReplicateDimensions: Report "IT GM Replicate Dimensions";
                    RecDimensionValue: Record "Dimension Value";
                begin
                    Clear(RecDimensionValue);
                    CurrPage.SetSelectionFilter(RecDimensionValue);
                    if RecDimensionValue.FindSet() then begin
                        ValidateDimension(RecDimensionValue);
                        Clear(ReplicateDimensions);
                        ReplicateDimensions.SetTableView(RecDimensionValue);
                        ReplicateDimensions.Run();
                        RecDimensionValue.ModifyAll(Replicated, true);
                    end;
                end;
            }
        }
    }

    local procedure ValidateDimension(var RecDimvalue: Record "Dimension Value")
    begin
        if RecDimvalue.FindSet() then begin
            repeat
                RecDimvalue.TestField(Global, true);
            until RecDimvalue.Next() = 0;
        end
    end;
}
