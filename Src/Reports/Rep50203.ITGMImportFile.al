report 50203 "IT GM Import File"
{
    Caption = 'IT GM Import File';
    ProcessingOnly = true;
    UseRequestPage = true;

    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(FileNameControl; FileName)
                    {
                        ApplicationArea = Suite;
                        Caption = 'File Name';
                        ToolTip = 'Specifies the name of the file that you want to use for consolidation.';
                        Lookup = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            BlobLists: Record "IT Blob Storage Blob Lists";
                            BlobListsPage: Page "IT BlobStorage Blob List";
                            BlobService: Codeunit "Blob Service API GM";
                        begin
                            RecCompanyInfo.GET;
                            RecCompanyInfo.TestField("Root Container GM");
                            Clear(BlobService);
                            BlobService.ListBlobs(RecCompanyInfo."Root Container GM");
                            Clear(BlobLists);
                            BlobLists.SetRange(Container, RecCompanyInfo."Root Container GM");
                            Clear(BlobListsPage);
                            BlobListsPage.SetTableView(BlobLists);
                            BlobListsPage.LookupMode(true);
                            Commit();
                            if BlobListsPage.RunModal() IN [Action::OK, Action::LookupOK] then begin
                                BlobListsPage.GetRecord(BlobLists);
                                FileName := BlobLists.Name;
                            end;
                        end;
                    }
                }
            }
        }

        trigger OnOpenPage()
        var
            BlobLists: Record "IT Blob Storage Blob Lists";
            BlobService: Codeunit "Blob Service API GM";
            NoSeriesMgmt: Codeunit NoSeriesManagement;
        begin
            RecCompanyInfo.GET;
            RecCompanyInfo.TestField("Root Container GM");
            Clear(BlobService);
            BlobService.ListBlobs(RecCompanyInfo."Root Container GM");
            Clear(BlobLists);
            BlobLists.SetRange(Container, RecCompanyInfo."Root Container GM");
            BlobLists.FindFirst();
            FileName := BlobLists.Name;
        end;
    }


    trigger OnPostReport()
    var
        ReplicateData: Codeunit "IT GM Replicate Data";
        BlobLists: Record "IT Blob Storage Blob Lists";

    begin
        if FileName = '' then
            Error('Please select a file from Blob Storage');

        Clear(BlobLists);
        BlobLists.SetRange(Container, RecCompanyInfo."Root Container GM");
        BlobLists.SetRange(Name, FileName);
        if not BlobLists.FindFirst() then
            Error('Please select a file from Blob Storage List');



        Clear(ReplicateData);
        ReplicateData.ImportFromBlobStorage(FileName);
    end;

    trigger OnInitReport()
    begin
        RecCompanyInfo.GET;
    end;

    var
        FileName: Text;
        RecCompanyInfo: Record "Company Information";
}
