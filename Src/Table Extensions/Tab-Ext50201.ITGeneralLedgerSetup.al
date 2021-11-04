tableextension 50201 ITGeneralLedgerSetup extends "General Ledger Setup"
{
    fields
    {
        field(50200; "G/L Accounts"; Boolean)
        {
            Caption = 'G/L Accounts';
            DataClassification = ToBeClassified;
        }
        field(50201; Dimensions; Boolean)
        {
            Caption = 'Dimensions';
            DataClassification = ToBeClassified;
        }
        field(50202; Items; Boolean)
        {
            Caption = 'Items';
            DataClassification = ToBeClassified;
        }
        field(50203; "G/L Account Fields"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(50204; "Dimension Fields"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(50205; "Item Fields"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
    }
}
