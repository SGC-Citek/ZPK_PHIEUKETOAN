@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phieu ke toan header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define view entity ZFI_I_PHIEUKT
  with parameters
    OwnDocumentOnly : zde_bool
  as select distinct from I_JournalEntry   as Journal
    left outer join       I_CompanyCode    as ComCode       on Journal.CompanyCode = ComCode.CompanyCode
    left outer join       I_Address_2      as Address       on Address.AddressID = ComCode.AddressID

    left outer join       ZFI_I_SUM_AMOUNT as Amount        on  Amount.AccountingDocument = Journal.AccountingDocument
                                                            and Amount.CompanyCode        = Journal.CompanyCode
                                                            and Amount.FiscalYear         = Journal.FiscalYear

  //    left outer join       ZFI_I_SUM_AMOUNT_H as Amount_H    on  Amount_H.AccountingDocument = Journal.AccountingDocument
  //                                                            and Amount_H.CompanyCode        = Journal.CompanyCode
  //                                                            and Amount_H.FiscalYear         = Journal.FiscalYear

    left outer join       ZI_CHUKY         as KeToanTruong  on KeToanTruong.Id = 'KETOANTRUONG'
    left outer join       ZI_CHUKY         as NguoiKiemSoat on NguoiKiemSoat.Id = 'NGUOIKIEMSOAT'
    left outer join       ZI_CHUKY         as NguoiLap      on NguoiLap.Id = 'NGUOILAP'


  composition [0..*] of ZFI_I_PHIEUKT_ITEM as _Item
{
       @Consumption.valueHelpDefinition: [{ entity: {
           name: 'I_COMPANYCODE',
           element: 'CompanyCode'
       } }]

  key  Journal.CompanyCode,

       @Consumption.valueHelpDefinition: [{ entity: {
               name: 'I_FiscalYear',
               element: 'FiscalYear'
           } }]

  key  Journal.FiscalYear,

       //  @Consumption.valueHelpDefinition: [{ entity: { name:'I_OperationalAcctgDocItem', element: 'AccountingDocument' } }]
       @EndUserText.label: 'Journal entry'
  key  Journal.AccountingDocument,


       @Consumption.valueHelpDefinition: [{ entity: { name:'I_AccountingDocumentType', element: 'AccountingDocumentType' } }]

       Journal.AccountingDocumentType,

       Journal.DocumentReferenceID,
       Journal.AccountingDocCreatedByUser,

       //       @EndUserText.label: 'AccountingDocumentEntryDate'
       //       Journal.AccountingDocumentCreationDate,

       Journal.DocumentDate,

       Journal.PostingDate,
       //       case
       //        when Journal._OperationalAcctgDocItem.DocumentItemText <> ''
       //            then Journal._OperationalAcctgDocItem.DocumentItemText
       //        when Journal._OperationalAcctgDocItem.DocumentItemText = ''
       //            then Journal.AccountingDocumentHeaderText
       //        when Journal.AccountingDocumentHeaderText = ''
       //            then '' end as noi_dung,
       Journal.AccountingDocumentHeaderText                                                                                                                                    as noi_dung,
       @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
       //       @Aggregation.default         : #SUM
       @DefaultAggregation: #SUM
       //       case when Journal._OperationalAcctgDocItem.DebitCreditCode = 'S'
       //        then Amount.amount
       //            when Journal._OperationalAcctgDocItem.DebitCreditCode = 'H'
       //        then Amount_H.amount end as amount,
       Amount.amount,
       Amount.CompanyCodeCurrency,
       @Consumption.filter.hidden: true
       @UI.hidden: true
       concat_with_space(Address.OrganizationName1,concat_with_space(Address.OrganizationName2,concat_with_space(Address.OrganizationName3,Address.OrganizationName4,1), 1),1) as cong_ty,
       @Consumption.filter.hidden: true
       @UI.hidden: true
       concat_with_space(Address.StreetName,concat_with_space(Address.StreetPrefixName1,concat_with_space(Address.StreetPrefixName2,concat_with_space(
       Address.StreetSuffixName1 ,Address.StreetSuffixName2,1),1), 1),1)                                                                                                       as dia_chi,

       Journal.PostingDate                                                                                                                                                     as ngay_hach_toan,
       Journal.DocumentDate                                                                                                                                                    as ngay_chung_tu,
       @Consumption.filter.hidden: true
       @UI.hidden: true
       KeToanTruong.Hoten                                                                                                                                                      as KTT,
       @Consumption.filter.hidden: true
       @UI.hidden: true
       NguoiKiemSoat.Hoten                                                                                                                                                     as NKS,
       @Consumption.filter.hidden: true
       @UI.hidden: true
       NguoiLap.Hoten                                                                                                                                                          as NL,
       Journal.AccountingDocumentCategory,
       @Consumption.filter.hidden: true

       Journal.TransactionCurrency,
       Journal.AbsoluteExchangeRate,
       //Item.DebitCreditCode,
       /* Association */
       _Item

}
where
  (
    (
          $parameters.OwnDocumentOnly        is initial
    )
    or(
          $parameters.OwnDocumentOnly        is not initial
      and Journal.AccountingDocCreatedByUser = $session.user
    )
  )
  and     Journal.AccountingDocumentCategory <> 'V'
