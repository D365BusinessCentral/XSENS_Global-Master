table 50213 "IT GM Outbox Handled Trans."
{
    Caption = 'GM Outbox Handled Trans.';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Source Entity"; Text[30])
        {
            Caption = 'Source Entity';
            DataClassification = ToBeClassified;
        }
        field(3; "Source Type"; Enum "IT Data Replication Fn")
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = " ",Pending,Synced;
        }
        field(7; "Primary Key 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Error Remarks"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        OutboxGL: Record "IT GM Outbox Handled G/L Acc.";
        OutboxItem: Record "IT GM Outbox Handled Items";
        OutboxDefaultDimension: Record "IT GM Outbox Handl. Def. Dimen";
        OutboxDimensionValue: Record "IT GM Outbox Handled Dimension";
    begin
        case Rec."Source Type" of
            Rec."Source Type"::"G/L Account":
                begin
                    Clear(OutboxGL);
                    OutboxGL.SetRange("No.", Rec."Document No.");
                    OutboxGL.SetRange("Outbox Entry No.", Rec."Entry No.");
                    if OutboxGL.FindFirst() then
                        OutboxGL.Delete();
                    Clear(OutboxDefaultDimension);
                    OutboxDefaultDimension.SetRange("Table ID", Database::"G/L Account");
                    OutboxDefaultDimension.SetRange("No.", Rec."Document No.");
                    OutboxDefaultDimension.SetRange("Outbox Entry No.", Rec."Entry No.");
                    if OutboxDefaultDimension.FindSet() then
                        OutboxDefaultDimension.DeleteAll();
                end;

            Rec."Source Type"::Item:
                begin
                    Clear(OutboxItem);
                    OutboxItem.SetRange("No.", Rec."Document No.");
                    OutboxItem.SetRange("Outbox Entry No.", Rec."Entry No.");
                    if OutboxItem.FindFirst() then
                        OutboxItem.Delete();
                    Clear(OutboxDefaultDimension);
                    OutboxDefaultDimension.SetRange("Table ID", Database::Item);
                    OutboxDefaultDimension.SetRange("No.", Rec."Document No.");
                    OutboxDefaultDimension.SetRange("Outbox Entry No.", Rec."Entry No.");
                    if OutboxDefaultDimension.FindSet() then
                        OutboxDefaultDimension.DeleteAll();
                end;
            Rec."Source Type"::"Dimension Value":
                begin
                    Clear(OutboxDimensionValue);
                    OutboxDimensionValue.SetRange(Code, Rec."Document No.");
                    OutboxDimensionValue.SetRange("Dimension Code", Rec."Primary Key 2");
                    OutboxDimensionValue.SetRange("Outbox Entry No.", Rec."Entry No.");
                    if OutboxDimensionValue.FindFirst() then
                        OutboxDimensionValue.Delete();
                end;
        end;
    end;
}
