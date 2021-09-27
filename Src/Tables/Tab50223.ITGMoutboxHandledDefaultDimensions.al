table 50223 "IT GM Outbox Handl. Def. Dimen"
{
    Caption = 'IT GM Outbox Handled Default Dimensions';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(4; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"),
                                                         Blocked = CONST(false));
        }
        field(5; "Value Posting"; Enum "Default Dimension Value Posting Type")
        {
            Caption = 'Value Posting';
        }
        field(6; "Table Caption"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Table ID")));
            Caption = 'Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Multi Selection Action"; Option)
        {
            Caption = 'Multi Selection Action';
            OptionCaption = ' ,Change,Delete';
            OptionMembers = " ",Change,Delete;
        }
        field(8; "Parent Type"; Enum "Default Dimension Parent Type")
        {
            Caption = 'Parent Type';
        }
        field(10; "Allowed Values Filter"; Text[250])
        {
            Caption = 'Allowed Values Filter';
        }
        field(8000; ParentId; Guid)
        {
            Caption = 'ParentId';
            DataClassification = SystemMetadata;
            TableRelation = IF ("Table ID" = CONST(15)) "G/L Account".SystemId
            ELSE
            IF ("Table ID" = CONST(18)) Customer.SystemId
            ELSE
            IF ("Table ID" = CONST(23)) Vendor.SystemId
            ELSE
            IF ("Table ID" = CONST(5200)) Employee.SystemId;
        }
        field(8001; DimensionId; Guid)
        {
            Caption = 'DimensionId';
            DataClassification = SystemMetadata;
            TableRelation = Dimension.SystemId;
        }
        field(8002; DimensionValueId; Guid)
        {
            Caption = 'DimensionValueId';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".SystemId;
        }
        field(50201; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(50202; "Outbox Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Table ID", "No.", "Dimension Code", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Dimension Code")
        {
        }
    }

    fieldgroups
    {
    }
}
