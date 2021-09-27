tableextension 50200 "ITCompanyInformationTableExt" extends "Company Information"
{
    fields
    {
        field(50200; "Root Container GM"; Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IT Blob Storage Containers";
        }
        field(50201; "Success Container GM"; Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IT Blob Storage Containers";
        }
        field(50202; "Failed Container GM"; Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "IT Blob Storage Containers";
        }
    }
}
