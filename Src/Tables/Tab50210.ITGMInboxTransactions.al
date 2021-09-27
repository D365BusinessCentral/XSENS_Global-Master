table 50210 "IT GM Inbox Transactions"
{
    Caption = 'GM Inbox Transactions';
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
        InboxGL: Record "IT GM Inbox G/L Account";
        InboxItem: Record "IT GM Inbox Items";
        InboxDefaultDimension: Record "IT GM Inbox Default Dimensions";
        InboxDimensionValue: Record "IT GM Inbox Dimension Value";
    begin
        case Rec."Source Type" of
            Rec."Source Type"::"G/L Account":
                begin
                    Clear(InboxGL);
                    InboxGL.SetRange("No.", Rec."Document No.");
                    InboxGL.SetRange("Inbox Entry No.", Rec."Entry No.");
                    if InboxGL.FindFirst() then
                        InboxGL.Delete();
                    Clear(InboxDefaultDimension);
                    InboxDefaultDimension.SetRange("Table ID", Database::"G/L Account");
                    InboxDefaultDimension.SetRange("No.", Rec."Document No.");
                    InboxDefaultDimension.SetRange("Inbox Entry No.", Rec."Entry No.");
                    if InboxDefaultDimension.FindSet() then
                        InboxDefaultDimension.DeleteAll();
                end;

            Rec."Source Type"::Item:
                begin
                    Clear(InboxItem);
                    InboxItem.SetRange("No.", Rec."Document No.");
                    InboxItem.SetRange("Inbox Entry No.", Rec."Entry No.");
                    if InboxItem.FindFirst() then
                        InboxItem.Delete();
                    Clear(InboxDefaultDimension);
                    InboxDefaultDimension.SetRange("Table ID", Database::Item);
                    InboxDefaultDimension.SetRange("No.", Rec."Document No.");
                    InboxDefaultDimension.SetRange("Inbox Entry No.", Rec."Entry No.");
                    if InboxDefaultDimension.FindSet() then
                        InboxDefaultDimension.DeleteAll();
                end;
            Rec."Source Type"::"Dimension Value":
                begin
                    Clear(InboxDimensionValue);
                    InboxDimensionValue.SetRange(Code, Rec."Document No.");
                    InboxDimensionValue.SetRange("Dimension Code", Rec."Primary Key 2");
                    InboxDimensionValue.SetRange("Inbox Entry No.", Rec."Entry No.");
                    if InboxDimensionValue.FindFirst() then
                        InboxDimensionValue.Delete();
                end;
        end;
    end;
}
