@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phiếu kế toán Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define view entity ZFI_I_PHIEUKT_ITEM
  as select distinct from I_GLAccountLineItem as Item

    left outer join       I_Customer          as Cus on Cus.Customer = Item.Customer
    left outer join       I_Supplier          as Sup on Sup.Supplier = Item.Supplier


  association [1..1] to ZFI_I_ASSINGOBJECT2  as assobj  on  assobj.AccountingDocument = Item.AccountingDocument
                                                        and assobj.LedgerGLLineItem   = Item.LedgerGLLineItem
                                                        and assobj.FiscalYear         = Item.FiscalYear
                                                        and assobj.CompanyCode        = Item.CompanyCode
  association        to parent ZFI_I_PHIEUKT as _Header on  $projection.CompanyCode        = _Header.CompanyCode
                                                        and $projection.FiscalYear         = _Header.FiscalYear
                                                        and $projection.AccountingDocument = _Header.AccountingDocument

{
  key Item.CompanyCode,
  key Item.AccountingDocument,
  key Item.FiscalYear,
  key Item.AccountingDocumentItem,
  key Item.LedgerGLLineItem,
      Item.Ledger,
      case
          when Item.FinancialAccountType = 'D'
              then
                  Cus.Customer
              else
                  ''
      end                         as ma_kh,
      case
            when Cus.BusinessPartnerName2 = ' '
             or Cus.BusinessPartnerName3 = ' '
             or Cus.BusinessPartnerName4 = ' '
            then
            concat_with_space(concat_with_space(Cus.BusinessPartnerName2, Cus.BusinessPartnerName3, 1), Cus.BusinessPartnerName4, 1)
            else
                Cus.BusinessPartnerName1
            end                   as ten_kh,
      case
         when Item.DocumentItemText <> ''
             then Item.DocumentItemText
          when Item.DocumentItemText = ''
             then Item._JournalEntry.AccountingDocumentHeaderText
           else
                ' ' end           as noi_dung,

      Item.GLAccount              as tai_khoan,
      Item.ProfitCenter           as vu_viec,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      //      cast( case
      //        when Item.DebitCreditCode = 'S' and Item.IsNegativePosting = ''
      //            then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
      //        when Item.DebitCreditCode = 'H'  and Item.IsNegativePosting = 'X'
      //            then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
      //        else 0
      //       end    as abap.curr(23,2) )      as phat_sinh_no,
      cast( case
       when Item.DebitCreditCode = 'S'
           then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
       else 0
      end    as abap.curr(23,2) ) as phat_sinh_no,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      //      cast( case
      //        when Item.DebitCreditCode = 'H' and Item.IsNegativePosting = ''
      //            then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
      //        when Item.DebitCreditCode = 'S'  and Item.IsNegativePosting = 'X'
      //            then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
      //        else 0
      //       end    as abap.curr(23,2) )      as phat_sinh_co,
      cast( case
      when Item.DebitCreditCode = 'H'
          then cast( Item.AmountInCompanyCodeCurrency as abap.dec(23,2) )
      else 0
      end    as abap.curr(23,2) ) as phat_sinh_co,
      Item.TransactionCurrency,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      cast( case
      when Item.DebitCreditCode = 'H'
      then cast( Item.AmountInTransactionCurrency as abap.dec(23,2) )
      else 0
      end    as abap.curr(23,2) ) as phat_sinh_co_ngoaite,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      cast( case
      when Item.DebitCreditCode = 'S'
      then cast( Item.AmountInTransactionCurrency as abap.dec(23,2) )
      else 0
      end    as abap.curr(23,2) ) as phat_sinh_no_ngoaite,
      //      Item.IsNegativePosting,
      Item.DebitCreditCode,
      Item.CompanyCodeCurrency,

      // thêm
      Item.AssignmentReference,
      assobj.asignobject,
      /* Association */
      _Header
}
where
  Item.Ledger = '0L'
