#' @name get_registration
#' @rdname get_registration
#' @title  Retrieve registration data from UNHCR proGres database and generate a summary report.
#'
#' @description    A standard query that retrieve refugee registration data from proGres,
#' aggregated at the case level. This dataset can be joined to the survey dataset in order to
#' generate prediction model. to be used with the prediction report generation.
#'
#' This includes the variables below
#'
#'  Arrival Date
#'  Districts of Origin
#'  Districts of Arrival
#'  Household size (case)
#'  Household size (squared)
#'  Share of members under 5 years of age
#'  Share of members between 5 and 17 years of age
#'  Share of male members between 18 and 50
#'  Share of female members between 18 and 50
#'  Share of members between 51 and 70
#'  Share of members above 71
#'  Share of members between 6 and 10 years of age
#'  Share of members between 11 and 17 years of age
#'  Share of members between 18 and 60 years of age
#'  Share of members above 60 years of age
#'  Sum of members under 5 years of age
#'  Sum of members between 6 and 10 years of age
#'  Sum of members between 11 and 17 years of age
#'  Sum of members between 18 and 60 years of age
#'  Sum of members above 60 years of age
#'  Share of members with a disability
#'  Sum of members with a disability
#'  Members above 60 years of age with a medical condition
#'  Dependency ratio
#'  Dependent members with a disability
#'  More than 3 dependents in HH
#'
#'
#'Demographics - Head of Household variables
#'  Head of HH is female
#'  Head of HH age
#'  Head above 60 years of age
#'  Head of HH is female and below 18 years of age
#'  Head of HH is disabled
#'  Head of HH education level
#'  Head of HH with a medical condition
#'  Head of HH below 18

#'
#'
#' @return save a cleaned csv file within the data folder.
#'
#' @export get_registration
#'
#' @author Edouard Legoupil
#'
#' @examples
#' \dontrun{
#' get_registration()
#' }
#'


