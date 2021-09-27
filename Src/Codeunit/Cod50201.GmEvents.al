codeunit 50201 "GM Events"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyEventGLAccount(var Rec: Record "G/L Account"; var xRec: Record "G/L Account"; RunTrigger: Boolean)
    begin
        Rec.Replicated := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEventGLAccount(var Rec: Record "G/L Account"; RunTrigger: Boolean)
    begin
        Rec.Replicated := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyEventItem(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    begin
        Rec.Replicated := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEventItem(var Rec: Record Item; RunTrigger: Boolean)
    begin
        Rec.Replicated := false;
    end;
}
