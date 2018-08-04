SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwEUContactIDs] AS

SELECT
		DISTINCT eu.SSID
		, eu.SourceSystem
		, eu.SSB_CRMSYSTEM_CONTACT_ID
		, eu.AddressPrimaryCountry
		, eu.AddressPrimaryCity
		, eu.AddressPrimaryState
		, eu.AddressOneCountry
		, eu.AddressOneCity
		, eu.AddressOneState
		, eu.AddressTwoCountry
		, eu.AddressTwoCity
		, eu.AddressTwoState
		, eu.AddressThreeCountry
		, eu.AddressThreeCity
		, eu.AddressThreeState
		, eu.EmailPrimary
		, eu.EmailOne
		, eu.EmailTwo
		, eu.DimCustomerId
		, eu.IsDeleted
		, eu.AddressPrimarylatitude
		, eu.AddressPrimarylongitude
FROM  (SELECT DISTINCT 
		a.SSID
		, a.SourceSystem
		, a.SSB_CRMSYSTEM_CONTACT_ID
		, a.AddressPrimaryCity 
		, a.AddressPrimaryState
		, a.AddressPrimaryZip
		, a.AddressPrimaryCountry
		, a.AddressOneCountry
		, a.AddressOneCity
		, a.AddressOneState
		, a.AddressTwoCountry
		, a.AddressTwoCity
		, a.AddressTwoState
		, a.AddressThreeCountry
		, a.AddressThreeCity
		, a.AddressThreeState
		, a.EmailPrimary
		, a.EmailOne
		, a.EmailTwo
		, a.dimcustomerId
		, a.IsDeleted
		, a.AddressPrimarylatitude
		, a.AddressPrimarylongitude
FROM (
SELECT DISTINCT
		dc.SSID
		, dc.SourceSystem
		, dcs.SSB_CRMSYSTEM_CONTACT_ID
		, dc.AddressPrimaryCity 
		, dc.AddressPrimaryState
		, dc.AddressPrimaryZip
		, dc.AddressPrimaryCountry
		, dc.AddressOneCountry
		, dc.AddressOneCity
		, dc.AddressOneState
		, dc.AddressTwoCountry
		, dc.AddressTwoCity
		, dc.AddressTwoState
		, dc.AddressThreeCountry
		, dc.AddressThreeCity
		, dc.AddressThreeState
		, dc.EmailPrimary
		, dc.EmailOne
		, dc.EmailTwo
		, dc.dimcustomerId
		, dc.IsDeleted
		, dc.AddressPrimarylatitude
		, dc.AddressPrimarylongitude
FROM	dbo.DimCustomer dc WITH (NOLOCK)
INNER JOIN dbo.dimcustomerssbid dcs WITH (NOLOCK) ON dcs.DimCustomerId = dc.DimCustomerId
AND dc.IsDeleted = 0
AND (dc.AddressPrimaryCountry IN ('Austria'
,'Italy'
,'Belgium'
,'Latvia'
,'Bulgaria'	
,'Lithuania'
,'Croatia'
,'Luxembourg'
,'Cyprus'
,'Malta'
,'Czech Republic'	
,'Netherlands'
,'Denmark'	
,'Poland'
,'Estonia'	
,'Portugal'
,'Finland'	
,'Romania'
,'France'	
,'Slovakia'
,'Germany'	
,'Slovenia'
,'Greece'	
,'Spain'
,'Hungary'	
,'Sweden'
,'Ireland'	
,'United Kingdom'
,'Great Britain'
,'BE'
,'BG'
,'CZ'
,'DK'
,'DE'
,'EE'
,'IE'
,'EL'
,'ES'
,'FR'
,'HR'
,'IT'
,'CY'
,'LV'
,'LT'
,'LU'
,'HU'
,'MT'
,'NL'
,'AT'
,'PL'
,'PT'
,'RO'
,'SI'
,'SK'
,'FI'
,'SE'
,'UK'
,'GB')
OR dc.AddressOneCountry IN ('Austria'
,'Italy'
,'Belgium'
,'Latvia'
,'Bulgaria'	
,'Lithuania'
,'Croatia'
,'Luxembourg'
,'Cyprus'
,'Malta'
,'Czech Republic'	
,'Netherlands'
,'Denmark'	
,'Poland'
,'Estonia'	
,'Portugal'
,'Finland'	
,'Romania'
,'France'	
,'Slovakia'
,'Germany'	
,'Slovenia'
,'Greece'	
,'Spain'
,'Hungary'	
,'Sweden'
,'Ireland'	
,'United Kingdom'
,'Great Britain'
,'BE'
,'BG'
,'CZ'
,'DK'
,'DE'
,'EE'
,'IE'
,'EL'
,'ES'
,'FR'
,'HR'
,'IT'
,'CY'
,'LV'
,'LT'
,'LU'
,'HU'
,'MT'
,'NL'
,'AT'
,'PL'
,'PT'
,'RO'
,'SI'
,'SK'
,'FI'
,'SE'
,'UK'
,'GB')
OR dc.AddressTwoCountry IN ('Austria'
,'Italy'
,'Belgium'
,'Latvia'
,'Bulgaria'	
,'Lithuania'
,'Croatia'
,'Luxembourg'
,'Cyprus'
,'Malta'
,'Czech Republic'	
,'Netherlands'
,'Denmark'	
,'Poland'
,'Estonia'	
,'Portugal'
,'Finland'	
,'Romania'
,'France'	
,'Slovakia'
,'Germany'	
,'Slovenia'
,'Greece'	
,'Spain'
,'Hungary'	
,'Sweden'
,'Ireland'	
,'United Kingdom'
,'Great Britain'
,'BE'
,'BG'
,'CZ'
,'DK'
,'DE'
,'EE'
,'IE'
,'EL'
,'ES'
,'FR'
,'HR'
,'IT'
,'CY'
,'LV'
,'LT'
,'LU'
,'HU'
,'MT'
,'NL'
,'AT'
,'PL'
,'PT'
,'RO'
,'SI'
,'SK'
,'FI'
,'SE'
,'UK'
,'GB')
OR dc.AddressThreeCountry IN ('Austria'
,'Italy'
,'Belgium'
,'Latvia'
,'Bulgaria'	
,'Lithuania'
,'Croatia'
,'Luxembourg'
,'Cyprus'
,'Malta'
,'Czech Republic'	
,'Netherlands'
,'Denmark'	
,'Poland'
,'Estonia'	
,'Portugal'
,'Finland'	
,'Romania'
,'France'	
,'Slovakia'
,'Germany'	
,'Slovenia'
,'Greece'	
,'Spain'
,'Hungary'	
,'Sweden'
,'Ireland'	
,'United Kingdom'
,'Great Britain'
,'BE'
,'BG'
,'CZ'
,'DK'
,'DE'
,'EE'
,'IE'
,'EL'
,'ES'
,'FR'
,'HR'
,'IT'
,'CY'
,'LV'
,'LT'
,'LU'
,'HU'
,'MT'
,'NL'
,'AT'
,'PL'
,'PT'
,'RO'
,'SI'
,'SK'
,'FI'
,'SE'
,'UK'
,'GB')
OR RIGHT(dc.EmailPrimary,3) IN( '.BE'
,'.BG'
,'.CZ'
,'.DK'
,'.DE'
,'.EE'
,'.IE'
,'.EL'
,'.ES'
,'.FR'
,'.HR'
,'.IT'
,'.CY'
,'.LV'
,'.LT'
,'.LU'
,'.HU'
,'.MT'
,'.NL'
,'.AT'
,'.PL'
,'.PT'
,'.RO'
,'.SI'
,'.SK'
,'.FI'
,'.SE'
,'.UK'
,'.GB')
OR RIGHT(dc.EmailOne,3) IN( '.BE'
,'.BG'
,'.CZ'
,'.DK'
,'.DE'
,'.EE'
,'.IE'
,'.EL'
,'.ES'
,'.FR'
,'.HR'
,'.IT'
,'.CY'
,'.LV'
,'.LT'
,'.LU'
,'.HU'
,'.MT'
,'.NL'
,'.AT'
,'.PL'
,'.PT'
,'.RO'
,'.SI'
,'.SK'
,'.FI'
,'.SE'
,'.UK'
,'.GB')
OR RIGHT(dc.EmailTwo,3) IN( '.BE'
,'.BG'
,'.CZ'
,'.DK'
,'.DE'
,'.EE'
,'.IE'
,'.EL'
,'.ES'
,'.FR'
,'.HR'
,'.IT'
,'.CY'
,'.LV'
,'.LT'
,'.LU'
,'.HU'
,'.MT'
,'.NL'
,'.AT'
,'.PL'
,'.PT'
,'.RO'
,'.SI'
,'.SK'
,'.FI'
,'.SE'
,'.UK'
,'.GB')) )a
WHERE a.AddressPrimaryCountry NOT IN ('US', 'USA', 'United States', 'United States of America')
) eu



GO
