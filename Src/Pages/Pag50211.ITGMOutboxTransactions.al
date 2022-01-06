page 50211 "IT GM Outbox Transactions"
{

    ApplicationArea = All;
    Caption = 'GM Outbox Transactions';
    PageType = Worksheet;
    SourceTable = "IT GM Outbox Transactions";
    UsageCategory = Administration;
    PromotedActionCategories = 'New,Process,Report,Navigate';
    layout
    {
        area(content)
        {
            group(Filters)
            {
                ShowCaption = false;
                field(SourceTypeFilter; SourceTypeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Source Type Filter';
                    trigger OnValidate()
                    begin
                        Rec.SetRange("Source Type");
                        case SourceTypeFilter of
                            SourceTypeFilter::Item:
                                Rec.SetRange("Source Type", Rec."Source Type"::Item);
                            SourceTypeFilter::"G/L Account":
                                Rec.SetRange("Source Type", Rec."Source Type"::"G/L Account");
                            SourceTypeFilter::"Dimension Value":
                                Rec.SetRange("Source Type", Rec."Source Type"::"Dimension Value");
                        end;
                        ShowLinesOnAfterValidate();
                    end;
                }
                field(StatusFilter; StatusFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Status Filter';

                    trigger OnValidate()
                    begin
                        Rec.SetRange(Status);
                        case StatusFilter of
                            StatusFilter::Pending:
                                Rec.SetRange(Status, Rec.Status::Pending);
                            StatusFilter::Synced:
                                Rec.SetRange(Status, Rec.Status::Pending);
                        end;
                        ShowLinesOnAfterValidate();
                    end;
                }
            }
            repeater(General)
            {
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field';
                    ApplicationArea = All;
                }
                field("Source Entity"; Rec."Source Entity")
                {
                    ToolTip = 'Specifies the value of the Source Entity field';
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the value of the Source Type field';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send")
            {
                ApplicationArea = All;
                Image = SetupAddressCountryRegion;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ReplicateData: Codeunit "IT GM Replicate Data";
                    RecOutbox: Record "IT GM Outbox Transactions";
                begin
                    Clear(RecOutbox);
                    CurrPage.SetSelectionFilter(RecOutbox);
                    if RecOutbox.FindSet() then begin
                        //repeat
                        ReplicateData.MoveToInbox(RecOutbox);
                        //until RecOutbox.Next() = 0;
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action("Details")
            {
                ApplicationArea = All;
                Image = Card;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Category4;
                trigger OnAction()
                var
                    RecGL: Record "IT GM Outbox G/L Account";
                    RecItem: Record "IT GM Outbox Items";
                    RecDimension: Record "IT GM Outbox Dimension Value";
                begin
                    case Rec."Source Type" of
                        Rec."Source Type"::"G/L Account":
                            begin
                                Clear(RecGL);
                                RecGL.SetRange("No.", Rec."Document No.");
                                RecGL.SetRange("Outbox Entry No.", Rec."Entry No.");
                                if RecGL.FindFirst() then;
                                Page.RunModal(Page::"IT GM Outbox G/L Account", RecGL);
                            end;

                        Rec."Source Type"::Item:
                            begin
                                Clear(RecItem);
                                RecItem.SetRange("No.", Rec."Document No.");
                                RecItem.SetRange("Outbox Entry No.", Rec."Entry No.");
                                if RecItem.FindFirst() then;
                                Page.RunModal(Page::"IT GM Outbox Items", RecItem);
                            end;
                        Rec."Source Type"::"Dimension Value":
                            begin
                                Clear(RecDimension);
                                RecDimension.SetRange(Code, Rec."Document No.");
                                RecDimension.SetRange("Dimension Code", Rec."Primary Key 2");
                                RecDimension.SetRange("Outbox Entry No.", Rec."Entry No.");
                                if RecDimension.FindFirst() then;
                                Page.RunModal(Page::"IT GM Outbox Dimension Values", RecDimension);
                            end;
                    end;
                end;
            }
        }
    }
    local procedure ShowLinesOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    var
        SourceTypeFilter: Enum "IT Data Replication Fn";
        StatusFilter: Option " ",Pending,Synced;
}
