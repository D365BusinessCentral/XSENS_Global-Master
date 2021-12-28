report 50205 InboxToMasters
{
    UseRequestPage = false;
    ProcessingOnly = true;
    Caption = 'InboxToMasters';

    trigger OnPostReport()
    var
        ReplicateData: Codeunit "IT GM InsertFromInbox";
        RecInboxTransaction: Record "IT GM Inbox Transactions";
    begin
        Clear(RecInboxTransaction);
        RecInboxTransaction.SetFilter("Entry No.", '<>%1', 0);
        if RecInboxTransaction.FindSet() then begin
            repeat
                Commit();
                ClearLastError();
                if ReplicateData.Run(RecInboxTransaction) then begin
                    ReplicateData.MoveToHandledInbox(RecInboxTransaction);
                end else begin
                    RecInboxTransaction."Error Remarks" := GetLastErrorText();
                    RecInboxTransaction.Modify();
                end;
            until RecInboxTransaction.Next() = 0;
        end;
    end;
}
