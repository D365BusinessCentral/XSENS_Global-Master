table 50203 "IT GM Data Distribution Setup"
{
    Caption = 'Global Data Distribution Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table Name"; Enum "IT Data Replication Fn")
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Source Entity"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
            Editable = false;
            trigger OnValidate()
            begin
                if "Destination Entity" = "Source Entity" then
                    Error('Source Entity should not match with Destination Entity');
            end;
        }
        field(3; "Destination Entity Type"; Option)
        {
            OptionMembers = " ","Same Instance","Different Instance";
        }
        field(4; "Destination Entity"; Text[30])
        {
            DataClassification = ToBeClassified;

            TableRelation = Company;//IF ("Destination Entity Type" = CONST("Same Instance")) Company;
            trigger OnValidate()
            begin
                if "Destination Entity" = "Source Entity" then
                    Error('Destination Entity should not match with Source Entity');
            end;
        }

    }
    keys
    {
        key(PK; "Source Entity", "Table Name", "Destination Entity")
        {
            Clustered = true;
        }
    }
}
