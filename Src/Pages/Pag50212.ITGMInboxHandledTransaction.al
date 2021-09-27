page 50212 "IT GM Inbox Handled Trans."
{

    ApplicationArea = All;
    Caption = 'GM Inbox Handled Transaction';
    PageType = Worksheet;
    SourceTable = "IT GM Inbox Handled Trans.";
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
                    RecGL: Record "IT GM Inbox Handled G/L Acc.";
                    RecItem: Record "IT GM Inbox Handled Items";
                    RecDimension: Record "IT GM Inbox Handled Dimension";
                begin
                    case Rec."Source Type" of
                        Rec."Source Type"::"G/L Account":
                            begin
                                Clear(RecGL);
                                RecGL.SetRange("No.", Rec."Document No.");
                                RecGL.SetRange("Inbox Entry No.", Rec."Entry No.");
                                if RecGL.FindFirst() then;
                                Page.RunModal(Page::"IT GM Inbox Handled G/L Acc.", RecGL);
                            end;

                        Rec."Source Type"::Item:
                            begin
                                Clear(RecItem);
                                RecItem.SetRange("No.", Rec."Document No.");
                                RecItem.SetRange("Inbox Entry No.", Rec."Entry No.");
                                if RecItem.FindFirst() then;
                                Page.RunModal(Page::"IT GM Inbox Handled Items", RecItem);
                            end;
                        Rec."Source Type"::"Dimension Value":
                            begin
                                Clear(RecDimension);
                                RecDimension.SetRange(Code, Rec."Document No.");
                                RecDimension.SetRange("Dimension Code", Rec."Primary Key 2");
                                RecDimension.SetRange("Inbox Entry No.", Rec."Entry No.");
                                if RecDimension.FindFirst() then;
                                Page.RunModal(Page::"IT GM Inbox Handled Dimension", RecDimension);
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
