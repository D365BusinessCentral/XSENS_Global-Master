report 50202 "IT GM Replicate Dimensions"
{
    Caption = 'IT GM Replicate Dimensions';
    UseRequestPage = false;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Dimensions; "Dimension Value")
        {
            DataItemTableView = sorting(Code) order(ascending) where(Replicated = const(false), Global = const(true));

            trigger OnAfterGetRecord()
            var
                ReplicateData: Codeunit "IT GM Replicate Data";
            begin
                Clear(ReplicateData);
                ReplicateData.SetData(Dimensions, Enum::"IT Data Replication Fn"::"Dimension Value");
                ReplicateData.Run();
            end;
        }
    }
}
