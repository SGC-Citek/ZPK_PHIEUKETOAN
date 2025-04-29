@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds để tạo search help cho Journal Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_JOURNALENTRY as select distinct from I_JournalEntry
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode
}
