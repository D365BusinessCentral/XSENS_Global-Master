xmlport 50200 "IT GM Outbox Export"
{
    Caption = 'IT GM Outbox Export';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(GMTransaction)
        {
            tableelement(ITGMTransactions; "IT GM Outbox Transactions")
            {
                fieldelement(DocumentNo; ITGMTransactions."Document No.")
                {
                }
                fieldelement(SourceEntity; ITGMTransactions."Source Entity")
                {
                }
                fieldelement(SourceType; ITGMTransactions."Source Type")
                {
                }
                fieldelement(CreationDate; ITGMTransactions."Creation Date")
                {
                }
                fieldelement(PrimaryKey2; ITGMTransactions."Primary Key 2")
                {
                }
                fieldelement(Status; ITGMTransactions.Status)
                {
                }
                textelement(GMGLAccount)
                {
                    MinOccurs = Zero;
                    tableelement("GLAccount"; "IT GM Outbox G/L Account")
                    {
                        MinOccurs = Zero;
                        LinkTable = ITGMTransactions;
                        LinkFields = "No." = field("Document No."), "Source Type" = field("Source Type"), "Outbox Entry No." = field("Entry No.");
                        fieldelement(No; GLAccount."No.")
                        {
                        }
                        fieldelement(No2; GLAccount."No. 2")
                        {
                        }
                        fieldelement(Name; GLAccount.Name)
                        {
                        }
                        fieldelement(APIAccountType; GLAccount."API Account Type")
                        {
                        }
                        fieldelement(AccountCategory; GLAccount."Account Category")
                        {
                        }
                        fieldelement(AccountSubcategoryDescript; GLAccount."Account Subcategory Descript.")
                        {
                        }
                        fieldelement(AccountSubcategoryEntryNo; GLAccount."Account Subcategory Entry No.")
                        {
                        }
                        fieldelement(AccountType; GLAccount."Account Type")
                        {
                        }
                        fieldelement(AddCurrencyBalanceatDate; GLAccount."Add.-Currency Balance at Date")
                        {
                        }
                        fieldelement(AddCurrencyCreditAmount; GLAccount."Add.-Currency Credit Amount")
                        {
                        }
                        fieldelement(AddCurrencyDebitAmount; GLAccount."Add.-Currency Debit Amount")
                        {
                        }
                        fieldelement(AdditionalCurrencyBalance; GLAccount."Additional-Currency Balance")
                        {
                        }
                        fieldelement(AdditionalCurrencyNetChange; GLAccount."Additional-Currency Net Change")
                        {
                        }
                        fieldelement(Balance; GLAccount.Balance)
                        {
                        }
                        fieldelement(BalanceatDate; GLAccount."Balance at Date")
                        {
                        }
                        fieldelement(BudgetedAmount; GLAccount."Budgeted Amount")
                        {
                        }
                        fieldelement(BudgetedCreditAmount; GLAccount."Budgeted Credit Amount")
                        {
                        }
                        fieldelement(BudgetedDebitAmount; GLAccount."Budgeted Debit Amount")
                        {
                        }
                        fieldelement(BusinessUnitFilter; GLAccount."Business Unit Filter")
                        {
                        }
                        fieldelement(Comment; GLAccount.Comment)
                        {
                        }
                        fieldelement(ConsolCreditAcc; GLAccount."Consol. Credit Acc.")
                        {
                        }
                        fieldelement(ConsolDebitAcc; GLAccount."Consol. Debit Acc.")
                        {
                        }
                        fieldelement(ConsolTranslationMethod; GLAccount."Consol. Translation Method")
                        {
                        }
                        fieldelement(CostTypeNo; GLAccount."Cost Type No.")
                        {
                        }
                        fieldelement(CreditAmount; GLAccount."Credit Amount")
                        {
                        }
                        fieldelement(DebitAmount; GLAccount."Debit Amount")
                        {
                        }
                        fieldelement(DefaultICPartnerGLAccNo; GLAccount."Default IC Partner G/L Acc. No")
                        {
                        }
                        fieldelement(DimensionSetIDFilter; GLAccount."Dimension Set ID Filter")
                        {
                        }
                        fieldelement(DirectPosting; GLAccount."Direct Posting")
                        {
                        }
                        fieldelement(ExchangeRateAdjustment; GLAccount."Exchange Rate Adjustment")
                        {
                        }
                        fieldelement(GenBusPostingGroup; GLAccount."Gen. Bus. Posting Group")
                        {
                        }
                        fieldelement(GenPostingType; GLAccount."Gen. Posting Type")
                        {
                        }
                        fieldelement(GenProdPostingGroup; GLAccount."Gen. Prod. Posting Group")
                        {
                        }
                        fieldelement(GlobalDimension1Code; GLAccount."Global Dimension 1 Code")
                        {
                        }
                        fieldelement(GlobalDimension1Filter; GLAccount."Global Dimension 1 Filter")
                        {
                        }
                        fieldelement(GlobalDimension2Code; GLAccount."Global Dimension 2 Code")
                        {
                        }
                        fieldelement(GlobalDimension2Filter; GLAccount."Global Dimension 2 Filter")
                        {
                        }
                        fieldelement(IncomeBalance; GLAccount."Income/Balance")
                        {
                        }
                        fieldelement(Indentation; GLAccount.Indentation)
                        {
                        }
                        fieldelement(NetChange; GLAccount."Net Change")
                        {
                        }
                        fieldelement(NewPage; GLAccount."New Page")
                        {
                        }
                        fieldelement(NoofBlankLines; GLAccount."No. of Blank Lines")
                        {
                        }
                        fieldelement(OmitDefaultDescrinJnl; GLAccount."Omit Default Descr. in Jnl.")
                        {
                        }
                        fieldelement(ReconciliationAccount; GLAccount."Reconciliation Account")
                        {
                        }
                        // fieldelement(SATAccountCode; GLAccount."SAT Account Code")
                        // {
                        // }
                        fieldelement(SearchName; GLAccount."Search Name")
                        {
                        }
                        fieldelement(Totaling; GLAccount.Totaling)
                        {
                        }
                        fieldelement(VATBusPostingGroup; GLAccount."VAT Bus. Posting Group")
                        {
                        }
                        fieldelement(VATProdPostingGroup; GLAccount."VAT Prod. Posting Group")
                        {
                        }
                        fieldelement(GLSource; GLAccount."Source Type")
                        {
                        }
                        textelement(GLDimensions)
                        {
                            MinOccurs = Zero;
                            tableelement(GLDimension; "IT GM Outbox Default Dimens.")
                            {
                                LinkTable = GLAccount;
                                MinOccurs = Zero;
                                LinkFields = "Table ID" = const(15), "No." = field("No."), "Outbox Entry No." = field("Outbox Entry No.");
                                fieldelement(TableID; GLDimension."Table ID")
                                {
                                }
                                fieldelement(No; GLDimension."No.")
                                {
                                }
                                fieldelement(ParentId; GLDimension.ParentId)
                                {
                                }
                                fieldelement(ParentType; GLDimension."Parent Type")
                                {
                                }
                                fieldelement(AllowedValuesFilter; GLDimension."Allowed Values Filter")
                                {
                                }
                                fieldelement(DimensionCode; GLDimension."Dimension Code")
                                {
                                }
                                fieldelement(DimensionValueCode; GLDimension."Dimension Value Code")
                                {
                                }
                                fieldelement(DimensionId; GLDimension.DimensionId)
                                {
                                }
                                fieldelement(DimensionValueId; GLDimension.DimensionValueId)
                                {
                                }
                                fieldelement(MultiSelectionAction; GLDimension."Multi Selection Action")
                                {
                                }
                                fieldelement(ValuePosting; GLDimension."Value Posting")
                                {
                                }

                            }
                        }
                    }
                }
                textelement(GMItems)
                {
                    MinOccurs = Zero;
                    tableelement("Items"; "IT GM Outbox Items")
                    {
                        LinkTable = ITGMTransactions;
                        MinOccurs = Zero;
                        LinkFields = "No." = field("Document No."), "Source Type" = field("Source Type"), "Outbox Entry No." = field("Entry No.");
                        fieldelement(No; Items."No.")
                        {
                        }
                        fieldelement(No2; Items."No. 2")
                        {
                        }
                        fieldelement(Description; Items.Description)
                        {
                        }
                        fieldelement(Description2; Items."Description 2")
                        {
                        }
                        fieldelement(AllowInvoiceDisc; Items."Allow Invoice Disc.")
                        {
                        }
                        fieldelement(AllowOnlineAdjustment; Items."Allow Online Adjustment")
                        {
                        }
                        fieldelement(AlternativeItemNo; Items."Alternative Item No.")
                        {
                        }
                        fieldelement(ApplicationWkshUserID; Items."Application Wksh. User ID")
                        {
                        }
                        fieldelement(AssemblyBOM; Items."Assembly BOM")
                        {
                        }
                        fieldelement(AssemblyPolicy; Items."Assembly Policy")
                        {
                        }
                        fieldelement(AutomaticExtTexts; Items."Automatic Ext. Texts")
                        {
                        }
                        fieldelement(BaseUnitofMeasure; Items."Base Unit of Measure")
                        {
                        }
                        fieldelement(BinFilter; Items."Bin Filter")
                        {
                        }
                        fieldelement(BlockReason; Items."Block Reason")
                        {
                        }
                        fieldelement(Blocked; Items.Blocked)
                        {
                        }
                        fieldelement(BudgetProfit; Items."Budget Profit")
                        {
                        }
                        fieldelement(BudgetQuantity; Items."Budget Quantity")
                        {
                        }
                        fieldelement(BudgetedAmount; Items."Budgeted Amount")
                        {
                        }
                        fieldelement(COGSLCY; Items."COGS (LCY)")
                        {
                        }
                        fieldelement(Comment; Items.Comment)
                        {
                        }
                        fieldelement(CommissionGroup; Items."Commission Group")
                        {
                        }
                        fieldelement(CommonItemNo; Items."Common Item No.")
                        {
                        }
                        fieldelement(ComponentForecast; Items."Component Forecast")
                        {
                        }
                        fieldelement(ConsumptionsQty; Items."Consumptions (Qty.)")
                        {
                        }
                        fieldelement(CostisAdjusted; Items."Cost is Adjusted")
                        {
                        }
                        fieldelement(CostisPostedtoGL; Items."Cost is Posted to G/L")
                        {
                        }
                        fieldelement(CostofOpenProductionOrders; Items."Cost of Open Production Orders")
                        {
                        }
                        fieldelement(CostingMethod; Items."Costing Method")
                        {
                        }
                        fieldelement(CountryRegionPurchasedCode; Items."Country/Region Purchased Code")
                        {
                        }
                        fieldelement(CountryRegionofOriginCode; Items."Country/Region of Origin Code")
                        {
                        }
                        fieldelement(CreatedFromNonstockItem; Items."Created From Nonstock Item")
                        {
                        }
                        fieldelement(Critical; Items.Critical)
                        {
                        }
                        fieldelement(DampenerPeriod; Items."Dampener Period")
                        {
                        }
                        fieldelement(DampenerQuantity; Items."Dampener Quantity")
                        {
                        }
                        fieldelement(DateFilter; Items."Date Filter")
                        {
                        }
                        fieldelement(DefaultDeferralTemplateCode; Items."Default Deferral Template Code")
                        {
                        }
                        fieldelement(DiscreteOrderQuantity; Items."Discrete Order Quantity")
                        {
                        }
                        fieldelement(DropShipmentFilter; Items."Drop Shipment Filter")
                        {
                        }
                        fieldelement(Durability; Items.Durability)
                        {
                        }
                        fieldelement(DutyClass; Items."Duty Class")
                        {
                        }
                        fieldelement(DutyCode; Items."Duty Code")
                        {
                        }
                        fieldelement(DutyDue; Items."Duty Due %")
                        {
                        }
                        fieldelement(DutyUnitConversion; Items."Duty Unit Conversion")
                        {
                        }
                        fieldelement(ExpirationCalculation; Items."Expiration Calculation")
                        {
                        }
                        fieldelement(FPOrderReceiptQty; Items."FP Order Receipt (Qty.)")
                        {
                        }
                        fieldelement(FlushingMethod; Items."Flushing Method")
                        {
                        }
                        fieldelement(FreightType; Items."Freight Type")
                        {
                        }
                        fieldelement(GTIN; Items.GTIN)
                        {
                        }
                        fieldelement(GenProdPostingGroup; Items."Gen. Prod. Posting Group")
                        {
                        }
                        fieldelement(GlobalDimension1Code; Items."Global Dimension 1 Code")
                        {
                        }
                        fieldelement(GlobalDimension1Filter; Items."Global Dimension 1 Filter")
                        {
                        }
                        fieldelement(GlobalDimension2Code; Items."Global Dimension 2 Code")
                        {
                        }
                        fieldelement(GlobalDimension2Filter; Items."Global Dimension 2 Filter")
                        {
                        }
                        fieldelement(GrossWeight; Items."Gross Weight")
                        {
                        }
                        fieldelement(IdentifierCode; Items."Identifier Code")
                        {
                        }
                        fieldelement(IncludeInventory; Items."Include Inventory")
                        {
                        }
                        fieldelement(IndirectCost; Items."Indirect Cost %")
                        {
                        }
                        fieldelement(Inventory; Items.Inventory)
                        {
                        }
                        fieldelement(InventoryPostingGroup; Items."Inventory Posting Group")
                        {
                        }
                        fieldelement(InventoryValueZero; Items."Inventory Value Zero")
                        {
                        }
                        fieldelement(ItemCategoryCode; Items."Item Category Code")
                        {
                        }
                        fieldelement(ItemCategoryId; Items."Item Category Id")
                        {
                        }
                        fieldelement(ItemDiscGroup; Items."Item Disc. Group")
                        {
                        }
                        fieldelement(ItemTrackingCode; Items."Item Tracking Code")
                        {
                        }
                        fieldelement(LastCountingPeriodUpdate; Items."Last Counting Period Update")
                        {
                        }
                        fieldelement(LastDateModified; Items."Last Date Modified")
                        {
                        }
                        fieldelement(LastDateTimeModified; Items."Last DateTime Modified")
                        {
                        }
                        fieldelement(LastDirectCost; Items."Last Direct Cost")
                        {
                        }
                        fieldelement(LastPhysInvtDate; Items."Last Phys. Invt. Date")
                        {
                        }
                        fieldelement(LastTimeModified; Items."Last Time Modified")
                        {
                        }
                        fieldelement(LastUnitCostCalcDate; Items."Last Unit Cost Calc. Date")
                        {
                        }
                        fieldelement(LeadTimeCalculation; Items."Lead Time Calculation")
                        {
                        }
                        fieldelement(LocationFilter; Items."Location Filter")
                        {
                        }
                        fieldelement(LotAccumulationPeriod; Items."Lot Accumulation Period")
                        {
                        }
                        fieldelement(LotNoFilter; Items."Lot No. Filter")
                        {
                        }
                        fieldelement(LotNos; Items."Lot Nos.")
                        {
                        }
                        fieldelement(LotSize; Items."Lot Size")
                        {
                        }
                        fieldelement(LowLevelCode; Items."Low-Level Code")
                        {
                        }
                        fieldelement(ManufacturerCode; Items."Manufacturer Code")
                        {
                        }
                        fieldelement(ManufacturingPolicy; Items."Manufacturing Policy")
                        {
                        }
                        fieldelement(MaximumInventory; Items."Maximum Inventory")
                        {
                        }
                        fieldelement(MaximumOrderQuantity; Items."Maximum Order Quantity")
                        {
                        }
                        fieldelement(MinimumOrderQuantity; Items."Minimum Order Quantity")
                        {
                        }
                        fieldelement(NegativeAdjmtLCY; Items."Negative Adjmt. (LCY)")
                        {
                        }
                        fieldelement(NegativeAdjmtQty; Items."Negative Adjmt. (Qty.)")
                        {
                        }
                        fieldelement(NetChange; Items."Net Change")
                        {
                        }
                        fieldelement(NetInvoicedQty; Items."Net Invoiced Qty.")
                        {
                        }
                        fieldelement(NetWeight; Items."Net Weight")
                        {
                        }
                        fieldelement(NextCountingEndDate; Items."Next Counting End Date")
                        {
                        }
                        fieldelement(NextCountingStartDate; Items."Next Counting Start Date")
                        {
                        }
                        fieldelement(NoSeries; Items."No. Series")
                        {
                        }
                        fieldelement(NoofSubstitutes; Items."No. of Substitutes")
                        {
                        }
                        fieldelement(OrderMultiple; Items."Order Multiple")
                        {
                        }
                        fieldelement(OrderTrackingPolicy; Items."Order Tracking Policy")
                        {
                        }
                        fieldelement(OutputsQty; Items."Outputs (Qty.)")
                        {
                        }
                        fieldelement(OverReceiptCode; Items."Over-Receipt Code")
                        {
                        }
                        fieldelement(OverflowLevel; Items."Overflow Level")
                        {
                        }
                        fieldelement(OverheadRate; Items."Overhead Rate")
                        {
                        }
                        fieldelement(PackageNoFilter; Items."Package No. Filter")
                        {
                        }
                        fieldelement(PhysInvtCountingPeriodCode; Items."Phys Invt Counting Period Code")
                        {
                        }
                        fieldelement(PlannedOrderReceiptQty; Items."Planned Order Receipt (Qty.)")
                        {
                        }
                        fieldelement(PlannedOrderReleaseQty; Items."Planned Order Release (Qty.)")
                        {
                        }
                        fieldelement(PlanningIssuesQty; Items."Planning Issues (Qty.)")
                        {
                        }
                        fieldelement(PlanningReceiptQty; Items."Planning Receipt (Qty.)")
                        {
                        }
                        fieldelement(PlanningReleaseQty; Items."Planning Release (Qty.)")
                        {
                        }
                        fieldelement(PlanningTransferShipQty; Items."Planning Transfer Ship. (Qty).")
                        {
                        }
                        fieldelement(PlanningWorksheetQty; Items."Planning Worksheet (Qty.)")
                        {
                        }
                        fieldelement(PositiveAdjmtLCY; Items."Positive Adjmt. (LCY)")
                        {
                        }
                        fieldelement(PositiveAdjmtQty; Items."Positive Adjmt. (Qty.)")
                        {
                        }
                        fieldelement(PreventNegativeInventory; Items."Prevent Negative Inventory")
                        {
                        }
                        fieldelement(PriceIncludesVAT; Items."Price Includes VAT")
                        {
                        }
                        fieldelement(PriceUnitConversion; Items."Price Unit Conversion")
                        {
                        }
                        fieldelement(PriceProfitCalculation; Items."Price/Profit Calculation")
                        {
                        }
                        fieldelement(ProdForecastQuantityBase; Items."Prod. Forecast Quantity (Base)")
                        {
                        }
                        fieldelement(ProductionBOMNo; Items."Production BOM No.")
                        {
                        }
                        fieldelement(ProductionForecastName; Items."Production Forecast Name")
                        {
                        }
                        fieldelement(Profit; Items."Profit %")
                        {
                        }
                        fieldelement(PurchReqReceiptQty; Items."Purch. Req. Receipt (Qty.)")
                        {
                        }
                        fieldelement(PurchReqReleaseQty; Items."Purch. Req. Release (Qty.)")
                        {
                        }
                        fieldelement(PurchUnitofMeasure; Items."Purch. Unit of Measure")
                        {
                        }
                        fieldelement(PurchasesLCY; Items."Purchases (LCY)")
                        {
                        }
                        fieldelement(PurchasesQty; Items."Purchases (Qty.)")
                        {
                        }
                        fieldelement(PurchasingBlocked; Items."Purchasing Blocked")
                        {
                        }
                        fieldelement(PurchasingCode; Items."Purchasing Code")
                        {
                        }
                        fieldelement(PutawayTemplateCode; Items."Put-away Template Code")
                        {
                        }
                        fieldelement(PutawayUnitofMeasureCode; Items."Put-away Unit of Measure Code")
                        {
                        }
                        fieldelement(QtyAssignedtoship; Items."Qty. Assigned to ship")
                        {
                        }
                        fieldelement(QtyPicked; Items."Qty. Picked")
                        {
                        }
                        fieldelement(QtyinTransit; Items."Qty. in Transit")
                        {
                        }
                        fieldelement(QtyonAsmComponent; Items."Qty. on Asm. Component")
                        {
                        }
                        fieldelement(QtyonAssemblyOrder; Items."Qty. on Assembly Order")
                        {
                        }
                        fieldelement(QtyonComponentLines; Items."Qty. on Component Lines")
                        {
                        }
                        fieldelement(QtyonJobOrder; Items."Qty. on Job Order")
                        {
                        }
                        fieldelement(QtyonProdOrder; Items."Qty. on Prod. Order")
                        {
                        }
                        fieldelement(QtyonPurchOrder; Items."Qty. on Purch. Order")
                        {
                        }
                        fieldelement(QtyonPurchReturn; Items."Qty. on Purch. Return")
                        {
                        }
                        fieldelement(QtyonSalesOrder; Items."Qty. on Sales Order")
                        {
                        }
                        fieldelement(QtyonSalesReturn; Items."Qty. on Sales Return")
                        {
                        }
                        fieldelement(QtyonServiceOrder; Items."Qty. on Service Order")
                        {
                        }
                        fieldelement(RelOrderReceiptQty; Items."Rel. Order Receipt (Qty.)")
                        {
                        }
                        fieldelement(RelScheduledNeedQty; Items."Rel. Scheduled Need (Qty.)")
                        {
                        }
                        fieldelement(RelScheduledReceiptQty; Items."Rel. Scheduled Receipt (Qty.)")
                        {
                        }
                        fieldelement(ReorderPoint; Items."Reorder Point")
                        {
                        }
                        fieldelement(ReorderQuantity; Items."Reorder Quantity")
                        {
                        }
                        fieldelement(ReorderingPolicy; Items."Reordering Policy")
                        {
                        }
                        fieldelement(ReplenishmentSystem; Items."Replenishment System")
                        {
                        }
                        fieldelement(ResQtyonAsmComp; Items."Res. Qty. on  Asm. Comp.")
                        {
                        }
                        fieldelement(ResQtyonAssemblyOrder; Items."Res. Qty. on Assembly Order")
                        {
                        }
                        fieldelement(ResQtyonInboundTransfer; Items."Res. Qty. on Inbound Transfer")
                        {
                        }
                        fieldelement(ResQtyonJobOrder; Items."Res. Qty. on Job Order")
                        {
                        }
                        fieldelement(ResQtyonOutboundTransfer; Items."Res. Qty. on Outbound Transfer")
                        {
                        }
                        fieldelement(ResQtyonProdOrderComp; Items."Res. Qty. on Prod. Order Comp.")
                        {
                        }
                        fieldelement(ResQtyonPurchReturns; Items."Res. Qty. on Purch. Returns")
                        {
                        }
                        fieldelement(ResQtyonReqLine; Items."Res. Qty. on Req. Line")
                        {
                        }
                        fieldelement(ResQtyonSalesReturns; Items."Res. Qty. on Sales Returns")
                        {
                        }
                        fieldelement(ResQtyonServiceOrders; Items."Res. Qty. on Service Orders")
                        {
                        }
                        fieldelement(ReschedulingPeriod; Items."Rescheduling Period")
                        {
                        }
                        fieldelement(Reserve; Items.Reserve)
                        {
                        }
                        fieldelement(ReservedQtyonInventory; Items."Reserved Qty. on Inventory")
                        {
                        }
                        fieldelement(ReservedQtyonProdOrder; Items."Reserved Qty. on Prod. Order")
                        {
                        }
                        fieldelement(ReservedQtyonPurchOrders; Items."Reserved Qty. on Purch. Orders")
                        {
                        }
                        fieldelement(ReservedQtyonSalesOrders; Items."Reserved Qty. on Sales Orders")
                        {
                        }
                        fieldelement(RolledupCapOverheadCost; Items."Rolled-up Cap. Overhead Cost")
                        {
                        }
                        fieldelement(RolledupCapacityCost; Items."Rolled-up Capacity Cost")
                        {
                        }
                        fieldelement(RolledupMaterialCost; Items."Rolled-up Material Cost")
                        {
                        }
                        fieldelement(RolledupMfgOvhdCost; Items."Rolled-up Mfg. Ovhd Cost")
                        {
                        }
                        fieldelement(RolledupSubcontractedCost; Items."Rolled-up Subcontracted Cost")
                        {
                        }
                        fieldelement(RoundingPrecision; Items."Rounding Precision")
                        {
                        }
                        fieldelement(RoutingNo; Items."Routing No.")
                        {
                        }
                        // fieldelement(SATItemClassification; Items."SAT Item Classification")
                        // {
                        // }
                        fieldelement(SafetyLeadTime; Items."Safety Lead Time")
                        {
                        }
                        fieldelement(SafetyStockQuantity; Items."Safety Stock Quantity")
                        {
                        }
                        fieldelement(SalesLCY; Items."Sales (LCY)")
                        {
                        }
                        fieldelement(SalesQty; Items."Sales (Qty.)")
                        {
                        }
                        fieldelement(SalesBlocked; Items."Sales Blocked")
                        {
                        }
                        fieldelement(SalesUnitofMeasure; Items."Sales Unit of Measure")
                        {
                        }
                        fieldelement(ScheduledReceiptQty; Items."Scheduled Receipt (Qty.)")
                        {
                        }
                        fieldelement(Scrap; Items."Scrap %")
                        {
                        }
                        fieldelement(SearchDescription; Items."Search Description")
                        {
                        }
                        fieldelement(SerialNoFilter; Items."Serial No. Filter")
                        {
                        }
                        fieldelement(SerialNos; Items."Serial Nos.")
                        {
                        }
                        fieldelement(ServiceItemGroup; Items."Service Item Group")
                        {
                        }
                        fieldelement(ShelfNo; Items."Shelf No.")
                        {
                        }
                        fieldelement(SingleLevelCapOvhdCost; Items."Single-Level Cap. Ovhd Cost")
                        {
                        }
                        fieldelement(SingleLevelCapacityCost; Items."Single-Level Capacity Cost")
                        {
                        }
                        fieldelement(SingleLevelMaterialCost; Items."Single-Level Material Cost")
                        {
                        }
                        fieldelement(SingleLevelMfgOvhdCost; Items."Single-Level Mfg. Ovhd Cost")
                        {
                        }
                        fieldelement(SingleLevelSubcontrdCost; Items."Single-Level Subcontrd. Cost")
                        {
                        }
                        fieldelement(SpecialEquipmentCode; Items."Special Equipment Code")
                        {
                        }
                        fieldelement(StandardCost; Items."Standard Cost")
                        {
                        }
                        fieldelement(StatisticsGroup; Items."Statistics Group")
                        {
                        }
                        fieldelement(StockkeepingUnitExists; Items."Stockkeeping Unit Exists")
                        {
                        }
                        fieldelement(StockoutWarning; Items."Stockout Warning")
                        {
                        }
                        fieldelement(SubstitutesExist; Items."Substitutes Exist")
                        {
                        }
                        fieldelement(TariffNo; Items."Tariff No.")
                        {
                        }
                        fieldelement(TaxGroupCode; Items."Tax Group Code")
                        {
                        }
                        fieldelement(TaxGroupId; Items."Tax Group Id")
                        {
                        }
                        fieldelement(TimeBucket; Items."Time Bucket")
                        {
                        }
                        fieldelement(TransOrdReceiptQty; Items."Trans. Ord. Receipt (Qty.)")
                        {
                        }
                        fieldelement(TransOrdShipmentQty; Items."Trans. Ord. Shipment (Qty.)")
                        {
                        }
                        fieldelement(TransferredLCY; Items."Transferred (LCY)")
                        {
                        }
                        fieldelement(TransferredQty; Items."Transferred (Qty.)")
                        {
                        }
                        fieldelement(Type; Items."Type")
                        {
                        }
                        fieldelement(UnitCost; Items."Unit Cost")
                        {
                        }
                        fieldelement(UnitListPrice; Items."Unit List Price")
                        {
                        }
                        fieldelement(UnitPrice; Items."Unit Price")
                        {
                        }
                        fieldelement(UnitVolume; Items."Unit Volume")
                        {
                        }
                        fieldelement(UnitofMeasureFilter; Items."Unit of Measure Filter")
                        {
                        }
                        fieldelement(UnitofMeasureId; Items."Unit of Measure Id")
                        {
                        }
                        fieldelement(UnitsperParcel; Items."Units per Parcel")
                        {
                        }
                        fieldelement(UseCrossDocking; Items."Use Cross-Docking")
                        {
                        }
                        fieldelement(VATBusPostingGrPrice; Items."VAT Bus. Posting Gr. (Price)")
                        {
                        }
                        fieldelement(VATProdPostingGroup; Items."VAT Prod. Posting Group")
                        {
                        }
                        fieldelement(VariantFilter; Items."Variant Filter")
                        {
                        }
                        fieldelement(VendorItemNo; Items."Vendor Item No.")
                        {
                        }
                        fieldelement(VendorNo; Items."Vendor No.")
                        {
                        }
                        fieldelement(WarehouseClassCode; Items."Warehouse Class Code")
                        {
                        }
                        fieldelement(EstimatedSalesPrice; Items."Estimated Sales Price")
                        {
                        }
                        fieldelement(RevenueType; Items."Revenue Type")
                        {
                        }
                        fieldelement(DefaultESPperiods; Items."Default ESP-periods")
                        {
                        }
                        fieldelement(RecurringRevenuePrice; Items."Recurring Revenue Price")
                        {
                        }
                        fieldelement(ItemCode; Items."Item Code")
                        {
                        }
                        fieldelement(ItemSource; Items."Source Type")
                        {
                        }

                        textelement(ItemDimensions)
                        {
                            MinOccurs = Zero;
                            tableelement(ItemDimension; "IT GM Outbox Default Dimens.")
                            {
                                LinkTable = Items;
                                MinOccurs = Zero;
                                LinkFields = "Table ID" = const(27), "No." = field("No."), "Outbox Entry No." = field("Outbox Entry No.");
                                fieldelement(TableID; ItemDimension."Table ID")
                                {
                                }
                                fieldelement(No; ItemDimension."No.")
                                {
                                }
                                fieldelement(ParentId; ItemDimension.ParentId)
                                {
                                }
                                fieldelement(ParentType; ItemDimension."Parent Type")
                                {
                                }
                                fieldelement(AllowedValuesFilter; ItemDimension."Allowed Values Filter")
                                {
                                }
                                fieldelement(DimensionCode; ItemDimension."Dimension Code")
                                {
                                }
                                fieldelement(DimensionValueCode; ItemDimension."Dimension Value Code")
                                {
                                }
                                fieldelement(DimensionId; ItemDimension.DimensionId)
                                {
                                }
                                fieldelement(DimensionValueId; ItemDimension.DimensionValueId)
                                {
                                }
                                fieldelement(MultiSelectionAction; ItemDimension."Multi Selection Action")
                                {
                                }
                                fieldelement(ValuePosting; ItemDimension."Value Posting")
                                {
                                }

                            }
                        }
                    }
                }
                textelement(GMDimensions)
                {
                    MinOccurs = Zero;
                    tableelement("Dimensions"; "IT GM Outbox Dimension Value")
                    {
                        LinkTable = ITGMTransactions;
                        MinOccurs = Zero;
                        LinkFields = "Code" = field("Document No."), "Dimension Code" = field("Primary Key 2"), "Source Type" = field("Source Type"), "Outbox Entry No." = field("Entry No.");
                        fieldelement(Code; Dimensions."Code")
                        {
                        }
                        fieldelement(DimensionCode; Dimensions."Dimension Code")
                        {
                        }
                        fieldelement(ConsolidationCode; Dimensions."Consolidation Code")
                        {
                        }
                        fieldelement(Blocked; Dimensions.Blocked)
                        {
                        }
                        fieldelement(DimensionId; Dimensions."Dimension Id")
                        {
                        }
                        fieldelement(DimensionValueID; Dimensions."Dimension Value ID")
                        {
                        }
                        fieldelement(DimensionValueType; Dimensions."Dimension Value Type")
                        {
                        }
                        fieldelement(GlobalDimensionNo; Dimensions."Global Dimension No.")
                        {
                        }
                        fieldelement(Indentation; Dimensions.Indentation)
                        {
                        }
                        fieldelement(LastModifiedDateTime; Dimensions."Last Modified Date Time")
                        {
                        }
                        fieldelement(MaptoICDimensionCode; Dimensions."Map-to IC Dimension Code")
                        {
                        }
                        fieldelement(MaptoICDimensionValueCode; Dimensions."Map-to IC Dimension Value Code")
                        {
                        }
                        fieldelement(Name; Dimensions.Name)
                        {
                        }
                        fieldelement(Totaling; Dimensions.Totaling)
                        {
                        }
                        fieldelement(DimSource; Dimensions."Source Type")
                        {
                        }
                    }
                }
            }
        }
    }
}