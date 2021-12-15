pageextension 50201 ITGeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        addlast(content)
        {
            group("Global Master Replication")
            {
                field("G/L Accounts"; Rec."G/L Accounts")
                {
                    ApplicationArea = All;
                }
                field(Dimensions; Rec.Dimensions)
                {
                    ApplicationArea = All;
                }
                field(Items; Rec.Items)
                {
                    ApplicationArea = All;
                }
                field("G/L Account Fields"; Rec."G/L Account Fields")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        RecFieldList: Record Field;
                        PageFieldList: Page "Field List";
                        TextBuilder: TextBuilder;
                        List: List of [Integer];
                    begin
                        TextBuilder.Clear();
                        Clear(RecFieldList);
                        RecFieldList.SetRange(TableNo, Database::"G/L Account");
                        RecFieldList.SetFilter("No.", '<%1', 2000000000);
                        PageFieldList.SetTableView(RecFieldList);
                        PageFieldList.SetRecord(RecFieldList);
                        PageFieldList.LookupMode(true);
                        IF PageFieldList.RunModal() = Action::LookupOK then begin
                            PageFieldList.SetSelectionFilter(RecFieldList);
                            if RecFieldList.FindSet() then begin
                                repeat
                                    TextBuilder.Append(FORMAT(RecFieldList."No.") + ',');
                                until RecFieldList.Next() = 0;
                                if TextBuilder.Length <= 1000 then
                                    Rec."G/L Account Fields" := CopyStr(TextBuilder.ToText(), 1, TextBuilder.Length - 1)
                                else
                                    Rec."G/L Account Fields" := 'length Exceeded';
                            end
                        end
                    end;
                }
                field("Dimension Fields"; Rec."Dimension Fields")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        RecFieldList: Record Field;
                        PageFieldList: Page "Field List";
                        TextBuilder: TextBuilder;
                        List: List of [Integer];
                    begin
                        TextBuilder.Clear();
                        Clear(RecFieldList);
                        RecFieldList.SetRange(TableNo, Database::"Dimension Value");
                        RecFieldList.SetFilter("No.", '<%1', 2000000000);
                        PageFieldList.SetTableView(RecFieldList);
                        PageFieldList.SetRecord(RecFieldList);
                        PageFieldList.LookupMode(true);
                        IF PageFieldList.RunModal() = Action::LookupOK then begin
                            PageFieldList.SetSelectionFilter(RecFieldList);
                            if RecFieldList.FindSet() then begin
                                repeat
                                    TextBuilder.Append(FORMAT(RecFieldList."No.") + ',');
                                until RecFieldList.Next() = 0;
                                if TextBuilder.Length <= 500 then
                                    Rec."Dimension Fields" := CopyStr(TextBuilder.ToText(), 1, TextBuilder.Length - 1)
                                else
                                    Rec."Dimension Fields" := 'length Exceeded';
                            end
                        end
                    end;
                }
                field("Item Fields"; Rec."Item Fields")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        RecFieldList: Record Field;
                        PageFieldList: Page "Field List";
                        TextBuilder: TextBuilder;
                        List: List of [Integer];
                    begin
                        TextBuilder.Clear();
                        Clear(RecFieldList);
                        RecFieldList.SetRange(TableNo, Database::Item);
                        RecFieldList.SetFilter("No.", '<%1', 2000000000);
                        PageFieldList.SetTableView(RecFieldList);
                        PageFieldList.SetRecord(RecFieldList);
                        PageFieldList.LookupMode(true);
                        IF PageFieldList.RunModal() = Action::LookupOK then begin
                            PageFieldList.SetSelectionFilter(RecFieldList);
                            if RecFieldList.FindSet() then begin
                                repeat
                                    TextBuilder.Append(FORMAT(RecFieldList."No.") + ',');
                                until RecFieldList.Next() = 0;
                                if TextBuilder.Length <= 2000 then
                                    Rec."Item Fields" := CopyStr(TextBuilder.ToText(), 1, TextBuilder.Length - 1)
                                else
                                    Rec."Item Fields" := 'length Exceeded';
                            end
                        end
                    end;
                }
            }
        }
    }
}
