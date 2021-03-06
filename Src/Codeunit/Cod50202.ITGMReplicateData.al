codeunit 50202 "IT GM Replicate Data"
{

    trigger OnRun()
    var
        DeafultDimension: Record "Default Dimension";
        DefaultDimensionOutbox: Record "IT GM Outbox Default Dimens.";
        Sourcevariant, DestVariant : Variant;
    begin
        case FunctionType of
            FunctionType::"G/L Account":
                begin
                    InsertIntoGMOutBox(RecGlAccount."No.", '');
                    Clear(RecGLOutbox);
                    RecGLOutbox.Init();
                    RecGLOutbox."No." := RecGlAccount."No.";
                    RecGLOutbox.Insert();
                    Sourcevariant := RecGlAccount;
                    DestVariant := RecGLOutbox;
                    InsertValuesByFieldNumber(Sourcevariant, DestVariant);
                    RecGlAccount := Sourcevariant;
                    RecGLOutbox := DestVariant;
                    //RecGLOutbox.TransferFields(RecGlAccount);
                    RecGLOutbox."Source Type" := FunctionType;
                    RecGLOutbox."Outbox Entry No." := RecGMOutbox."Entry No.";
                    RecGLOutbox.Modify(true);
                    Clear(DeafultDimension);
                    DeafultDimension.SetRange("Table ID", Database::"G/L Account");
                    DeafultDimension.SetRange("No.", RecGlAccount."No.");
                    if DeafultDimension.FindSet() then begin
                        repeat
                            DefaultDimensionOutbox.Init();
                            DefaultDimensionOutbox.TransferFields(DeafultDimension);
                            DefaultDimensionOutbox."Outbox Entry No." := RecGMOutbox."Entry No.";
                            DefaultDimensionOutbox."Entry No." := 0;
                            DefaultDimensionOutbox.Insert();
                        until DeafultDimension.Next() = 0;
                    end;
                end;
            FunctionType::Item:
                begin
                    InsertIntoGMOutBox(RecItem."No.", '');
                    Clear(RecItemOutbox);
                    RecItemOutbox.Init();
                    RecItemOutbox."No." := RecItem."No.";
                    RecItemOutbox.Insert();
                    //RecItemOutbox.TransferFields(RecItem);
                    Sourcevariant := RecItem;
                    DestVariant := RecItemOutbox;
                    InsertValuesByFieldNumber(Sourcevariant, DestVariant);
                    RecItem := Sourcevariant;
                    RecItemOutbox := DestVariant;
                    RecItemOutbox."Source Type" := FunctionType;
                    RecItemOutbox."Outbox Entry No." := RecGMOutbox."Entry No.";
                    RecItemOutbox.Modify(true);
                    Clear(DeafultDimension);
                    DeafultDimension.SetRange("Table ID", Database::Item);
                    DeafultDimension.SetRange("No.", RecItem."No.");
                    if DeafultDimension.FindSet() then begin
                        repeat
                            DefaultDimensionOutbox.Init();
                            DefaultDimensionOutbox.TransferFields(DeafultDimension);
                            DefaultDimensionOutbox."Outbox Entry No." := RecGMOutbox."Entry No.";
                            DefaultDimensionOutbox."Entry No." := 0;
                            DefaultDimensionOutbox.Insert();
                        until DeafultDimension.Next() = 0;
                    end;
                end;
            FunctionType::"Dimension Value":
                begin
                    InsertIntoGMOutBox(RecDimensionValue.Code, RecDimensionValue."Dimension Code");
                    Clear(RecDimensionOutbox);
                    RecDimensionOutbox.Init();
                    RecDimensionOutbox."Dimension Code" := RecDimensionValue."Dimension Code";
                    RecDimensionOutbox.Code := RecDimensionValue.Code;
                    RecDimensionOutbox.Insert();
                    Sourcevariant := RecDimensionValue;
                    DestVariant := RecDimensionOutbox;
                    InsertValuesByFieldNumber(Sourcevariant, DestVariant);
                    RecDimensionValue := Sourcevariant;
                    RecDimensionOutbox := DestVariant;
                    //RecDimensionOutbox.TransferFields(RecDimensionValue);
                    RecDimensionOutbox."Source Type" := FunctionType;
                    RecDimensionOutbox."Outbox Entry No." := RecGMOutbox."Entry No.";
                    RecDimensionOutbox.Modify(true);
                end;
        end;
    end;

    local procedure InsertIntoGMOutBox(DocumentNo: Code[20]; PK2: code[20])
    begin
        Clear(RecGMOutbox);
        RecGMOutbox.Init();
        RecGMOutbox."Entry No." := 0;
        RecGMOutbox.Insert(true);
        RecGMOutbox."Document No." := DocumentNo;
        RecGMOutbox."Source Entity" := CompanyName;
        RecGMOutbox."Source Type" := FunctionType;
        RecGMOutbox."Creation Date" := CurrentDateTime;
        RecGMOutbox.Status := RecGMOutbox.Status::Pending;
        RecGMOutbox."Primary Key 2" := PK2;
        RecGMOutbox.Modify(true);
    end;

    procedure MoveToInbox(Var RecOutboxP: Record "IT GM Outbox Transactions")
    var
        IsDistributionSetupAvailable: Boolean;
        RecOutboxL: Record "IT GM Outbox Transactions";
        CheckList: List of [Text];
        RecDataDistSetup: Record "IT GM Data Distribution Setup";
        MarkedOutBox: Record "IT GM Outbox Transactions";
    begin
        IsDistributionSetupAvailable := false;
        Clear(CheckList);
        Clear(RecOutboxL);
        RecOutboxL.Copy(RecOutboxP);
        if RecOutboxL.FindSet() then begin
            repeat
                Clear(RecDataDistributionSetup);
                RecDataDistributionSetup.SetRange("Table Name", RecOutboxL."Source Type");
                RecDataDistributionSetup.SetRange("Source Entity", CompanyName);
                RecDataDistributionSetup.SetRange("Destination Entity Type", RecDataDistributionSetup."Destination Entity Type"::"Same Instance");
                if RecDataDistributionSetup.FindSet() then begin
                    repeat
                        IsDistributionSetupAvailable := true;
                        InsertIntoGMInbox(RecOutboxL, RecDataDistributionSetup."Destination Entity");
                    until RecDataDistributionSetup.Next() = 0;
                end;
            until RecOutboxL.Next() = 0;
        end;


        Clear(RecDataDistributionSetup);
        //RecDataDistributionSetup.SetRange("Table Name", RecOutboxP."Source Type");
        RecDataDistributionSetup.SetRange("Source Entity", CompanyName);
        RecDataDistributionSetup.SetRange("Destination Entity Type", RecDataDistributionSetup."Destination Entity Type"::"Different Instance");
        if RecDataDistributionSetup.FindSet() then begin
            repeat
                if not CheckList.Contains(RecDataDistributionSetup."Destination Entity") then begin
                    CheckList.Add(RecDataDistributionSetup."Destination Entity");
                    Clear(MarkedOutBox);
                    Clear(RecDataDistSetup);
                    RecDataDistSetup.SetRange("Source Entity", CompanyName);
                    RecDataDistSetup.SetRange("Destination Entity Type", RecDataDistributionSetup."Destination Entity Type"::"Different Instance");
                    RecDataDistSetup.SetRange("Destination Entity", RecDataDistributionSetup."Destination Entity");
                    if RecDataDistSetup.FindSet() then begin
                        repeat
                            Clear(RecOutboxL);
                            RecOutboxL.Copy(RecOutboxP);
                            RecOutboxL.SetRange("Source Type", RecDataDistSetup."Table Name");
                            if RecOutboxL.FindSet() then begin
                                repeat
                                    MarkedOutBox.SetCurrentKey("Entry No.");
                                    MarkedOutBox.SetRange("Entry No.", RecOutboxL."Entry No.");
                                    if MarkedOutBox.FindFirst() then
                                        MarkedOutBox.Mark(true);
                                until RecOutboxL.Next() = 0;
                            end;
                        until RecDataDistSetup.Next() = 0;
                    end;
                    MarkedOutBox.SetRange("Entry No.");
                    MarkedOutBox.MarkedOnly(true);
                    if MarkedOutBox.Count > 0 then begin
                        IsDistributionSetupAvailable := true;
                        SendDataToAzureBlobStorage(MarkedOutBox, RecDataDistributionSetup."Destination Entity");
                    end;
                end;
            until RecDataDistributionSetup.Next() = 0;
        end;


        if not IsDistributionSetupAvailable then
            Error('Data Distribution Setup is not available');

        Clear(RecOutboxL);
        RecOutboxL.Copy(RecOutboxP);
        if RecOutboxL.FindSet() then begin
            repeat
                RecOutboxL.Status := RecOutboxL.Status::Synced;
                RecOutboxL.Modify();
                MoveToHandledOutbox(RecOutboxL);
                RecOutboxL.Delete();
            until RecOutboxL.Next() = 0;
        end;
    end;

    local procedure MoveToHandledOutbox(Var RecOutbox: Record "IT GM Outbox Transactions")
    var
        RecHandledOutbox: Record "IT GM Outbox Handled Trans.";
        RecGLOutboxHandled: Record "IT GM Outbox Handled G/L Acc.";
        RecItemOutboxHandled: Record "IT GM Outbox Handled Items";
        RecDimensionOutboxHandled: Record "IT GM Outbox Handled Dimension";
        DefaultDimensionsHandledOutbox: Record "IT GM Outbox Handl. Def. Dimen";
        DefaultDimensionsOutbox: Record "IT GM Outbox Default Dimens.";
    begin

        Clear(RecHandledOutbox);
        RecHandledOutbox.Init();
        RecHandledOutbox.TransferFields(RecOutbox);
        RecHandledOutbox.Insert();

        case RecOutbox."Source Type" of
            RecOutbox."Source Type"::"G/L Account":
                begin
                    Clear(RecGLOutbox);
                    RecGLOutbox.SetRange("No.", RecOutbox."Document No.");
                    RecGLOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    RecGLOutbox.FindFirst();
                    Clear(RecGLOutboxHandled);
                    RecGLOutboxHandled.Init();
                    RecGLOutboxHandled.TransferFields(RecGLOutbox);
                    RecGLOutboxHandled."Entry No." := 0;
                    RecGLOutboxHandled."Outbox Entry No." := RecHandledOutbox."Entry No.";
                    RecGLOutboxHandled.Insert(true);
                    Clear(DefaultDimensionsOutbox);
                    DefaultDimensionsOutbox.SetRange("Table ID", Database::"G/L Account");
                    DefaultDimensionsOutbox.SetRange("No.", RecGLOutbox."No.");
                    DefaultDimensionsOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    if DefaultDimensionsOutbox.FindSet() then begin
                        repeat
                            DefaultDimensionsHandledOutbox.Init();
                            DefaultDimensionsHandledOutbox.TransferFields(DefaultDimensionsOutbox);
                            DefaultDimensionsHandledOutbox."Outbox Entry No." := RecHandledOutbox."Entry No.";
                            DefaultDimensionsHandledOutbox.Insert();
                        until DefaultDimensionsOutbox.Next() = 0;
                        DefaultDimensionsOutbox.DeleteAll();
                    end;
                    RecGLOutbox.Delete();
                end;
            RecOutbox."Source Type"::Item:
                begin
                    Clear(RecItemOutbox);
                    RecItemOutbox.SetRange("No.", RecOutbox."Document No.");
                    RecItemOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    RecItemOutbox.FindFirst();
                    Clear(RecItemOutboxHandled);
                    RecItemOutboxHandled.Init();
                    RecItemOutboxHandled.TransferFields(RecItemOutbox);
                    RecItemOutboxHandled."Entry No." := 0;
                    RecItemOutboxHandled."Outbox Entry No." := RecHandledOutbox."Entry No.";
                    RecItemOutboxHandled.Insert(true);

                    Clear(DefaultDimensionsOutbox);
                    DefaultDimensionsOutbox.SetRange("Table ID", Database::Item);
                    DefaultDimensionsOutbox.SetRange("No.", RecItemOutbox."No.");
                    DefaultDimensionsOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    if DefaultDimensionsOutbox.FindSet() then begin
                        repeat
                            DefaultDimensionsHandledOutbox.Init();
                            DefaultDimensionsHandledOutbox.TransferFields(DefaultDimensionsOutbox);
                            DefaultDimensionsHandledOutbox."Outbox Entry No." := RecHandledOutbox."Entry No.";
                            DefaultDimensionsHandledOutbox.Insert();
                        until DefaultDimensionsOutbox.Next() = 0;
                        DefaultDimensionsOutbox.DeleteAll();
                    end;

                    RecItemOutbox.Delete();
                end;
            RecOutbox."Source Type"::"Dimension Value":
                begin
                    Clear(RecDimensionOutbox);
                    RecDimensionOutbox.SetRange(Code, RecOutbox."Document No.");
                    RecDimensionOutbox.SetRange("Dimension Code", RecOutbox."Primary Key 2");
                    RecDimensionOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    RecDimensionOutbox.FindFirst();
                    Clear(RecDimensionOutboxHandled);
                    RecDimensionOutboxHandled.Init();
                    RecDimensionOutboxHandled.TransferFields(RecDimensionOutbox);
                    RecDimensionOutboxHandled."Outbox Entry No." := RecHandledOutbox."Entry No.";
                    RecDimensionOutboxHandled."Entry No." := 0;
                    RecDimensionOutboxHandled.Insert(true);
                    RecDimensionOutbox.Delete();
                end;
        end;
    end;

    local procedure InsertIntoGMInbox(var RecOutbox: Record "IT GM Outbox Transactions"; EntityName: Text[30])
    var
        DefaultDimensionInbox: Record "IT GM Inbox Default Dimensions";
        DefaultDimensionOutbox: Record "IT GM Outbox Default Dimens.";
    begin
        Clear(RecGMInbox);
        RecGMInbox.ChangeCompany(EntityName);
        RecGMInbox.Init();
        RecGMInbox."Entry No." := 0;
        RecGMInbox.Insert(true);
        RecGMInbox."Document No." := RecOutbox."Document No.";
        RecGMInbox."Source Entity" := CompanyName;
        RecGMInbox."Source Type" := RecOutbox."Source Type";
        RecGMInbox."Creation Date" := CurrentDateTime;
        RecGMInbox."Primary Key 2" := RecOutbox."Primary Key 2";
        RecGMInbox.Status := RecGMInbox.Status::Pending;
        RecGMInbox.Modify(true);
        case RecOutbox."Source Type" of
            RecOutbox."Source Type"::"G/L Account":
                begin
                    Clear(RecGLOutbox);
                    RecGLOutbox.SetRange("No.", RecOutbox."Document No.");
                    RecGLOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    RecGLOutbox.FindFirst();
                    Clear(RecGLInbox);
                    RecGLInbox.ChangeCompany(EntityName);
                    RecGLInbox.Init();
                    RecGLInbox.TransferFields(RecGLOutbox);
                    RecGLOutbox.CalcFields("Account Subcategory Descript.");
                    RecGLInbox."Account Subcategory Descript." := RecGLOutbox."Account Subcategory Descript.";
                    RecGLInbox."Entry No." := 0;
                    RecGLInbox."Inbox Entry No." := RecGMInbox."Entry No.";
                    RecGLInbox.Insert(true);
                    Clear(DefaultDimensionOutbox);
                    DefaultDimensionOutbox.SetRange("Table ID", Database::"G/L Account");
                    DefaultDimensionOutbox.SetRange("No.", RecGLOutbox."No.");
                    DefaultDimensionOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    if DefaultDimensionOutbox.FindSet() then begin
                        repeat
                            Clear(DefaultDimensionInbox);
                            DefaultDimensionInbox.ChangeCompany(EntityName);
                            DefaultDimensionInbox.Init();
                            DefaultDimensionInbox.TransferFields(DefaultDimensionOutbox);
                            DefaultDimensionInbox."Inbox Entry No." := RecGMInbox."Entry No.";
                            DefaultDimensionInbox."Entry No." := 0;
                            DefaultDimensionInbox.Insert();
                        until DefaultDimensionOutbox.Next() = 0;
                    end;
                end;
            RecOutbox."Source Type"::Item:
                begin
                    Clear(RecItemOutbox);
                    RecItemOutbox.SetRange("No.", RecOutbox."Document No.");
                    RecItemOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    RecItemOutbox.FindFirst();
                    Clear(RecItemInbox);
                    RecItemInbox.ChangeCompany(EntityName);
                    RecItemInbox.Init();
                    RecItemInbox.TransferFields(RecItemOutbox);
                    RecItemInbox."Entry No." := 0;
                    RecItemInbox."Inbox Entry No." := RecGMInbox."Entry No.";
                    RecItemInbox.Insert(true);
                    Clear(DefaultDimensionOutbox);
                    DefaultDimensionOutbox.SetRange("Table ID", Database::Item);
                    DefaultDimensionOutbox.SetRange("No.", RecItemOutbox."No.");
                    DefaultDimensionOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    if DefaultDimensionOutbox.FindSet() then begin
                        repeat
                            Clear(DefaultDimensionInbox);
                            DefaultDimensionInbox.ChangeCompany(EntityName);
                            DefaultDimensionInbox.Init();
                            DefaultDimensionInbox.TransferFields(DefaultDimensionOutbox);
                            DefaultDimensionInbox."Inbox Entry No." := RecGMInbox."Entry No.";
                            DefaultDimensionInbox."Entry No." := 0;
                            DefaultDimensionInbox.Insert();
                        until DefaultDimensionOutbox.Next() = 0;
                    end;
                end;
            RecOutbox."Source Type"::"Dimension Value":
                begin
                    Clear(RecDimensionOutbox);
                    RecDimensionOutbox.SetRange(Code, RecOutbox."Document No.");
                    RecDimensionOutbox.SetRange("Dimension Code", RecOutbox."Primary Key 2");
                    RecDimensionOutbox.SetRange("Outbox Entry No.", RecOutbox."Entry No.");
                    RecDimensionOutbox.FindFirst();
                    Clear(RecDimensionInbox);
                    RecDimensionInbox.ChangeCompany(EntityName);
                    RecDimensionInbox.Init();
                    RecDimensionInbox.TransferFields(RecDimensionOutbox);
                    RecDimensionInbox."Inbox Entry No." := RecGMInbox."Entry No.";
                    RecDimensionInbox."Entry No." := 0;
                    RecDimensionInbox.Insert(true);
                end;
        end;
    end;

    local procedure SendDataToAzureBlobStorage(var RecOutbox: Record "IT GM Outbox Transactions"; EntityName: Text[30])
    var
        ExportOutboxData: XmlPort "IT GM Outbox Export";
        TempBlob: Codeunit "Temp Blob";
        RecBlobStorageSetup: Record "IT Blob Storage Account";
        //RecOutboxLocal: Record "IT GM Outbox Transactions";
        BlobService: Codeunit "Blob Service API GM";
        FileName: Text;
        OutStream: OutStream;
        InStream: InStream;
    begin
        // Clear(RecOutboxLocal);
        // RecOutboxLocal.SetRange("Entry No.", RecOutbox."Entry No.");
        // RecOutboxLocal.FindFirst();
        Clear(ExportOutboxData);
        //ExportOutboxData.SetTableView(RecOutboxLocal);
        ExportOutboxData.SetTableView(RecOutbox);
        TempBlob.CreateOutStream(OutStream);
        ExportOutboxData.SetDestination(OutStream);
        ExportOutboxData.Export();
        TempBlob.CreateInStream(Instream);
        RecBlobStorageSetup.GET;
        RecBlobStorageSetup.TestField("Root Container GM");
        //FileName := RecOutboxLocal."Source Entity" + '_' + EntityName + '_' + FORMAT(RecOutboxLocal."Source Type") + '_' + RecOutboxLocal."Document No." + '_' + DelChr(Format(CurrentDateTime), '=', ':\/,APM-. ') + '.xml';
        FileName := 'From_' + CompanyName + '_To_' + EntityName + '_' + DelChr(Format(CurrentDateTime), '=', ':\/,APM-. ') + '.xml';
        BlobService.PutBlob(RecBlobStorageSetup."Root Container GM", FileName, Instream);
    end;

    procedure ImportFromBlobStorage(Filename: Text)
    var
        ImportDataIntoInbox: XmlPort "IT GM Inbox Import";
        RecBlobStorageAccount: Record "IT Blob Storage Account";
        BlobService: Codeunit "Blob Service API GM";
        InStream: InStream;
        InStreamL: InStream;
    begin
        RecBlobStorageAccount.GET;
        Clear(BlobService);
        BlobService.GetBlobIntoStream(RecBlobStorageAccount."Root Container GM", FileName, Instream);
        BlobService.GetBlobIntoStream(RecBlobStorageAccount."Root Container GM", FileName, InstreamL);
        BlobService.PutBlob(RecBlobStorageAccount."Failed Container GM", FileName, InstreamL);
        BlobService.DeleteBlob(RecBlobStorageAccount."Root Container GM", FileName);

        Clear(ImportDataIntoInbox);
        ImportDataIntoInbox.SetSource(Instream);
        ImportDataIntoInbox.Import();

        //Moving from failed to success 
        Clear(BlobService);
        BlobService.PutBlob(RecBlobStorageAccount."Success Container GM", FileName, Instream);
        BlobService.DeleteBlob(RecBlobStorageAccount."Failed Container GM", FileName);

    end;



    procedure SetData(RecVariant: Variant; Type: Enum "IT Data Replication Fn")
    begin
        FunctionType := Type;
        case FunctionType of
            FunctionType::"G/L Account":
                RecGlAccount := RecVariant;
            FunctionType::Item:
                RecItem := RecVariant;
            FunctionType::"Dimension Value":
                RecDimensionValue := RecVariant;
        end;
    end;

    local procedure InsertValuesByFieldNumber(var SourceVariant: Variant; Var DestVariant: Variant)
    var
        RecGLAccountL: Record "G/L Account";
        RecItemL: Record Item;
        RecDimensionL: Record "Dimension Value";
        RecGLOutboxL: Record "IT GM Outbox G/L Account";
        RecItemOutboxL: Record "IT GM Outbox Items";
        RecDimensionOutbox: Record "IT GM Outbox Dimension Value";
        GLSetupL: Record "General Ledger Setup";
        FieldList: List of [Text];
        Seperators: Text;
        Text: Text;
        FieldNumber: Integer;
        FRef: FieldRef;
        Fref2: FieldRef;
        SourceRecRef: RecordRef;
        DestinationRecordRef: RecordRef;
    begin
        SourceRecRef.GetTable(SourceVariant);
        DestinationRecordRef.GetTable(DestVariant);
        GLSetupL.GET;
        CASE SourceRecRef.NUMBER OF
            DATABASE::"G/L Account":
                BEGIN
                    if GLSetupL."G/L Account Fields" <> '' then begin
                        Seperators := ',';
                        FieldList := GLSetupL."G/L Account Fields".Split(Seperators.Split());
                        foreach Text in FieldList do begin
                            Evaluate(FieldNumber, Text);
                            FRef := SourceRecRef.FIELD(FieldNumber);
                            Fref2 := DestinationRecordRef.Field(FieldNumber);
                            Fref2.Value(FRef.Value);
                            DestinationRecordRef.Modify();
                        end;
                    end;
                END;
            DATABASE::Item:
                BEGIN
                    if GLSetupL."Item Fields" <> '' then begin
                        Seperators := ',';
                        FieldList := GLSetupL."Item Fields".Split(Seperators.Split());
                        foreach Text in FieldList do begin
                            Evaluate(FieldNumber, Text);
                            FRef := SourceRecRef.FIELD(FieldNumber);
                            Fref2 := DestinationRecordRef.Field(FieldNumber);
                            Fref2.Value(FRef.Value);
                            DestinationRecordRef.Modify();
                        end;
                    end;
                END;
            DATABASE::"Dimension Value":
                BEGIN
                    if GLSetupL."Dimension Fields" <> '' then begin
                        Seperators := ',';
                        FieldList := GLSetupL."Dimension Fields".Split(Seperators.Split());
                        foreach Text in FieldList do begin
                            Evaluate(FieldNumber, Text);
                            FRef := SourceRecRef.FIELD(FieldNumber);
                            Fref2 := DestinationRecordRef.Field(FieldNumber);
                            Fref2.Value(FRef.Value);
                            DestinationRecordRef.Modify();
                        end;
                    end;
                END;
        end;
        SourceVariant := SourceRecRef;
        DestVariant := DestinationRecordRef;
    end;

    var
        FunctionType: Enum "IT Data Replication Fn";
        RecGLOutbox: Record "IT GM Outbox G/L Account";

        RecGMInbox: Record "IT GM Inbox Transactions";
        RecGMOutbox: Record "IT GM Outbox Transactions";
        RecDataDistributionSetup: Record "IT GM Data Distribution Setup";
        RecItemOutbox: Record "IT GM Outbox Items";

        RecDimensionOutbox: Record "IT GM Outbox Dimension Value";
        RecDimensionInbox: Record "IT GM Inbox Dimension Value";
        RecItemInbox: Record "IT GM Inbox Items";
        RecGLInbox: Record "IT GM Inbox G/L Account";
        RecGlAccount: Record "G/L Account";
        RecItem: Record Item;
        RecDimensionValue: Record "Dimension Value";
}
