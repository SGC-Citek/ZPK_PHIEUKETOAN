@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'A/C  assign object'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_ASSINGOBJECT
  as select from    I_OperationalAcctgDocItem as Item
    left outer join I_Customer                as Cus    on Cus.Customer = Item.Customer
    left outer join I_Supplier                as Sup    on Sup.Supplier = Item.Supplier
    left outer join I_OneTimeAccountCustomer  as oneCus on oneCus.Customer = Item.Customer
    left outer join I_OneTimeAccountSupplier  as oneSup on oneSup.Supplier = Item.Supplier
  association [1..1] to I_FixedAsset       as fixasset on  fixasset.FixedAsset = Item.MasterFixedAsset
  association [1..1] to I_ProductText      as prdt     on  prdt.Product  = Item.Product
                                                       and prdt.Language = 'E'
  association [1..1] to I_HouseBankBasic   as hbb      on  hbb.HouseBank = Item.HouseBank
  association [1..1] to I_CostCenterText   as ctt      on  ctt.CostCenter = Item.CostCenter
                                                       and ctt.Language   = 'E'
  association [1..1] to I_ProfitCenterText as pft      on  pft.ProfitCenter = Item.ProfitCenter
                                                       and pft.Language     = 'E'
{
  key Item.CompanyCode,
  key Item.AccountingDocument,
  key Item.FiscalYear,
  key Item.AccountingDocumentItem,
      Item.FinancialAccountType,
      Item.Customer,
      Item.Supplier,
      case when Cus.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Customer != '' and Item.FinancialAccountType = 'D' and Cus._AddressRepresentation.OrganizationName1 != ''
      then concat_with_space(Item.Customer,concat_with_space('-',Cus._AddressRepresentation.OrganizationName1,1),1)
      when Cus.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Customer != '' and Item.FinancialAccountType = 'D' and Cus._AddressRepresentation.OrganizationName1 = ''
      then concat_with_space(Item.Customer,concat_with_space('-',concat_with_space(Cus._AddressRepresentation.OrganizationName2,concat_with_space(Cus._AddressRepresentation.OrganizationName3,Cus._AddressRepresentation.OrganizationName4,1),1),1),1)
      when  Sup.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Supplier != '' and Item.FinancialAccountType = 'K' and Sup._AddressRepresentation.OrganizationName1 != ''
      then concat_with_space(Item.Supplier,concat_with_space('-',Sup._AddressRepresentation.OrganizationName1,1),1)
      when Sup.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Supplier != '' and Item.FinancialAccountType = 'K' and Sup._AddressRepresentation.OrganizationName1 = ''
      then concat_with_space(Item.Supplier,concat_with_space('-',concat_with_space(Sup._AddressRepresentation.OrganizationName2,concat_with_space(Sup._AddressRepresentation.OrganizationName3,Sup._AddressRepresentation.OrganizationName4,1),1),1),1)
      when (Cus.IsOneTimeAccount != '' or Item.AddressAndBankIsSetManually != '') and (Item.FinancialAccountType = 'K' or Item.FinancialAccountType = 'D')
      then concat_with_space(Item.Supplier,concat_with_space('-',concat_with_space(oneSup.BusinessPartnerName1,concat_with_space(oneSup.BusinessPartnerName2,concat_with_space(oneSup.BusinessPartnerName3,oneSup.BusinessPartnerName4,1),1),1),1),1)
      when Item.FinancialAccountType = 'A'
      then concat_with_space(Item.MasterFixedAsset,concat_with_space('-',fixasset.FixedAssetDescription,1),1)
      when Item.FinancialAccountType = 'M'
      then concat_with_space(Item.Product,concat_with_space('-',prdt.ProductName,1),1)
      when Item.FinancialAccountType = 'S' and left(Item.GLAccount,4) = '0011'
      then  concat_with_space(Item.HouseBank,concat_with_space('-',hbb.BankName,1),1)
      when Item.CostCenter != '' and Item.FinancialAccountType = 'S'
      then concat_with_space(Item.CostCenter,concat_with_space('-',ctt.CostCenterName,1),1)
      when Item.ProfitCenter != ' ' and Item.FinancialAccountType = 'S'
      then concat_with_space(Item.ProfitCenter,concat_with_space('-',pft.ProfitCenterName,1),1)
      else '' end as asignobject,

      case 
          when Cus.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Customer != '' and Item.FinancialAccountType = 'D' and Cus._AddressRepresentation.OrganizationName1 != ''
              then Item.Customer 
          when Cus.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Customer != '' and Item.FinancialAccountType = 'D' and Cus._AddressRepresentation.OrganizationName1 = ''
              then Item.Customer 
          when (Cus.IsOneTimeAccount != '' or Item.AddressAndBankIsSetManually != '') and Item.FinancialAccountType = 'D'
              then Item.Customer
          when Sup.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Supplier != '' and Item.FinancialAccountType = 'K' and Sup._AddressRepresentation.OrganizationName1 != ''
              then Item.Supplier 
          when Sup.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Supplier != '' and Item.FinancialAccountType = 'K' and Sup._AddressRepresentation.OrganizationName1 = ''
              then Item.Supplier 
          when (Sup.IsOneTimeAccount != '' or Item.AddressAndBankIsSetManually != '') and Item.FinancialAccountType = 'K'
              then Item.Supplier
          when Item.FinancialAccountType = 'A'
              then Item.MasterFixedAsset 
          when Item.FinancialAccountType = 'M'
              then Item.Product 
          when Item.FinancialAccountType = 'S' and left(Item.GLAccount,4) = '0011'
              then Item.HouseBank 
          when Item.CostCenter != '' and Item.FinancialAccountType = 'S'
              then Item.CostCenter 
          when Item.ProfitCenter != ' ' and Item.FinancialAccountType = 'S'
              then Item.ProfitCenter 
      else '' end as Code,

      case 
          when Cus.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Customer != '' and Item.FinancialAccountType = 'D' and Cus._AddressRepresentation.OrganizationName1 != ''
              then Cus._AddressRepresentation.OrganizationName1 
          when Cus.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Customer != '' and Item.FinancialAccountType = 'D' and Cus._AddressRepresentation.OrganizationName1 = ''
              then concat_with_space(Cus._AddressRepresentation.OrganizationName2,concat_with_space(Cus._AddressRepresentation.OrganizationName3,Cus._AddressRepresentation.OrganizationName4,1),1) 
          when (Cus.IsOneTimeAccount != '' or Item.AddressAndBankIsSetManually != '') and Item.FinancialAccountType = 'D'
              then concat_with_space(oneCus.BusinessPartnerName1,concat_with_space(oneCus.BusinessPartnerName2,concat_with_space(oneCus.BusinessPartnerName3,oneCus.BusinessPartnerName4,1),1),1) 
          when Sup.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Supplier != '' and Item.FinancialAccountType = 'K' and Sup._AddressRepresentation.OrganizationName1 != ''
              then Sup._AddressRepresentation.OrganizationName1 
          when Sup.IsOneTimeAccount = '' and Item.AddressAndBankIsSetManually  = '' and Item.Supplier != '' and Item.FinancialAccountType = 'K' and Sup._AddressRepresentation.OrganizationName1 = ''
              then concat_with_space(Sup._AddressRepresentation.OrganizationName2,concat_with_space(Sup._AddressRepresentation.OrganizationName3,Sup._AddressRepresentation.OrganizationName4,1),1) 
          when (Sup.IsOneTimeAccount != '' or Item.AddressAndBankIsSetManually != '') and Item.FinancialAccountType = 'K' 
              then concat_with_space(oneSup.BusinessPartnerName1,concat_with_space(oneSup.BusinessPartnerName2,concat_with_space(oneSup.BusinessPartnerName3,oneSup.BusinessPartnerName4,1),1),1) 
          when Item.FinancialAccountType = 'A'
              then fixasset.FixedAssetDescription 
          when Item.FinancialAccountType = 'M'
              then prdt.ProductName 
          when Item.FinancialAccountType = 'S' and left(Item.GLAccount,4) = '0011'
              then hbb.BankName 
          when Item.CostCenter != '' and Item.FinancialAccountType = 'S'
              then ctt.CostCenterName 
          when Item.ProfitCenter != ' ' and Item.FinancialAccountType = 'S'
              then pft.ProfitCenterName 
      else '' end as Text
}
//where
//     Item.FinancialAccountType = 'D'
//  or Item.FinancialAccountType = 'K'
