page 50201 "IT BlobStorage Container List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "IT Blob Storage Containers";
    Caption = 'GM Blob Storage Container List';
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {

            repeater(Containers)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Modified"; Rec."Last Modified") { ApplicationArea = All; }
                field("Lease State"; Rec."Lease State") { ApplicationArea = All; }
                field("Lease Status"; Rec."Lease Status") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("GetContainers")
            {
                ApplicationArea = All;
                Caption = 'Refresh Containers';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Refresh;

                trigger OnAction()
                begin
                    ReloadContainers();
                end;
            }
        }
    }


    local procedure ReloadContainers()
    var
        blobServiceApi: Codeunit "Blob Service API GM";
    begin
        Rec.DeleteAll();
        blobServiceApi.ListContainers();
    end;
}