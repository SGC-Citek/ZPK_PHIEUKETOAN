@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tổng nợ'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_SUM_NO as select from I_OperationalAcctgDocItem as Item
       left outer join ZFI_I_PHIEUKT_ITEM as PItem on PItem.AccountingDocument = Item.AccountingDocument
                                                   and PItem.CompanyCode = Item.CompanyCode
                                                   and PItem.FiscalYear  = Item.FiscalYear
                                                   and PItem.AccountingDocumentItem = Item.AccountingDocumentItem
{
    key Item.AccountingDocument,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      sum(PItem.phat_sinh_no) as tong_no,
       
       @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      sum(PItem.phat_sinh_co) as tong_co,
       
       Item.CompanyCodeCurrency
}
group by
    Item.AccountingDocument,
    Item.CompanyCodeCurrency
