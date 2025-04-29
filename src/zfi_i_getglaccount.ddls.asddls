@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get glaccount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_GETGLACCOUNT
  as select distinct from I_GLAccountLineItem as item
{
  key item.CompanyCode,
  key item.AccountingDocument,
  key item.FiscalYear,
  key item.AccountingDocumentItem,
      item.GLAccount,
      item.HouseBank,
      item.HouseBankAccount
}
where
  left(item.GLAccount,2) = '11'
