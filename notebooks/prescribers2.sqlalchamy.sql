select * from prescriber
select * from cbsa
select * from drug
select * from overdose_deaths
select * from prescription
select * from zip_fips
select * from fips_county
select * from population

-- Prescriber_connection 1
SELECT 
	pn.drug_name,
	fc.state, 
	fc.county, 
	sum (pn.total_claim_count) as total_count, 
	p.population 
FROM prescriber AS pr
JOIN prescription AS pn
ON pr.npi = pn.npi
JOIN zip_fips AS zp
ON zp.zip = pr.nppes_provider_zip5
JOIN population AS p
ON p.fipscounty = zp.fipscounty
JOIN fips_county AS fc
ON fc.fipscounty = p.fipscounty
JOIN drug AS d
ON d.drug_name = pn.drug_name
WHERE fc.state =  'TN' AND d.opioid_drug_flag = 'Y'
group by fc.county, fc.state, pn.drug_name, p.population
order by fc.county, pn.drug_name

-- Prescriber_connection 2
SELECT  pr.nppes_provider_last_org_name, 
		pr.nppes_provider_first_name, 		 
		sum (pn.total_claim_count) AS total_count 

FROM prescriber AS pr
JOIN prescription AS pn
ON pr.npi = pn.npi
JOIN drug AS d
ON d.drug_name = pn.drug_name
WHERE pr.nppes_provider_state =  'TN' AND d.opioid_drug_flag = 'Y'
group by pr.nppes_provider_last_org_name, pr.nppes_provider_first_name
order by total_count desc

-- Prescriber_connection 3

SELECT    
		od.year,
		SUM (od.overdose_deaths) AS total_death
		
FROM prescriber AS pr
JOIN prescription AS pn
ON pr.npi = pn.npi
JOIN zip_fips AS zp
ON zp.zip = pr.nppes_provider_zip5
JOIN population AS p
ON p.fipscounty = zp.fipscounty
JOIN fips_county AS fc
ON fc.fipscounty = p.fipscounty
JOIN drug AS d
ON d.drug_name = pn.drug_name
JOIN overdose_deaths AS od
ON od.fipscounty::TEXT = fc.fipscounty
WHERE fc.state =  'TN' AND d.opioid_drug_flag ='Y'
GROUP BY od.year



-- Prescriber_connection 4

























