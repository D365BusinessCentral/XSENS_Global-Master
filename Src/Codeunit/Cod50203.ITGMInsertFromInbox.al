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
                        //RecGlAccount.TransferFields(RecGLInbox);
                        RecGlAccount.Validate("No.", RecGLInbox."No.");
                        ValidateGLAccountFields(RecGlAccount, RecGLInbox);
                        RecGlAccount.Insert(true);
                    end else begin
                        //RecGlAccount.TransferFields(RecGLInbox);
                        ValidateGLAccountFields(RecGlAccount, RecGLInbox);
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
                        //RecItem.TransferFields(RecItemInbox);
                        RecItem.Validate("No.", RecItemInbox."No.");
                        ValidateItemFields(RecItem, RecItemInbox);
                        RecItem.Insert(true);
                    end else begin
                        //RecItem.TransferFields(RecItemInbox);
                        ValidateItemFields(RecItem, RecItemInbox);
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
                    RecItem.Validate("Base Unit of Measure", RecItemInbox."Base Unit of Measure");
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
                        //RecDimensionValue.TransferFields(RecDimensionInbox);
                        RecDimensionValue.Validate("Dimension Code", RecDimensionInbox."Dimension Code");
                        RecDimensionValue.Validate(Code, RecDimensionInbox.Code);
                        ValidateDimensionFields(RecDimensionValue, RecDimensionInbox);
                        RecDimensionValue.Insert(true);
                    end else begin
                        //RecDimensionValue.TransferFields(RecDimensionInbox);
                        ValidateDimensionFields(RecDimensionValue, RecDimensionInbox);
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
    var
        RecGLCategory: Record "G/L Account Category";
    begin
        RecGLAccountP.Validate(Name, RecInboxGLP.Name);
        RecGLAccountP.Validate("Search Name", RecInboxGLP."Search Name");
        RecGLAccountP.Validate("Account Type", RecInboxGLP."Account Type");
        //RecGLAccountP.Validate("Global Dimension 1 Code", RecInboxGLP."Global Dimension 1 Code");
        //RecGLAccountP.Validate("Global Dimension 2 Code", RecInboxGLP."Global Dimension 2 Code");
        RecGLAccountP.Validate("Account Category", RecInboxGLP."Account Category");
        RecGLAccountP.Validate("Income/Balance", RecInboxGLP."Income/Balance");
        RecGLAccountP.Validate("Debit/Credit", RecInboxGLP."Debit/Credit");
        RecGLAccountP.Validate("No. 2", RecInboxGLP."No. 2");
        //RecGLAccountP.Validate(Comment, RecInboxGLP.Comment);
        RecGLAccountP.Validate(Blocked, RecInboxGLP.Blocked);
        RecGLAccountP.Validate("Direct Posting", RecInboxGLP."Direct Posting");
        RecGLAccountP.Validate("Reconciliation Account", RecInboxGLP."Reconciliation Account");
        RecGLAccountP.Validate("New Page", RecInboxGLP."New Page");
        RecGLAccountP.Validate("No. of Blank Lines", RecInboxGLP."No. of Blank Lines");
        RecGLAccountP.Validate(Indentation, RecInboxGLP.Indentation);
        RecGLAccountP.Validate("Last Date Modified", RecInboxGLP."Last Date Modified");
        RecGLAccountP.Validate("Date Filter", RecInboxGLP."Date Filter");
        RecGLAccountP.Validate("Global Dimension 1 Filter", RecInboxGLP."Global Dimension 1 Filter");
        RecGLAccountP.Validate("Global Dimension 2 Filter", RecInboxGLP."Global Dimension 2 Filter");
        //RecGLAccountP.Validate("Balance at Date", RecInboxGLP."Balance at Date");
        //RecGLAccountP.Validate("Net Change", RecInboxGLP."Net Change");
        //RecGLAccountP.Validate("Budgeted Amount", RecInboxGLP."Budgeted Amount");
        if RecGLAccountP.IsTotaling() then
            RecGLAccountP.Validate(Totaling, RecInboxGLP.Totaling);
        RecGLAccountP.Validate("Budget Filter", RecInboxGLP."Budget Filter");
        //RecGLAccountP.Validate(Balance, RecInboxGLP.Balance);
        //RecGLAccountP.Validate("Budget at Date", RecInboxGLP."Budget at Date");
        RecGLAccountP.Validate("Consol. Translation Method", RecInboxGLP."Consol. Translation Method");
        RecGLAccountP.Validate("Consol. Debit Acc.", RecInboxGLP."Consol. Debit Acc.");
        RecGLAccountP.Validate("Consol. Credit Acc.", RecInboxGLP."Consol. Credit Acc.");
        RecGLAccountP.Validate("Business Unit Filter", RecInboxGLP."Business Unit Filter");
        RecGLAccountP.Validate("Gen. Posting Type", RecInboxGLP."Gen. Posting Type");
        RecGLAccountP.Validate("Gen. Bus. Posting Group", RecInboxGLP."Gen. Bus. Posting Group");
        RecGLAccountP.Validate("Gen. Prod. Posting Group", RecInboxGLP."Gen. Prod. Posting Group");
        RecGLAccountP.Validate(Picture, RecInboxGLP.Picture);
        //RecGLAccountP.Validate("Debit Amount", RecInboxGLP."Debit Amount");
        //RecGLAccountP.Validate("Credit Amount", RecInboxGLP."Credit Amount");
        RecGLAccountP.Validate("Automatic Ext. Texts", RecInboxGLP."Automatic Ext. Texts");
        //RecGLAccountP.Validate("Budgeted Debit Amount", RecInboxGLP."Budgeted Debit Amount");
        //RecGLAccountP.Validate("Budgeted Credit Amount", RecInboxGLP."Budgeted Credit Amount");
        RecGLAccountP.Validate("Tax Area Code", RecInboxGLP."Tax Area Code");
        RecGLAccountP.Validate("Tax Liable", RecInboxGLP."Tax Liable");
        RecGLAccountP.Validate("Tax Group Code", RecInboxGLP."Tax Group Code");
        RecGLAccountP.Validate("VAT Bus. Posting Group", RecInboxGLP."VAT Bus. Posting Group");
        RecGLAccountP.Validate("VAT Prod. Posting Group", RecInboxGLP."VAT Prod. Posting Group");
        //RecGLAccountP.Validate("VAT Amt.", RecInboxGLP."VAT Amt.");
        RecGLAccountP.Validate("Add.-Currency Balance at Date", RecInboxGLP."Add.-Currency Balance at Date");
        //RecGLAccountP.Validate("Additional-Currency Net Change", RecInboxGLP."Additional-Currency Net Change");
        //RecGLAccountP.Validate("Additional-Currency Balance", RecInboxGLP."Additional-Currency Balance");
        RecGLAccountP.Validate("Exchange Rate Adjustment", RecInboxGLP."Exchange Rate Adjustment");
        //RecGLAccountP.Validate("Add.-Currency Debit Amount", RecInboxGLP."Add.-Currency Debit Amount");
        //RecGLAccountP.Validate("Add.-Currency Credit Amount", RecInboxGLP."Add.-Currency Credit Amount");
        RecGLAccountP.Validate("Default IC Partner G/L Acc. No", RecInboxGLP."Default IC Partner G/L Acc. No");
        RecGLAccountP.Validate("Omit Default Descr. in Jnl.", RecInboxGLP."Omit Default Descr. in Jnl.");
        Clear(RecGLCategory);
        RecGLCategory.SetRange(Description, RecInboxGLP."Account Subcategory Descript.");
        if RecGLCategory.FindFirst() then
            RecGLAccountP.Validate("Account Subcategory Entry No.", RecGLCategory."Entry No.");
        // RecGLAccountP.Validate("Account Subcategory Entry No.", RecInboxGLP."Account Subcategory Entry No.");
        //RecGLAccountP.Validate("Account Subcategory Descript.", RecInboxGLP."Account Subcategory Descript.");
        RecGLAccountP.Validate("Dimension Set ID Filter", RecInboxGLP."Dimension Set ID Filter");
        RecGLAccountP.Validate("Cost Type No.", RecInboxGLP."Cost Type No.");
        RecGLAccountP.Validate("Default Deferral Template Code", RecInboxGLP."Default Deferral Template Code");
        // RecGLAccountP.Validate(Id,RecInboxGLP.);
        //RecGLAccountP.Validate("API Account Type", RecInboxGLP."API Account Type");
        // RecGLAccountP.Validate("GIFI Code", RecInboxGLP.);
        // RecGLAccountP.Validate("SAT Account Code", RecInboxGLP.);
    end;

    local procedure ValidateItemFields(Var RecItemP: Record Item; Var RecItemInboxP: Record "IT GM Inbox Items")
    begin
        RecItemP.Validate("No. 2", RecItemInboxP."No. 2");
        RecItemP.Validate(Description, RecItemInboxP.Description);
        RecItemP.Validate("Search Description", RecItemInboxP."Search Description");
        RecItemP.Validate("Description 2", RecItemInboxP."Description 2");
        //RecItemP.Validate("Assembly BOM", RecItemInboxP."Assembly BOM");
        RecItemP.Validate("Price Unit Conversion", RecItemInboxP."Price Unit Conversion");
        RecItemP.Validate(Type, RecItemInboxP.Type);
        //RecItemP.Validate("Inventory Posting Group", RecItemInboxP."Inventory Posting Group");
        RecItemP.Validate("Shelf No.", RecItemInboxP."Shelf No.");
        RecItemP.Validate("Item Disc. Group", RecItemInboxP."Item Disc. Group");
        RecItemP.Validate("Allow Invoice Disc.", RecItemInboxP."Allow Invoice Disc.");
        RecItemP.Validate("Statistics Group", RecItemInboxP."Statistics Group");
        RecItemP.Validate("Unit Price", RecItemInboxP."Unit Price");
        RecItemP.Validate("Commission Group", RecItemInboxP."Commission Group");
        RecItemP.Validate("Price/Profit Calculation", RecItemInboxP."Price/Profit Calculation");
        RecItemP.Validate("Profit %", RecItemInboxP."Profit %");
        RecItemP.Validate("Costing Method", RecItemInboxP."Costing Method");
        RecItemP.Validate("Unit Cost", RecItemInboxP."Unit Cost");
        RecItemP.Validate("Standard Cost", RecItemInboxP."Standard Cost");
        RecItemP.Validate("Last Direct Cost", RecItemInboxP."Last Direct Cost");
        RecItemP.Validate("Indirect Cost %", RecItemInboxP."Indirect Cost %");
        RecItemP.Validate("Cost is Adjusted", RecItemInboxP."Cost is Adjusted");
        RecItemP.Validate("Allow Online Adjustment", RecItemInboxP."Allow Online Adjustment");
        RecItemP.Validate("Vendor No.", RecItemInboxP."Vendor No.");
        RecItemP.Validate("Vendor Item No.", RecItemInboxP."Vendor Item No.");
        RecItemP.Validate("Lead Time Calculation", RecItemInboxP."Lead Time Calculation");
        RecItemP.Validate("Reorder Point", RecItemInboxP."Reorder Point");
        RecItemP.Validate("Maximum Inventory", RecItemInboxP."Maximum Inventory");
        RecItemP.Validate("Reorder Quantity", RecItemInboxP."Reorder Quantity");
        RecItemP.Validate("Alternative Item No.", RecItemInboxP."Alternative Item No.");
        RecItemP.Validate("Unit List Price", RecItemInboxP."Unit List Price");
        RecItemP.Validate("Duty Due %", RecItemInboxP."Duty Due %");
        RecItemP.Validate("Duty Code", RecItemInboxP."Duty Code");
        RecItemP.Validate("Gross Weight", RecItemInboxP."Gross Weight");
        RecItemP.Validate("Net Weight", RecItemInboxP."Net Weight");
        RecItemP.Validate("Units per Parcel", RecItemInboxP."Units per Parcel");
        RecItemP.Validate("Unit Volume", RecItemInboxP."Unit Volume");
        RecItemP.Validate(Durability, RecItemInboxP.Durability);
        RecItemP.Validate("Freight Type", RecItemInboxP."Freight Type");
        RecItemP.Validate("Tariff No.", RecItemInboxP."Tariff No.");
        RecItemP.Validate("Duty Unit Conversion", RecItemInboxP."Duty Unit Conversion");
        RecItemP.Validate("Country/Region Purchased Code", RecItemInboxP."Country/Region Purchased Code");
        RecItemP.Validate("Budgeted Amount", RecItemInboxP."Budgeted Amount");
        RecItemP.Validate("Budget Quantity", RecItemInboxP."Budget Quantity");
        RecItemP.Validate("Budget Profit", RecItemInboxP."Budget Profit");
        //RecItemP.Validate(Comment, RecItemInboxP.Comment);
        RecItemP.Validate(Blocked, RecItemInboxP.Blocked);
        //RecItemP.Validate("Cost is Posted to G/L", RecItemInboxP."Cost is Posted to G/L");
        if RecItemP.Blocked then
            RecItemP.Validate("Block Reason", RecItemInboxP."Block Reason");
        RecItemP.Validate("Last DateTime Modified", RecItemInboxP."Last DateTime Modified");
        RecItemP.Validate("Last Date Modified", RecItemInboxP."Last Date Modified");
        RecItemP.Validate("Last Time Modified", RecItemInboxP."Last Time Modified");
        RecItemP.Validate("Date Filter", RecItemInboxP."Date Filter");
        RecItemP.Validate("Global Dimension 1 Filter", RecItemInboxP."Global Dimension 1 Filter");
        RecItemP.Validate("Global Dimension 2 Filter", RecItemInboxP."Global Dimension 2 Filter");
        RecItemP.Validate("Location Filter", RecItemInboxP."Location Filter");
        //RecItemP.Validate(Inventory, RecItemInboxP.Inventory);
        //RecItemP.Validate("Net Invoiced Qty.", RecItemInboxP."Net Invoiced Qty.");
        //RecItemP.Validate("Net Change", RecItemInboxP."Net Change");
        //RecItemP.Validate("Purchases (Qty.)", RecItemInboxP."Purchases (Qty.)");
        //RecItemP.Validate("Sales (Qty.)", RecItemInboxP."Sales (Qty.)");
        //RecItemP.Validate("Positive Adjmt. (Qty.)", RecItemInboxP."Positive Adjmt. (Qty.)");
        //RecItemP.Validate("Negative Adjmt. (Qty.)", RecItemInboxP."Negative Adjmt. (Qty.)");
        //RecItemP.Validate("Purchases (LCY)", RecItemInboxP."Purchases (LCY)");
        //RecItemP.Validate("Sales (LCY)", RecItemInboxP."Sales (LCY)");
        //RecItemP.Validate("Positive Adjmt. (LCY)", RecItemInboxP."Positive Adjmt. (LCY)");
        //RecItemP.Validate("Negative Adjmt. (LCY)", RecItemInboxP."Negative Adjmt. (LCY)");
        //RecItemP.Validate("COGS (LCY)", RecItemInboxP."COGS (LCY)");
        //RecItemP.Validate("Qty. on Purch. Order", RecItemInboxP."Qty. on Purch. Order");
        //RecItemP.Validate("Qty. on Sales Order", RecItemInboxP."Qty. on Sales Order");
        RecItemP.Validate("Price Includes VAT", RecItemInboxP."Price Includes VAT");
        RecItemP.Validate("Drop Shipment Filter", RecItemInboxP."Drop Shipment Filter");
        RecItemP.Validate("VAT Bus. Posting Gr. (Price)", RecItemInboxP."VAT Bus. Posting Gr. (Price)");
        RecItemP.Validate("Gen. Prod. Posting Group", RecItemInboxP."Gen. Prod. Posting Group");
        RecItemP.Validate(Picture, RecItemInboxP.Picture);
        //RecItemP.Validate("Transferred (Qty.)", RecItemInboxP."Transferred (Qty.)");
        //RecItemP.Validate("Transferred (LCY)", RecItemInboxP."Transferred (LCY)");
        RecItemP.Validate("Country/Region of Origin Code", RecItemInboxP."Country/Region of Origin Code");
        RecItemP.Validate("Automatic Ext. Texts", RecItemInboxP."Automatic Ext. Texts");
        RecItemP.Validate("No. Series", RecItemInboxP."No. Series");
        RecItemP.Validate("Tax Group Code", RecItemInboxP."Tax Group Code");
        RecItemP.Validate("VAT Prod. Posting Group", RecItemInboxP."VAT Prod. Posting Group");
        RecItemP.Validate(Reserve, RecItemInboxP.Reserve);
        //RecItemP.Validate("Reserved Qty. on Inventory", RecItemInboxP."Reserved Qty. on Inventory");
        //RecItemP.Validate("Reserved Qty. on Purch. Orders", RecItemInboxP."Reserved Qty. on Purch. Orders");
        //RecItemP.Validate("Reserved Qty. on Sales Orders", RecItemInboxP."Reserved Qty. on Sales Orders");
        //RecItemP.Validate("Global Dimension 1 Code", RecItemInboxP."Global Dimension 1 Code");
        //RecItemP.Validate("Global Dimension 2 Code", RecItemInboxP."Global Dimension 2 Code");
        //RecItemP.Validate("Res. Qty. on Inbound Transfer", RecItemInboxP."Res. Qty. on Inbound Transfer");
        //RecItemP.Validate("Res. Qty. on Outbound Transfer", RecItemInboxP."Res. Qty. on Outbound Transfer");
        //RecItemP.Validate("Res. Qty. on Purch. Returns", RecItemInboxP."Res. Qty. on Purch. Returns");
        //RecItemP.Validate("Res. Qty. on Sales Returns", RecItemInboxP."Res. Qty. on Sales Returns");
        RecItemP.Validate("Stockout Warning", RecItemInboxP."Stockout Warning");
        RecItemP.Validate("Prevent Negative Inventory", RecItemInboxP."Prevent Negative Inventory");
        //RecItemP.Validate("Cost of Open Production Orders", RecItemInboxP."Cost of Open Production Orders");
        RecItemP.Validate("Application Wksh. User ID", RecItemInboxP."Application Wksh. User ID");
        RecItemP.Validate("Assembly Policy", RecItemInboxP."Assembly Policy");
        //RecItemP.Validate("Res. Qty. on Assembly Order", RecItemInboxP."Res. Qty. on Assembly Order");
        //RecItemP.Validate("Res. Qty. on  Asm. Comp.", RecItemInboxP."Res. Qty. on  Asm. Comp.");
        //RecItemP.Validate("Qty. on Assembly Order", RecItemInboxP."Qty. on Assembly Order");
        //RecItemP.Validate("Qty. on Asm. Component", RecItemInboxP."Qty. on Asm. Component");
        //RecItemP.Validate("Qty. on Job Order", RecItemInboxP."Qty. on Job Order");
        //RecItemP.Validate("Res. Qty. on Job Order", RecItemInboxP."Res. Qty. on Job Order");
        RecItemP.Validate(GTIN, RecItemInboxP.GTIN);
        RecItemP.Validate("Default Deferral Template Code", RecItemInboxP."Default Deferral Template Code");
        RecItemP.Validate("Low-Level Code", RecItemInboxP."Low-Level Code");
        RecItemP.Validate("Lot Size", RecItemInboxP."Lot Size");
        RecItemP.Validate("Serial Nos.", RecItemInboxP."Serial Nos.");
        RecItemP.Validate("Last Unit Cost Calc. Date", RecItemInboxP."Last Unit Cost Calc. Date");
        RecItemP.Validate("Rolled-up Material Cost", RecItemInboxP."Rolled-up Material Cost");
        RecItemP.Validate("Rolled-up Capacity Cost", RecItemInboxP."Rolled-up Capacity Cost");
        RecItemP.Validate("Scrap %", RecItemInboxP."Scrap %");
        RecItemP.Validate("Inventory Value Zero", RecItemInboxP."Inventory Value Zero");
        RecItemP.Validate("Discrete Order Quantity", RecItemInboxP."Discrete Order Quantity");
        RecItemP.Validate("Minimum Order Quantity", RecItemInboxP."Minimum Order Quantity");
        RecItemP.Validate("Maximum Order Quantity", RecItemInboxP."Maximum Order Quantity");
        RecItemP.Validate("Safety Stock Quantity", RecItemInboxP."Safety Stock Quantity");
        RecItemP.Validate("Order Multiple", RecItemInboxP."Order Multiple");
        RecItemP.Validate("Safety Lead Time", RecItemInboxP."Safety Lead Time");
        RecItemP.Validate("Flushing Method", RecItemInboxP."Flushing Method");
        RecItemP.Validate("Replenishment System", RecItemInboxP."Replenishment System");
        //RecItemP.Validate("Scheduled Receipt (Qty.)", RecItemInboxP."Scheduled Receipt (Qty.)");
        // RecItemP.Validate("Scheduled Need (Qty.)", RecItemInboxP.);
        RecItemP.Validate("Rounding Precision", RecItemInboxP."Rounding Precision");
        RecItemP.Validate("Bin Filter", RecItemInboxP."Bin Filter");
        RecItemP.Validate("Variant Filter", RecItemInboxP."Variant Filter");
        RecItemP.Validate("Sales Unit of Measure", RecItemInboxP."Sales Unit of Measure");
        RecItemP.Validate("Purch. Unit of Measure", RecItemInboxP."Purch. Unit of Measure");
        RecItemP.Validate("Unit of Measure Filter", RecItemInboxP."Unit of Measure Filter");
        RecItemP.Validate("Time Bucket", RecItemInboxP."Time Bucket");
        //RecItemP.Validate("Reserved Qty. on Prod. Order", RecItemInboxP."Reserved Qty. on Prod. Order");
        //RecItemP.Validate("Res. Qty. on Prod. Order Comp.", RecItemInboxP."Res. Qty. on Prod. Order Comp.");
        //RecItemP.Validate("Res. Qty. on Req. Line", RecItemInboxP."Res. Qty. on Req. Line");
        RecItemP.Validate("Reordering Policy", RecItemInboxP."Reordering Policy");
        RecItemP.Validate("Include Inventory", RecItemInboxP."Include Inventory");
        RecItemP.Validate("Manufacturing Policy", RecItemInboxP."Manufacturing Policy");
        RecItemP.Validate("Rescheduling Period", RecItemInboxP."Rescheduling Period");
        RecItemP.Validate("Lot Accumulation Period", RecItemInboxP."Lot Accumulation Period");
        RecItemP.Validate("Dampener Period", RecItemInboxP."Dampener Period");
        RecItemP.Validate("Dampener Quantity", RecItemInboxP."Dampener Quantity");
        RecItemP.Validate("Overflow Level", RecItemInboxP."Overflow Level");
        //RecItemP.Validate("Planning Transfer Ship. (Qty).", RecItemInboxP."Planning Transfer Ship. (Qty).");
        //RecItemP.Validate("Planning Worksheet (Qty.)", RecItemInboxP."Planning Worksheet (Qty.)");
        //RecItemP.Validate("Stockkeeping Unit Exists", RecItemInboxP."Stockkeeping Unit Exists");
        RecItemP.Validate("Manufacturer Code", RecItemInboxP."Manufacturer Code");
        RecItemP.Validate("Item Category Code", RecItemInboxP."Item Category Code");
        RecItemP.Validate("Created From Nonstock Item", RecItemInboxP."Created From Nonstock Item");
        //  RecItemP.Validate("Product Group Code" RecItemInboxP.);
        //RecItemP.Validate("Substitutes Exist", RecItemInboxP."Substitutes Exist");
        //RecItemP.Validate("Qty. in Transit", RecItemInboxP."Qty. in Transit");
        //RecItemP.Validate("Trans. Ord. Receipt (Qty.)", RecItemInboxP."Trans. Ord. Receipt (Qty.)");
        //RecItemP.Validate("Trans. Ord. Shipment (Qty.)", RecItemInboxP."Trans. Ord. Shipment (Qty.)");
        RecItemP.Validate("Purchasing Code", RecItemInboxP."Purchasing Code");
        //RecItemP.Validate("Qty. Assigned to ship", RecItemInboxP."Qty. Assigned to ship");
        //RecItemP.Validate("Qty. Picked", RecItemInboxP."Qty. Picked");
        RecItemP.Validate("Service Item Group", RecItemInboxP."Service Item Group");
        //RecItemP.Validate("Qty. on Service Order", RecItemInboxP."Qty. on Service Order");
        //RecItemP.Validate("Res. Qty. on Service Orders", RecItemInboxP."Res. Qty. on Service Orders");
        RecItemP.Validate("Item Tracking Code", RecItemInboxP."Item Tracking Code");
        RecItemP.Validate("Lot Nos.", RecItemInboxP."Lot Nos.");
        RecItemP.Validate("Expiration Calculation", RecItemInboxP."Expiration Calculation");
        RecItemP.Validate("Lot No. Filter", RecItemInboxP."Lot No. Filter");
        RecItemP.Validate("Serial No. Filter", RecItemInboxP."Serial No. Filter");
        RecItemP.Validate("Package No. Filter", RecItemInboxP."Package No. Filter");
        //RecItemP.Validate("Qty. on Purch. Return", RecItemInboxP."Qty. on Purch. Return");
        //RecItemP.Validate("Qty. on Sales Return", RecItemInboxP."Qty. on Sales Return");
        //RecItemP.Validate("No. of Substitutes", RecItemInboxP."No. of Substitutes");
        RecItemP.Validate("Warehouse Class Code", RecItemInboxP."Warehouse Class Code");
        RecItemP.Validate("Special Equipment Code", RecItemInboxP."Special Equipment Code");
        RecItemP.Validate("Put-away Template Code", RecItemInboxP."Put-away Template Code");
        RecItemP.Validate("Put-away Unit of Measure Code", RecItemInboxP."Put-away Unit of Measure Code");
        RecItemP.Validate("Phys Invt Counting Period Code", RecItemInboxP."Phys Invt Counting Period Code");
        RecItemP.Validate("Last Counting Period Update", RecItemInboxP."Last Counting Period Update");
        //RecItemP.Validate("Last Phys. Invt. Date", RecItemInboxP."Last Phys. Invt. Date");
        RecItemP.Validate("Use Cross-Docking", RecItemInboxP."Use Cross-Docking");
        RecItemP.Validate("Next Counting Start Date", RecItemInboxP."Next Counting Start Date");
        RecItemP.Validate("Next Counting End Date", RecItemInboxP."Next Counting End Date");
        //RecItemP.Validate("Identifier Code", RecItemInboxP."Identifier Code");
        //  RecItemP.Validate(Id, RecItemInboxP.);
        RecItemP.Validate("Unit of Measure Id", RecItemInboxP."Unit of Measure Id");
        //RecItemP.Validate("Tax Group Id", RecItemInboxP."Tax Group Id");
        RecItemP.Validate("Sales Blocked", RecItemInboxP."Sales Blocked");
        RecItemP.Validate("Purchasing Blocked", RecItemInboxP."Purchasing Blocked");
        //RecItemP.Validate("Item Category Id", RecItemInboxP."Item Category Id");
        RecItemP.Validate("Over-Receipt Code", RecItemInboxP."Over-Receipt Code");
        /*RecItemP.Validate("Duty Class", RecItemInboxP."Duty Class");
        RecItemP.Validate("Consumptions (Qty.)", RecItemInboxP."Consumptions (Qty.)");
        RecItemP.Validate("Outputs (Qty.)", RecItemInboxP."Outputs (Qty.)");
        RecItemP.Validate("Rel. Scheduled Receipt (Qty.)", RecItemInboxP."Rel. Scheduled Receipt (Qty.)");
        RecItemP.Validate("Rel. Scheduled Need (Qty.)", RecItemInboxP."Rel. Scheduled Need (Qty.)");
        //RecItemP.Validate("SAT Item Classification", RecItemInboxP.);*/
        RecItemP.Validate("Routing No.", RecItemInboxP."Routing No.");
        RecItemP.Validate("Production BOM No.", RecItemInboxP."Production BOM No.");
        RecItemP.Validate("Single-Level Material Cost", RecItemInboxP."Single-Level Material Cost");
        RecItemP.Validate("Single-Level Capacity Cost", RecItemInboxP."Single-Level Capacity Cost");
        RecItemP.Validate("Single-Level Subcontrd. Cost", RecItemInboxP."Single-Level Subcontrd. Cost");
        RecItemP.Validate("Single-Level Cap. Ovhd Cost", RecItemInboxP."Single-Level Cap. Ovhd Cost");
        RecItemP.Validate("Single-Level Mfg. Ovhd Cost", RecItemInboxP."Single-Level Mfg. Ovhd Cost");
        RecItemP.Validate("Overhead Rate", RecItemInboxP."Overhead Rate");
        RecItemP.Validate("Rolled-up Subcontracted Cost", RecItemInboxP."Rolled-up Subcontracted Cost");
        RecItemP.Validate("Rolled-up Mfg. Ovhd Cost", RecItemInboxP."Rolled-up Mfg. Ovhd Cost");
        RecItemP.Validate("Rolled-up Cap. Overhead Cost", RecItemInboxP."Rolled-up Cap. Overhead Cost");
        RecItemP.Validate("Planning Issues (Qty.)", RecItemInboxP."Planning Issues (Qty.)");
        RecItemP.Validate("Planning Receipt (Qty.)", RecItemInboxP."Planning Receipt (Qty.)");
        RecItemP.Validate("Planned Order Receipt (Qty.)", RecItemInboxP."Planned Order Receipt (Qty.)");
        RecItemP.Validate("FP Order Receipt (Qty.)", RecItemInboxP."FP Order Receipt (Qty.)");
        RecItemP.Validate("Rel. Order Receipt (Qty.)", RecItemInboxP."Rel. Order Receipt (Qty.)");
        RecItemP.Validate("Planning Release (Qty.)", RecItemInboxP."Planning Release (Qty.)");
        RecItemP.Validate("Planned Order Release (Qty.)", RecItemInboxP."Planned Order Release (Qty.)");
        RecItemP.Validate("Purch. Req. Receipt (Qty.)", RecItemInboxP."Purch. Req. Receipt (Qty.)");
        RecItemP.Validate("Purch. Req. Release (Qty.)", RecItemInboxP."Purch. Req. Release (Qty.)");
        RecItemP.Validate("Order Tracking Policy", RecItemInboxP."Order Tracking Policy");
        RecItemP.Validate("Prod. Forecast Quantity (Base)", RecItemInboxP."Prod. Forecast Quantity (Base)");
        RecItemP.Validate("Production Forecast Name", RecItemInboxP."Production Forecast Name");
        RecItemP.Validate("Component Forecast", RecItemInboxP."Component Forecast");
        RecItemP.Validate("Qty. on Prod. Order", RecItemInboxP."Qty. on Prod. Order");
        RecItemP.Validate("Qty. on Component Lines", RecItemInboxP."Qty. on Component Lines");
        RecItemP.Validate(Critical, RecItemInboxP.Critical);
        RecItemP.Validate("Common Item No.", RecItemInboxP."Common Item No.");

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
