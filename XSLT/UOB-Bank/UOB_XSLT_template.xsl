<?xml version='1.0' encoding='utf-8'?>
 <!--   $Header: fusionapps/fin/iby/bipub/shared/runFormat/reports/DisbursementPaymentFileFormats/ISO20022CGI.xsl /st_fusionapps_pt-v2mib/4 2018/04/04 07:35:17 jswirsky Exp $   
  --> 
 <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="no" /> 
  <xsl:output method="xml" /> 
  <xsl:key name="contacts-by-LogicalGroupReference" match="OutboundPayment" use="LogicalGrouping/LogicalGroupReference" /> 
 <xsl:template match="OutboundPaymentInstruction">
 <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:variable name="instrid" select="PaymentInstructionInfo/InstructionReferenceNumber" /> 
  
 <GrpHdr>
 <MsgId>
  <xsl:value-of select="$instrid" /> 
  </MsgId>
  <CreDtTm>
  <xsl:choose>
	<xsl:when test="contains(PaymentInstructionInfo/InstructionCreationDate , '+')">
		<xsl:value-of select="substring(PaymentInstructionInfo/InstructionCreationDate , 1,	string-length(PaymentInstructionInfo/InstructionCreationDate)-6)"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="PaymentInstructionInfo/InstructionCreationDate" />
	</xsl:otherwise>
  </xsl:choose> 
  </CreDtTm>
 <NbOfTxs>
  <xsl:value-of select="substring(InstructionTotals/PaymentCount,1,15)" /> 
  </NbOfTxs>
 <CtrlSum>
    <xsl:value-of select="format-number(InstructionTotals/TotalPaymentAmount/Value, '##0.00')"/>
  </CtrlSum>
 <InitgPty>
 <Id>
 <OrgId>
 <BICOrBEI>
  <xsl:value-of select="substring(InstructionGrouping/BankAccount/SwiftCode,1,11)"/> 
 </BICOrBEI>
  </OrgId>
  </Id>
  </InitgPty>
  </GrpHdr>
 <xsl:for-each select="OutboundPayment">
<!--Start of payment information block-->
 <PmtInf>
 <xsl:if test="not(LogicalGrouping/LogicalGroupReference='')">
 <PmtInfId>
  <!--<xsl:value-of select="LogicalGrouping/LogicalGroupReference" /> For Unserscorce <PmtInfId>25009_5004</PmtInfId> -->
  <xsl:value-of select="$instrid" /> 
  </PmtInfId>
  </xsl:if>
  <PmtMtd>
  <xsl:text>TRF</xsl:text>
  </PmtMtd> 
<!--Start of payment type information block-->
 <PmtTpInf>
 <SvcLvl>
  <Cd>
  <xsl:text>URGP</xsl:text> 
  </Cd> 
  </SvcLvl>
  </PmtTpInf>
<!--End of payment type information block-->
 <ReqdExctnDt>
  <xsl:value-of select="format(PaymentDate,'YYYY-MM-DD'" /> 
  </ReqdExctnDt>
 <Dbtr>
 <Nm>
  <xsl:text>The Ascott Ltd</xsl:text> 
  </Nm>
 <PstlAdr>
 <Ctry>
  <xsl:value-of select="substring(BankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
  </PstlAdr>
 <Id>
 <OrgId>
 <Othr>
 <Id>
  <xsl:value-of select="substring(../InstructionGrouping/BankAccount/SwiftCode,1,35)"/>
  </Id>
  </Othr>
  </OrgId>
  </Id>
 </Dbtr>
 <DbtrAcct>
 <Id>
  <Othr>
    <Id>
      <xsl:value-of select="substring(BankAccount/BankAccountNumber,1,34)" />
    </Id>
  </Othr>
 </Id>
 <Ccy>
   <xsl:value-of select="substring(BankAccount/BankAccountCurrency/Code,1,3)" /> 
 </Ccy>
 </DbtrAcct>
 <DbtrAgt>
 <FinInstnId>
 <BIC>
  <xsl:value-of select="substring(../InstructionGrouping/BankAccount/SwiftCode,1,11)" /> 
  </BIC> 
  <xsl:if test="not(BankAccount/BankAddress/Country='')">  
  <PstlAdr>
  <Ctry>
  <xsl:value-of select="substring(BankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
  </PstlAdr>
  </xsl:if>
 </FinInstnId>
  </DbtrAgt>
 <xsl:if test="not(BankCharges/BankChargeBearer/Code='')">
  <ChrgBr>
  <xsl:choose>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='BEN')">
   <xsl:text>CRED</xsl:text> 
   </xsl:when>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='OUR')">
   <xsl:text>DEBT</xsl:text> 
   </xsl:when>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='SHA')">
   <xsl:text>SHAR</xsl:text> 
   </xsl:when>
  </xsl:choose>
  </ChrgBr> 
 </xsl:if>
 
