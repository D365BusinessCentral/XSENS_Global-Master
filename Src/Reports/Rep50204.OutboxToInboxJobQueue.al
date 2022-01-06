report 50204 OutboxToInbox_JobQueue
{
    UseRequestPage = false;
    ProcessingOnly = true;
    Caption = 'OutboxToInbox_JobQueue';

    trigger OnPostReport()
    var
        ReplicateData: Codeunit "IT GM Replicate Data";
        RecOutbox: Record "IT GM Outbox Transactions";
    begin
        Clear(RecOutbox);
        RecOutbox.SetFilter("Entry No.", '<>%1', 0);
        if RecOutbox.FindSet() then begin
            // repeat
            ReplicateData.MoveToInbox(RecOutbox);
            // until RecOutbox.Next() = 0;
        end;
    end;
}
