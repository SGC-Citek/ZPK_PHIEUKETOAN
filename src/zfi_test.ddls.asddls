@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test data select'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_TEST as select from I_GLAccountInChartOfAccounts as item
{
    key item.GLAccount,
    case when left(item.GLAccount,4) = '0011' 
    then 'a' end as item
}
