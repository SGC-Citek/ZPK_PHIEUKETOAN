@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'A/C  assign object'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_ASSINGOBJECT2
  as select distinct from I_GLAccountLineItem      as Item
    left outer join       I_Customer               as Cus    on Cus.Customer = Item.Customer
    left outer join       I_Supplier               as Sup    on Sup.Supplier = Item.Supplier
    left outer join       I_OneTimeAccountCustomer as oneCus on  oneCus.AccountingDocumentItem = Item.AccountingDocumentItem
                                                             and oneCus.AccountingDocument     = Item.AccountingDocument
    left outer join       I_OneTimeAccountSupplier as oneSup on  oneSup.AccountingDocumentItem = Item.AccountingDocumentItem
                                                             and oneSup.AccountingDocument     = Item.AccountingDocument
  association [1..1] to I_FixedAsset       as fixasset  on  fixasset.MasterFixedAsset = Item.MasterFixedAsset
  association [1..1] to I_ProductText      as prdt      on  prdt.Product  = Item.Product
                                                        and prdt.Language = 'E'
  association [1..1] to I_HouseBankBasic   as hbb       on  hbb.HouseBank = Item.HouseBank
  association [1..1] to I_CostCenterText   as ctt       on  ctt.CostCenter = Item.CostCenter
                                                        and ctt.Language   = 'E'
  association [1..1] to I_ProfitCenterText as pft       on  pft.ProfitCenter = Item.ProfitCenter
                                                        and pft.Language     = 'E'
  association [1..1] to ZFI_I_GETGLACCOUNT as housebank on  housebank.AccountingDocument     = Item.AccountingDocument
                                                        and housebank.CompanyCode            = Item.CompanyCode
                                                        and housebank.FiscalYear             = Item.FiscalYear
                                                        and housebank.AccountingDocumentItem = Item.AccountingDocumentItem
{
  key Item.CompanyCode,
  key Item.AccountingDocument,
  key Item.FiscalYear,
  key Item.LedgerGLLineItem,
      Item.FinancialAccountType,
      Item.Customer,
      Item.Supplier,
      housebank.GLAccount,
      Cus.IsOneTimeAccount,
      Sup.IsOneTimeAccount                                                                                                                                                                                                                         as suponetitem,
      Item.HouseBank,
      hbb.BankName,
      Item.MasterFixedAsset,
      fixasset.FixedAssetDescription,
//      Item.HouseBank,
      left(Item.GLAccount,2)                                                                                                                                                                                                                       as test,
      concat_with_space(Item.Supplier,concat_with_space('-',concat_with_space(Sup._AddressRepresentation.OrganizationName2,concat_with_space(Sup._AddressRepresentation.OrganizationName3,Sup._AddressRepresentation.OrganizationName4,1),1),1),1) as test1,
      concat_with_space(Cus._AddressRepresentation.OrganizationName2,concat_with_space(Cus._AddressRepresentation.OrganizationName3,Cus._AddressRepresentation.OrganizationName4,1),1)                                                             as cusnbbame,
      case when Cus.IsOneTimeAccount = ''  and Item.Customer != '' and Item.FinancialAccountType = 'D' and ( Cus._AddressRepresentation.OrganizationName2 != '' or Cus._AddressRepresentation.OrganizationName3 != '' or Cus._AddressRepresentation.OrganizationName4 != '' )
      then concat_with_space(Item.Customer ,concat_with_space('-',concat_with_space(Cus._AddressRepresentation.OrganizationName2,concat_with_space(Cus._AddressRepresentation.OrganizationName3,Cus._AddressRepresentation.OrganizationName4,1),1),1),1)
      when Cus.IsOneTimeAccount = ''  and Item.Customer != '' and Item.FinancialAccountType = 'D' and Cus._AddressRepresentation.OrganizationName1 != ''
      then concat_with_space(Item.Customer,concat_with_space('-',Cus._AddressRepresentation.OrganizationName1,1),1)
      when Sup.IsOneTimeAccount = ''  and Item.Supplier != '' and Item.FinancialAccountType = 'K' and ( Sup._AddressRepresentation.OrganizationName2 != '' or Sup._AddressRepresentation.OrganizationName3 != '' or Sup._AddressRepresentation.OrganizationName4 != '' )
      then concat_with_space(Item.Supplier,concat_with_space('-',concat_with_space(Sup._AddressRepresentation.OrganizationName2,concat_with_space(Sup._AddressRepresentation.OrganizationName3,Sup._AddressRepresentation.OrganizationName4,1),1),1),1)
      when  Sup.IsOneTimeAccount = ''  and Item.Supplier != '' and Item.FinancialAccountType = 'K' and Sup._AddressRepresentation.OrganizationName1 != ''
      then concat_with_space(Item.Supplier,concat_with_space('-',Sup._AddressRepresentation.OrganizationName1,1),1)
      when   Sup.IsOneTimeAccount != ''  and Item.FinancialAccountType = 'K'
      then concat_with_space(Item.Supplier,concat_with_space('-',concat_with_space(oneSup.BusinessPartnerName1,concat_with_space(oneSup.BusinessPartnerName2,concat_with_space(oneSup.BusinessPartnerName3,oneSup.BusinessPartnerName4,1),1),1),1),1)
      when Cus.IsOneTimeAccount != '' and Item.FinancialAccountType = 'D'
      then concat_with_space(Item.Customer,concat_with_space('-',concat_with_space(oneCus.BusinessPartnerName1,concat_with_space(oneCus.BusinessPartnerName2,concat_with_space(oneCus.BusinessPartnerName3,oneCus.BusinessPartnerName4,1),1),1),1),1)
      when Item.FinancialAccountType = 'A'
      then concat_with_space(Item.MasterFixedAsset,concat_with_space('-',fixasset.FixedAssetDescription,1),1)
      when Item.FinancialAccountType = 'M'
      then concat_with_space(Item.Product,concat_with_space('-',prdt.ProductName,1),1)
      when Item.FinancialAccountType = 'S' and housebank.GLAccount != ''
      then  concat_with_space(Item.HouseBank,concat_with_space('-s',hbb.BankName,1),1)
      when Item.CostCenter != '' and Item.FinancialAccountType = 'S'
      then concat_with_space(Item.CostCenter,concat_with_space('-c',ctt.CostCenterName,1),1)
      //      when Item.ProfitCenter != ' ' and Item.FinancialAccountType = 'S'
      //      then concat_with_space(Item.ProfitCenter,concat_with_space('-p',pft.ProfitCenterName,1),1)
      else ''  end                                                                                                                                                                                                                                 as asignobject,
            case when Cus.IsOneTimeAccount = ''  and Item.Customer != '' and Item.FinancialAccountType = 'D' and ( Cus._AddressRepresentation.OrganizationName2 != '' or Cus._AddressRepresentation.OrganizationName3 != '' or Cus._AddressRepresentation.OrganizationName4 != '' )
      then '1'
      when Cus.IsOneTimeAccount = ''  and Item.Customer != '' and Item.FinancialAccountType = 'D' and Cus._AddressRepresentation.OrganizationName1 != ''
      then '2'
      when Sup.IsOneTimeAccount = ''  and Item.Supplier != '' and Item.FinancialAccountType = 'K' and ( Sup._AddressRepresentation.OrganizationName2 != '' or Sup._AddressRepresentation.OrganizationName3 != '' or Sup._AddressRepresentation.OrganizationName4 != '' )
      then '3'
      when  Sup.IsOneTimeAccount = ''  and Item.Supplier != '' and Item.FinancialAccountType = 'K' and Sup._AddressRepresentation.OrganizationName1 != ''
      then '4'
      when   Sup.IsOneTimeAccount != ''  and Item.FinancialAccountType = 'K'
      then '5'
      when Cus.IsOneTimeAccount != '' and Item.FinancialAccountType = 'D'
      then '6'
      when Item.FinancialAccountType = 'A'
      then'7'
      when Item.FinancialAccountType = 'M'
      then '8'
      when Item.FinancialAccountType = 'S' and housebank.GLAccount != ''
      then '9'
      when Item.CostCenter != '' and Item.FinancialAccountType = 'S'
      then '1'
      //      when Item.ProfitCenter != ' ' and Item.FinancialAccountType = 'S'
      //      then concat_with_space(Item.ProfitCenter,concat_with_space('-p',pft.ProfitCenterName,1),1)
      else ''  end                                                                                                                                                                                                                                 as asignobject1
}
//where
//     Item.FinancialAccountType = 'D'
//  or Item.FinancialAccountType = 'K'
