codeunit 50203 "IT GM InsertFromInbox"
{
    TableNo = "IT GM Inbox Transactions";

    trigger OnRun()
    var
        DefaultDimensionInbox: Record "IT GM Inbox Default Dimensions";
        DefaultDimensions: Record "Default Dimension";
    begin
        case Rec."Source Type" of
            Rec."Source Type"::"G/L Account":
                begin
                    Clear(RecGLInbox);
                    RecGLInbox.SetRange("No.", Rec."Document No.");
                    RecGLInbox.SetRange("Inbox Entry No.", Rec."Entry No.");
                    RecGLInbox.FindFirst();
                    Clear(RecGlAccount);
                    RecGlAccount.SetRange("No.", RecGLInbox."No.");
                    if not RecGlAccount.FindFirst() then begin
                        RecGlAccount.Init();
                        RecGlAccount.TransferFields(RecGLInbox);
                        RecGlAccount.Insert(true);
                    end else begin
                        RecGlAccount.TransferFields(RecGLInbox);
                        RecGlAccount.Modify(true);
                    end;
                    Clear(DefaultDimensions);
                    DefaultDimensions.SetRange("Table ID", Database::"G/L Account");
                    DefaultDimensions.SetRange("No.", RecGLInbox."No.");
                    if DefaultDimensions.FindSet() then
                        DefaultDimensions.DeleteAll(true);
                    Clear(DefaultDimensionInbox);
                    DefaultDimensionInbox.SetRange("Table ID", Database::"G/L Account");
                    DefaultDimensionInbox.SetRange("No.", RecGLInbox."No.");
                    DefaultDimensionInbox.SetRange("Inbox Entry No.", Rec."Entry No.");
                    if DefaultDimensionInbox.FindSet() then begin
                        repeat
                            Clear(DefaultDimensions);
                            DefaultDimensions.Init();
                            DefaultDimensions.TransferFields(DefaultDimensionInbox);
                            DefaultDimensions.Insert();
                        until DefaultDimensionInbox.Next() = 0;
                    end;
                    RecGlAccount.Validate("Global Dimension 1 Code", RecGLInbox."Global Dimension 1 Code");
                    RecGlAccount.Validate("Global Dimension 2 Code", RecGLInbox."Global Dimension 2 Code");
                    RecGlAccount.Modify();
                end;

            Rec."Source Type"::Item:
                begin
                    Clear(RecItemInbox);
                    RecItemInbox.SetRange("No.", Rec."Document No.");
                    RecItemInbox.SetRange("Inbox Entry No.", Rec."Entry No.");
                    RecItemInbox.FindFirst();
                    Clear(RecItem);
                    RecItem.SetRange("No.", RecItemInbox."No.");
                    if not RecItem.FindFirst() then begin
                        RecItem.Init();
                        RecItem.TransferFields(RecItemInbox);
                        RecItem.Insert(true);
                    end else begin
                        RecItem.TransferFields(RecItemInbox);
                        RecItem.Modify(true);
                    end;
                    Clear(DefaultDimensions);
                    DefaultDimensions.SetRange("Table ID", Database::Item);
                    DefaultDimensions.SetRange("No.", RecItemInbox."No.");
                    if DefaultDimensions.FindSet() then
                        DefaultDimensions.DeleteAll(true);
                    Clear(DefaultDimensionInbox);
                    DefaultDimensionInbox.SetRange("Table ID", Database::Item);
                    DefaultDimensionInbox.SetRange("No.", RecItemInbox."No.");
                    DefaultDimensionInbox.SetRange("Inbox Entry No.", Rec."Entry No.");
                    if DefaultDimensionInbox.FindSet() then begin
                        repeat
                            Clear(DefaultDimensions);
                            DefaultDimensions.Init();
                            DefaultDimensions.TransferFields(DefaultDimensionInbox);
                            DefaultDimensions.Insert();
                        until DefaultDimensionInbox.Next() = 0;
                    end;
                    RecItem.Validate("Global Dimension 1 Code", RecItemInbox."Global Dimension 1 Code");
                    RecItem.Validate("Global Dimension 2 Code", RecItemInbox."Global Dimension 2 Code");
                    RecItem.Modify();
                end;
            Rec."Source Type"::"Dimension Value":
                begin
                    Clear(RecDimensionInbox);
                    RecDimensionInbox.SetRange(Code, Rec."Document No.");
                    RecDimensionInbox.SetRange("Dimension Code", Rec."Primary Key 2");
                    RecDimensionInbox.SetRange("Inbox Entry No.", Rec."Entry No.");
                    RecDimensionInbox.FindFirst();
                    Clear(RecDimensionValue);
                    RecDimensionValue.SetRange(Code, RecDimensionInbox.Code);
                    RecDimensionValue.SetRange("Dimension Code", RecDimensionInbox."Dimension Code");
                    if not RecDimensionValue.FindFirst() then begin
                        RecDimensionValue.Init();
                        RecDimensionValue.TransferFields(RecDimensionInbox);
                        RecDimensionValue.Insert(true);
                    end else begin
                        RecDimensionValue.TransferFields(RecDimensionInbox);
                        RecDimensionValue.Modify(true);
                    end;

                end;
        end;
    end;

    procedure MoveToHandledInbox(var RecInbox: Record "IT GM Inbox Transactions")
    var
        RecHandledInbox: Record "IT GM Inbox Handled Trans.";
        RecGLInboxHandled:
                Record "IT GM Inbox Handled G/L Acc.";
        RecItemInboxHandled:
                Record "IT GM Inbox Handled Items";
        RecDimensionInboxHandled:
                Record "IT GM Inbox Handled Dimension";
        RecGLInbox:
                Record "IT GM Inbox G/L Account";
        RecItemInbox:
                Record "IT GM Inbox Items";
        RecDimensionInbox:
                Record "IT GM Inbox Dimension Value";
        DefaultDimensionInbox:
                Record "IT GM Inbox Default Dimensions";
        DefaultDimensionsHandledInbox:
                Record "IT GM Inbox Handl Def. Dimens.";
    begin
        RecInbox.Status := RecInbox.Status::Synced;
        RecInbox.Modify();

        Clear(RecHandledInbox);
        RecHandledInbox.Init();
        RecHandledInbox.TransferFields(RecInbox);
        RecHandledInbox.Insert();

        case RecInbox."Source Type" of
            RecInbox."Source Type"::"G/L Account":
                begin
                    Clear(RecGLInbox);
                    RecGLInbox.SetRange("No.", RecInbox."Document No.");
                    RecGLInbox.SetRange("Inbox Entry No.", RecInbox."Entry No.");
                    RecGLInbox.FindFirst();
                    Clear(RecGLInboxHandled);
                    RecGLInboxHandled.Init();
                    RecGLInboxHandled.TransferFields(RecGLInbox);
                    RecGLInboxHandled."Entry No." := 0;
                    RecGLInboxHandled."Inbox Entry No." := RecHandledInbox."Entry No.";
                    RecGLInboxHandled.Insert(true);
                    Clear(DefaultDimensionInbox);
                    DefaultDimensionInbox.SetRange("Table ID", Database::"G/L Account");
                    DefaultDimensionInbox.SetRange("No.", RecGLInbox."No.");
                    DefaultDimensionInbox.SetRange("Inbox Entry No.", RecInbox."Entry No.");
                    if DefaultDimensionInbox.FindSet() then begin
                        repeat
                            DefaultDimensionsHandledInbox.Init();
                            DefaultDimensionsHandledInbox.TransferFields(DefaultDimensionInbox);
                            DefaultDimensionsHandledInbox."Inbox Entry No." := RecHandledInbox."Entry No.";
                            DefaultDimensionsHandledInbox.Insert();
                        until DefaultDimensionInbox.Next() = 0;
                        DefaultDimensionInbox.DeleteAll();
                    end;
                    RecGLInbox.Delete();
                end;
            RecInbox."Source Type"::Item:
                begin
                    Clear(RecItemInbox);
                    RecItemInbox.SetRange("No.", RecInbox."Document No.");
                    RecItemInbox.SetRange("Inbox Entry No.", RecInbox."Entry No.");
                    RecItemInbox.FindFirst();
                    Clear(RecItemInboxHandled);
                    RecItemInboxHandled.Init();
                    RecItemInboxHandled.TransferFields(RecItemInbox);
                    RecItemInboxHandled."Entry No." := 0;
                    RecItemInboxHandled."Inbox Entry No." := RecHandledInbox."Entry No.";
                    RecItemInboxHandled.Insert(true);
                    Clear(DefaultDimensionInbox);
                    DefaultDimensionInbox.SetRange("Table ID", Database::Item);
                    DefaultDimensionInbox.SetRange("No.", RecItemInbox."No.");
                    DefaultDimensionInbox.SetRange("Inbox Entry No.", RecInbox."Entry No.");
                    if DefaultDimensionInbox.FindSet() then begin
                        repeat
                            DefaultDimensionsHandledInbox.Init();
                            DefaultDimensionsHandledInbox.TransferFields(DefaultDimensionInbox);
                            DefaultDimensionsHandledInbox."Inbox Entry No." := RecHandledInbox."Entry No.";
                            DefaultDimensionsHandledInbox.Insert();
                        until DefaultDimensionInbox.Next() = 0;
                        DefaultDimensionInbox.DeleteAll();
                    end;
                    RecItemInbox.Delete();
                end;
            RecInbox."Source Type"::"Dimension Value":
                begin
                    Clear(RecDimensionInbox);
                    RecDimensionInbox.SetRange(Code, RecInbox."Document No.");
                    RecDimensionInbox.SetRange("Dimension Code", RecInbox."Primary Key 2");
                    RecDimensionInbox.SetRange("Inbox Entry No.", RecInbox."Entry No.");
                    RecDimensionInbox.FindFirst();
                    Clear(RecDimensionInboxHandled);
                    RecDimensionInboxHandled.Init();
                    RecDimensionInboxHandled.TransferFields(RecDimensionInbox);
                    RecDimensionInboxHandled."Entry No." := 0;
                    RecDimensionInboxHandled."Inbox Entry No." := RecHandledInbox."Entry No.";
                    RecDimensionInboxHandled.Insert(true);
                    RecDimensionInbox.Delete();
                end;
        end;
        RecInbox.Delete();
    end;

    local procedure ValidateGLAccountFields(var RecGLAccountP: record "G/L Account"; Var RecInboxGLP: Record "IT GM Inbox G/L Account")
    begin

    end;

    local procedure ValidateItemFields(Var RecItemP: Record Item; Var RecItemInboxP: Record "IT GM Inbox Items")
    begin

    end;

    local procedure ValidateDimensionFields(var RecDimensionvalueP: record "Dimension Value"; var RecDimensionInbox: Record "IT GM Inbox Dimension Value")
    begin
        RecDimensionvalueP.Validate(Name, RecDimensionInbox.Name);
        RecDimensionvalueP.Validate("Dimension Value Type", RecDimensionInbox."Dimension Value Type");
        RecDimensionvalueP.Validate(Totaling, RecDimensionInbox.Totaling);
        RecDimensionvalueP.Validate(Blocked, RecDimensionInbox.Blocked);
        RecDimensionvalueP.Validate("Consolidation Code", RecDimensionInbox."Consolidation Code");
        RecDimensionvalueP.Validate("Global Dimension No.", RecDimensionInbox."Global Dimension No.");
        RecDimensionvalueP.Validate("Dimension Id", RecDimensionInbox."Dimension Id");
        RecDimensionvalueP.Validate("Map-to IC Dimension Code", RecDimensionInbox."Map-to IC Dimension Code");
        RecDimensionvalueP.Validate("Map-to IC Dimension Value Code", RecDimensionInbox."Map-to IC Dimension Value Code");
        RecDimensionvalueP.Validate(Indentation, RecDimensionInbox.Indentation);
    end;

    var
        RecDimensionInbox: Record "IT GM Inbox Dimension Value";
        RecItemInbox: Record "IT GM Inbox Items";
        RecGLInbox: Record "IT GM Inbox G/L Account";
        RecGlAccount: Record "G/L Account";
        RecItem: Record Item;
        RecDimensionValue: Record "Dimension Value";
}
