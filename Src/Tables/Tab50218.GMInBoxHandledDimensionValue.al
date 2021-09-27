table 50218 "IT GM Inbox Handled Dimension"
{
    Caption = 'GM Inbox Handled Dimension Value';
    //LookupPageID = "Dimension Value List";

    fields
    {
        field(1; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
            ValidateTableRelation = false;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "Dimension Value Type"; Option)
        {
            Caption = 'Dimension Value Type';
            OptionCaption = 'Standard,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Standard,Heading,Total,"Begin-Total","End-Total";

        }
        field(5; Totaling; Text[250])
        {
            Caption = 'Totaling';
            TableRelation = IF ("Dimension Value Type" = CONST(Total)) "Dimension Value"."Dimension Code" WHERE("Dimension Code" = FIELD("Dimension Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(7; "Consolidation Code"; Code[20])
        {
            AccessByPermission = TableData "Business Unit" = R;
            Caption = 'Consolidation Code';
        }
        field(8; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(9; "Global Dimension No."; Integer)
        {
            Caption = 'Global Dimension No.';
        }
        field(10; "Map-to IC Dimension Code"; Code[20])
        {
            Caption = 'Map-to IC Dimension Code';
        }
        field(11; "Map-to IC Dimension Value Code"; Code[20])
        {
            Caption = 'Map-to IC Dimension Value Code';
            TableRelation = "IC Dimension Value".Code WHERE("Dimension Code" = FIELD("Map-to IC Dimension Code"));
            ValidateTableRelation = false;
        }
        field(12; "Dimension Value ID"; Integer)
        {
            //AutoIncrement = true;
            Caption = 'Dimension Value ID';
            Editable = false;

        }
        field(8001; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
        }
        field(8002; "Dimension Id"; Guid)
        {
            Caption = 'Dimension Id';
            TableRelation = Dimension.SystemId;
            ValidateTableRelation = false;
        }
        field(50203; "Source Type"; Enum "IT Data Replication Fn")
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
        }
        field(50204; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(50205; "Inbox Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Dimension Code", "Code", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Code", "Global Dimension No.")
        {
        }
        key(Key3; Name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name)
        {
        }
    }
}
