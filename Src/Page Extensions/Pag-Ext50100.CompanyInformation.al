pageextension 50200 ITCompanyInfoPageExtLT extends "Company Information"
{
    layout
    {
        addlast(content)
        {
            group("Global Master Blob Storage")
            {
                field("Root Container"; Rec."Root Container GM")
                {
                    ApplicationArea = All;
                }
                field("Success Container"; Rec."Success Container GM")
                {
                    ApplicationArea = All;
                }
                field("Failed Container"; Rec."Failed Container GM")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
