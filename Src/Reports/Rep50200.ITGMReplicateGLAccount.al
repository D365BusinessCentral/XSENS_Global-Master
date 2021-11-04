report 50200 "IT GM Replicate GL Account"
{
    Caption = 'IT GM Replicate GL Account';
    UseRequestPage = false;
    ProcessingOnly = true;

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.") order(ascending) where(Replicated = const(false));

            trigger OnAfterGetRecord()
            var
                ReplicateData: Codeunit "IT GM Replicate Data";
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.GET;
                GLSetup.TestField("G/L Accounts", true);
                GLSetup.TestField("G/L Account Fields");
                Clear(ReplicateData);
                ReplicateData.SetData(GLAccount, Enum::"IT Data Replication Fn"::"G/L Account");
                ReplicateData.Run();
            end;
        }
    }
}