get_registration <- function() {


## Db handle for progres Data to SQL server using ODBC##################################
odbcname <- rstudioapi::askForPassword("Give the odbc db name")
user <- rstudioapi::askForPassword("Enter the username that can access the database:")
passw <- rstudioapi::askForPassword("Database password")

dbhandleprogresv3 <- RODBC::odbcConnect(odbcname, uid = user, pwd = passw)
rm(user, passw)


query <- "
DROP TABLE caseprofile1;
SELECT  PP.ProcessingGroupNumber CaseNo,
COUNT(DISTINCT II.IndividualGUID) Num_Inds,
AVG(II.IndividualAge) AVG_Age,
STDEV(II.IndividualAge) STDEV_Age,
Count( CASE WHEN(II.IndividualAge < 15) THEN(II.IndividualGUID) ELSE(NULL) END) Child_0_14,
Count( CASE WHEN(II.IndividualAge < 19 AND IndividualAge > 14) THEN(II.IndividualGUID) ELSE(NULL) END) Youth_15_17,
Count( CASE WHEN(II.IndividualAge < 65 AND IndividualAge > 14) THEN(II.IndividualGUID) ELSE(NULL) END) Work_15_64,
Count( CASE WHEN(II.IndividualAge > 64) THEN(II.IndividualGUID) ELSE(NULL) END) Eldern_65,
Count( CASE WHEN(II.SexCode = 'M') THEN(SexCode) ELSE(NULL) END) Male,
Count( CASE WHEN(II.SexCode = 'F') THEN(SexCode) ELSE(NULL) END) Female,
Count( CASE WHEN(II.SexCode not in  ('F','M')) THEN('Empty')  END) NOGender,
Count( CASE WHEN(IPGG.RelationshipToPrincipalRepresentative ='HUS' or IPGG.RelationshipToPrincipalRepresentative ='EXM' or IPGG.RelationshipToPrincipalRepresentative ='WIF'
or IPGG.RelationshipToPrincipalRepresentative ='EXF' or IPGG.RelationshipToPrincipalRepresentative ='CLH' or IPGG.RelationshipToPrincipalRepresentative ='CLW') THEN(II.IndividualGUID) ELSE(NULL) END) couple,
Count( CASE WHEN(IPGG.RelationshipToPrincipalRepresentative ='SCF' or IPGG.RelationshipToPrincipalRepresentative ='SCM' or IPGG.RelationshipToPrincipalRepresentative ='FCF'
or IPGG.RelationshipToPrincipalRepresentative ='FCM' or IPGG.RelationshipToPrincipalRepresentative ='SON' or IPGG.RelationshipToPrincipalRepresentative ='DAU' and II.IndividualAge < 19) THEN(II.IndividualGUID) ELSE(NULL) END) minordependant
INTO dbo.caseprofile1
FROM dbo.dataProcessGroup AS PP
INNER JOIN dbo.dataIndividualProcessGroup AS IPGG ON PP.ProcessingGroupGUID = IPGG.ProcessingGroupGUID
INNER JOIN dbo.dataIndividual AS II ON IPGG.IndividualGUID = II.IndividualGUID
WHERE ProcessStatusCode IN('A') GROUP BY ProcessingGroupNumber


DROP TABLE caseprofile2;
SELECT P.ProcessingGroupNumber CaseNo,
P.ProcessingGroupSize Num_Inds1,
IPG.RelationshipToPrincipalRepresentative Relationship,
IPG.PrincipalRepresentative Relationshippa,
I.OriginCountryCode CountryOrigin,
I.NationalityCode dem_birth_country,
DATENAME(mm, I.ArrivalDate) Montharrival,
DATENAME(yyyy, I.ArrivalDate) YearArrival,
I.SexCode dem_sex,
I.IndividualAge dem_age,
I.IndividualAgeCohortCode dem_agegroup,
I.EthnicityCode dem_ethn,
I.ReligionCode dem_religion,
I.MarriageStatusCode dem_marriage,
I.EducationLevelCode edu_highest,
I.RefugeeStatusCode,
I.RefugeeStatusDate,
I.RefugeeStatusCategoryCode,
-- I.RefugeeStatusCategoryDate,
I.RefugeeStatusLegalBasisCode,
--  I.RefugeeStatusLegalBasisDate,
I.ProcessStatusCode,
--  I.ProcessStatusDate,
I.ProcessStatusReasonCode,
--  I.ProcessStatusReasonDate,
I.SPNeeds,
I.HasSPNeed,
I.OccupationCode occupationcode,
K.LocationLevel1Description cool1,
K.LocationLevel1ID cool1id,
K.LocationLevel2Description cool2,
K.LocationLevel2ID cool2id,
K.LocationLevel3Description cool3,
K.LocationLevel3ID cool3id,
K.LocationLevel4Description cool4,
K.LocationLevel4ID cool4id,
K.LocationLevel5Description cool5,
K.LocationLevel5ID cool5id,
J.LocationLevel1Description coal1,
J.LocationLevel1ID coal1id,
J.LocationLevel2Description coal2,
J.LocationLevel2ID coal2id,
J.LocationLevel3Description coal3,
J.LocationLevel3ID coal3id,
J.LocationLevel4Description coal4,
J.LocationLevel4ID coal4id,
J.LocationLevel5Description coal5,
J.LocationLevel5ID coal5id

INTO dbo.caseprofile2
FROM dbo.dataProcessGroup AS P
INNER JOIN dbo.dataIndividualProcessGroup AS IPG ON P.ProcessingGroupGUID = IPG.ProcessingGroupGUID
INNER JOIN dbo.dataIndividual AS I ON IPG.IndividualGUID = I.IndividualGUID
INNER JOIN dbo.vdataAddressCOA AS J ON IPG.IndividualGUID = J.IndividualGUID
INNER JOIN dbo.vdataAddressCOO AS K ON IPG.IndividualGUID = K.IndividualGUID
LEFT OUTER JOIN dbo.dataProcessGroupPhyFile AS PGF ON PGF.ProcessingGroupGUID = P.ProcessingGroupGUID
WHERE I.ProcessStatusCode = 'A' AND IPG.PrincipalRepresentative = 1

DROP TABLE caseprofile;
SELECT P.CaseNo,
P.Num_Inds1,
P.Relationship,
P.Relationshippa,
P.CountryOrigin,
P.dem_birth_country,
P.Montharrival,
P.YearArrival,
P.dem_sex,
P.dem_age,
P.dem_agegroup,
P.dem_ethn,
P.dem_religion,
P.dem_marriage,
P.edu_highest,
P.RefugeeStatusCode,
P.RefugeeStatusCategoryCode,
P.RefugeeStatusLegalBasisCode,
P.ProcessStatusCode,
P.ProcessStatusReasonCode,
P.SPNeeds,
P.HasSPNeed,
P.occupationcode,
P.cool1,
P.cool1id,
P.cool2,
P.cool2id,
P.cool3,
P.cool3id,
P.cool4,
P.cool4id,
P.cool5,
P.cool5id,
P.coal1,
P.coal1id,
P.coal2,
P.coal2id,
P.coal3,
P.coal3id,
P.coal4,
P.coal4id,
P.coal5,
P.coal5id,
Cal_1.Num_Inds,
Cal_1.Child_0_14,
Cal_1.Youth_15_17,
Cal_1.Work_15_64,
Cal_1.Eldern_65,
Cal_1.Male,
Cal_1.Female,
Cal_1.NOGender,
Cal_1.couple,
Cal_1.minordependant,
Cal_1.AVG_Age,
Cal_1.STDEV_Age
INTO [dbo].[caseprofile]
FROM caseprofile2 as P
LEFT JOIN caseprofile1 AS Cal_1  ON P.CaseNo = Cal_1.CaseNo

DROP TABLE caseprofile1;
DROP TABLE caseprofile2;


DROP TABLE caseprofileneeds;
SELECT *
INTO caseprofileneeds
FROM
(SELECT I.IndividualGUID,
I.VulnerabilityDetailsCode as SPNeeds,
I.VulnerabilityDetailsCode as code,
P.ProcessingGroupNumber CaseNo --Colums to pivot
FROM  dataVulnerability as I
INNER JOIN dbo.dataIndividual AS II ON I.IndividualGUID = II.IndividualGUID
INNER JOIN dbo.dataIndividualProcessGroup AS IPG ON IPG.IndividualGUID = II.IndividualGUID
INNER JOIN dbo.dataProcessGroup AS P  ON P.ProcessingGroupGUID = IPG.ProcessingGroupGUID
WHERE I.VulnerabilityActive = 1
AND VulnerabilityDetailsCode in (
'CR', 'CR-AF', 'CR-CC', 'CR-CH', 'CR-CL', 'CR-CP', 'CR-CS',
'CR-LO', 'CR-LW', 'CR-MS', 'CR-NE', 'CR-SE', 'CR-TP', 'DS', 'DS-BD', 'DS-DF', 'DS-MM', 'DS-MS', 'DS-PM',
'DS-PS', 'DS-SD', 'ER', 'ER-FR', 'ER-MC', 'ER-NF', 'ER-OC', 'ER-SC', 'ER-UR', 'FU', 'FU-FR', 'FU-TR',
'LP', 'LP-AF', 'LP-AN', 'LP-AP', 'LP-BN', 'LP-CR', 'LP-DA', 'LP-DN', 'LP-DO', 'LP-DP', 'LP-DT', 'LP-ES',
'LP-FR', 'LP-IH', 'LP-LS', 'LP-MD', 'LP-MM', 'LP-MS', 'LP-NA', 'LP-ND', 'LP-PV', 'LP-RD', 'LP-RP', 'LP-RR',
'LP-ST', 'LP-TA', 'LP-TC', 'LP-TD', 'LP-TO', 'LP-TR', 'LP-UP', 'LP-VA', 'LP-VF', 'LP-VO', 'LP-VP', 'LP-WP',
'PG', 'PG-HR', 'PG-LC', 'SC', 'SC-CH', 'SC-FC', 'SC-IC', 'SC-NC', 'SC-SC', 'SC-UC', 'SC-UF', 'SC-UM',
'SM', 'SM-AD', 'SM-CC', 'SM-CI', 'SM-DP', 'SM-MI', 'SM-MN', 'SM-OT', 'SP', 'SP-CG', 'SP-GP', 'SP-PT',
'SV', 'SV-FM', 'SV-GM', 'SV-HK', 'SV-HP', 'SV-SS', 'SV-VA', 'SV-VF', 'SV-VO', 'TR', 'TR-HO', 'TR-PI',
'TR-WV', 'WR', 'WR-GM', 'WR-HR',
'WR-LC', 'WR-PY', 'WR-SF', 'WR-UW', 'WR-WF', 'WR-WR'))
as sourcetable
pivot(
COUNT(IndividualGUID) --Pivot on this column
for SPNeeds --Make colum where SPNeeds is in one of these.
in([CR], [CR - AF], [CR - CC], [CR - CH], [CR - CL], [CR - CP], [CR - CS], [CR - LO], [CR - LW], [CR - MS], [CR - NE], [CR - SE], [CR - TP], [DS], [DS - BD], [DS - DF], [DS - MM], [DS - MS], [DS - PM], [DS - PS], [DS - SD], [ER], [ER - FR], [ER - MC], [ER - NF], [ER - OC], [ER - SC], [ER - UR], [FU], [FU - FR], [FU - TR], [LP], [LP - AF], [LP - AN], [LP - AP], [LP - BN], [LP - CR], [LP - DA], [LP - DN], [LP - DO], [LP - DP], [LP - DT], [LP - ES], [LP - FR], [LP - IH], [LP - LS], [LP - MD], [LP - MM], [LP - MS], [LP - NA], [LP - ND], [LP - PV], [LP - RD], [LP - RP], [LP - RR], [LP - ST], [LP - TA], [LP - TC], [LP - TD], [LP - TO], [LP - TR], [LP - UP], [LP - VA], [LP - VF], [LP - VO], [LP - VP], [LP - WP], [PG], [PG - HR], [PG - LC], [SC], [SC - CH], [SC - FC], [SC - IC], [SC - NC], [SC - SC], [SC - UC], [SC - UF], [SC - UM], [SM], [SM - AD], [SM - CC], [SM - CI], [SM - DP], [SM - MI], [SM - MN], [SM - OT], [SP], [SP - CG], [SP - GP], [SP - PT], [SV], [SV - FM], [SV - GM], [SV - HK], [SV - HP], [SV - SS], [SV - VA], [SV - VF], [SV - VO], [TR], [TR - HO], [TR - PI], [TR - WV], [WR], [WR - GM], [WR - HR], [WR - LC], [WR - PY], [WR - SF], [WR - UW], [WR - WF], [WR - WR])
)
as CountSpecificNeeds--Pivot table alias
"


cat("Executing the summary table creation within proGres")
final <- RODBC::sqlQuery(dbhandleprogresv3,paste(query))

cat("fetching the view containing information")
progres.case <-  RODBC::sqlFetch(dbhandleprogresv3, "caseprofile")


readr::write_csv(caseprofile, file = "data-raw/caseprofile.csv")

## With general needs
progres.specificneed <- RODBC::sqlFetch(dbhandleprogresv3, "caseprofileneeds")

readr::write_csv(caseprofileneeds, file = "data-raw/caseprofileneeds.csv")

}
