pageextension 50201 ITGeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        addlast(content)
        {
            group("Global Master Relication")
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
            }
        }
    }
}
