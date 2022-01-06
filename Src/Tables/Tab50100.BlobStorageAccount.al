table 50200 "IT Blob Storage Account"
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Account Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(3; "Account Url"; Text[250])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }

        field(4; "SaS Token"; Text[2000])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(5; "Root Container GM"; Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IT Blob Storage Containers";
        }
        field(6; "Success Container GM"; Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IT Blob Storage Containers";
        }
        field(7; "Failed Container GM"; Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IT Blob Storage Containers";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}