<!--Start of credit transaction block-->
 <CdtTrfTxInf>
 <PmtId>
 <InstrId>
  <xsl:value-of select="substring(PaymentNumber/CheckNumber,1,35)" /> 
  </InstrId>
 <EndToEndId>
  <xsl:value-of select="substring(PaymentNumber/CheckNumber, 1, 35)" /> 
  </EndToEndId>
  </PmtId>

 <Amt>
 <InstdAmt>
 <xsl:attribute name="Ccy">
  <xsl:value-of select="substring(PaymentAmount/Currency/Code,1,3)" /> 
  </xsl:attribute>
  <xsl:value-of select="format-number(PaymentAmount/Value, '##0.00')" /> 
  </InstdAmt>
  </Amt>
 <xsl:if test="not(BankCharges/BankChargeBearer/Code='')">
  <ChrgBr>
  <xsl:choose>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='BEN')">
   <xsl:text>CRED</xsl:text> 
   </xsl:when>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='OUR')">
   <xsl:text>DEBT</xsl:text> 
   </xsl:when>
   <xsl:when test="(BankCharges/BankChargeBearer/Code='SHA')">
   <xsl:text>SHAR</xsl:text> 
   </xsl:when>
  </xsl:choose>
  </ChrgBr> 
 </xsl:if>

 <CdtrAgt>
 <FinInstnId>
 <xsl:if test="not(PayeeBankAccount/SwiftCode='')">
 <BIC>
  <xsl:value-of select="substring(PayeeBankAccount/SwiftCode,1,11)" /> 
  </BIC>
  </xsl:if>

  <xsl:if test="not(PayeeBankAccount/BankName='')">
  <Nm>
    <xsl:value-of select="substring(PayeeBankAccount/BankName,1,140)" />
  </Nm>
  </xsl:if>
  <xsl:if test="not(PayeeBankAccount/BankAddress/Country='')">  
  <PstlAdr>
  <Ctry>
  <xsl:value-of select="substring(PayeeBankAccount/BankAddress/Country,1,2)" /> 
  </Ctry>
  </PstlAdr>
  </xsl:if>
  </FinInstnId>
  </CdtrAgt>
 <Cdtr>
 <Nm>
  <xsl:value-of select="substring(PayeeBankAccount/BankAccountName, 1, 140) " /> 
  </Nm>
  <PstlAdr>
  <PstCd>
  <xsl:value-of select="substring(SupplierorParty/Address/PostalCode, 1, 16)" /> 
  </PstCd>
  <Ctry>
  <xsl:value-of select="substring(SupplierorParty/Address/Country,1,2)" /> 
  </Ctry>
  <AdrLine>
  <xsl:value-of select="substring(SupplierorParty/Address/AddressLine1,1,70)" />
  <xsl:value-of select="substring(SupplierorParty/Address/AddressLine2,1,70)" />
  <xsl:value-of select="substring(SupplierorParty/Address/AddressLine3,1,70)" />
  </AdrLine>
  </PstlAdr>
  </Cdtr>
 <CdtrAcct>
 <Id>
  <xsl:if test="not(PayeeBankAccount/IBANNumber='')">
  <IBAN>
  <xsl:value-of select="substring(PayeeBankAccount/IBANNumber,1,34)" /> 
  </IBAN>
  </xsl:if>
  <!-- if no IBAN, use bank account number-->
  <Othr>
   <Id>
     <xsl:value-of select="substring(PayeeBankAccount/BankAccountNumber,1,34)" />
   </Id>
  </Othr>
  </Id>
  </CdtrAcct>

  <RltdRmtInf>
   <xsl:if test="not(Payee/RemitAdviceDeliveryMethod='')">
   <RmtLctnMtd>
     <xsl:text>EMAIL</xsl:text>
   </RmtLctnMtd>
   </xsl:if>
   <RmtLctnPstlAdr>
    <Nm>
	 <xsl:value-of select="substring(SupplierorParty/Name,1,140)" />
	</Nm>
	<Adr>
	 <PstCd>
	  <xsl:value-of select="substring(SupplierorParty/Address/PostalCode,1,16)" />
	 </PstCd>
	 <Ctry>
	  <xsl:value-of select="substring(SupplierorParty/Address/Country,1,2)" />
	 </Ctry>
	 <AdrLine>
	  <xsl:value-of select="substring(SupplierorParty/Address/AddressLine1,1,70)" />
	  <xsl:value-of select="substring(SupplierorParty/Address/AddressLine2,1,70)" />
	  <xsl:value-of select="substring(SupplierorParty/Address/AddressLine3,1,70)" />
	 </AdrLine>
	</Adr>
   </RmtLctnPstlAdr>
  </RltdRmtInf>
  
 <RmtInf>
<xsl:for-each select="DocumentPayable">
  <Ustrd>
   <xsl:text>H1: Invoice Number  Invoice Date  Invoice Total Amount  Invoice Currency  Payment Amount  3: </xsl:text>
   <xsl:value-of select=" DocumentNumber/ReferenceNumber " />
   <xsl:text>  </xsl:text>
   <xsl:value-of select=" DocumentDate " />
   <xsl:text>  </xsl:text>
   <xsl:value-of select=" TotalDocumentAmount/Value " />
   <xsl:text>  </xsl:text>
   <xsl:value-of select=" TotalDocumentAmount/Currency/Code " />
   <xsl:text>  </xsl:text>
   <xsl:value-of select=" PaymentAmount/Value " />
  </Ustrd>
  </xsl:for-each>
 <Strd>
  <Invcr>
   <Nm>
    <xsl:value-of select="substring(SupplierorParty/Name,1,140)" />
   </Nm>
  </Invcr>
  <Invcee>
   <Nm>
    <xsl:value-of select="substring(../InstructionGrouping/Payer/Name,1,140)" />
   </Nm>
  </Invcee>
 </Strd>
 </RmtInf>
  </CdtTrfTxInf>
  </PmtInf>
  </xsl:for-each>
  </Document>
  </xsl:template>
  </xsl:stylesheet>
