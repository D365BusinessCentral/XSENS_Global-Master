report 50201 "IT GM Replicate Items"
{
    Caption = 'IT GM Replicate Items';
    UseRequestPage = false;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") order(ascending) where(Replicated = const(false));

            trigger OnAfterGetRecord()
            var
                ReplicateData: Codeunit "IT GM Replicate Data";
            begin
                Clear(ReplicateData);
                ReplicateData.SetData(Item, Enum::"IT Data Replication Fn"::Item);
                ReplicateData.Run();
            end;
        }
    }
}
