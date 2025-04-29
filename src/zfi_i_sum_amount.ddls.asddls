@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum amount phiếu kế toán'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_SUM_AMOUNT
  as select distinct from I_GLAccountLineItem as Item

{
  key Item.CompanyCode,
  key Item.AccountingDocument,
  key Item.FiscalYear,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      sum(Item.DebitAmountInCoCodeCrcy ) as amount,
      Item.CompanyCodeCurrency,
      Item.DebitCreditCode
}
where
      Item.DebitCreditCode = 'S'
  and Item.Ledger          = '0L'
group by
  Item.CompanyCode,
  Item.AccountingDocument,
  Item.FiscalYear,
  Item.CompanyCodeCurrency,
  Item.DebitCreditCode
