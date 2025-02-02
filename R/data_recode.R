# WARNING - Generated by {fusen} from /dev/flat_full.Rmd: do not edit by hand

#' @title Assemble all data components in a list and compute indicators
#' @param progresobj  a list with all required frame
#' @param ctr Country or Business Unit for the dataset dump
#' @return progresobjexpand  a list with all required frame
#' 
#' @export 

#' @examples
#' progresobj <- data_load(dataraw = system.file("demo/", package = "proGresAnalysis") )
#' progres <- data_recode(progresobj = progresobj,
#'                        ctr = "Ecuador")
#' 
data_recode <- function(progresobj, ctr ) {
  
  require(tidyverse)
    ## Deconstruct the list... 
    Individual <- as.data.frame(progresobj[1] ) 
    RegistrationGroup <- as.data.frame(progresobj[2] )
    Assistance <-  as.data.frame(progresobj[3] )
    Document <-  as.data.frame(progresobj[4] )
    Education <-  as.data.frame(progresobj[5] )
    EntitlementCard <-  as.data.frame(progresobj[6]) 
    IndividualProperty <-  as.data.frame(progresobj[7]) 
    Language <-  as.data.frame(progresobj[8] )
    Nationality <-  as.data.frame(progresobj[9]) 
    Relative <-  as.data.frame(progresobj[10] )
    Representative <-  as.data.frame(progresobj[11]) 
    Skill <-  as.data.frame(progresobj[12] )
    SocioEconomic <-  as.data.frame(progresobj[13]) 
    SpecificNeed <-  as.data.frame(progresobj[14] )
    Transit <-  as.data.frame(progresobj[15] )
    WorkExperience <-  as.data.frame(progresobj[16]) 
    
    
    ## This chunk is to rework variables so that we aggregate modalities with low frequencies together
    ## Categorise main Nationality 
    Individual <- Individual |>
      dplyr::mutate(CountryOfOriginCat = forcats::fct_lump_prop(CountryOfOrigin, prop = .1))
    ## Legal Status 
    # table(Individual$LegalStatus, useNA = "ifany" )
    Individual <- Individual |>
    # Lump together factor levels into "other" if less than 10% of frequency
      dplyr::mutate(LegalStatusCat = forcats::fct_lump_prop(LegalStatus, prop = .1))
    #table(Individual$LegalStatusCat, useNA = "ifany" ) 
    
    ## Legal Status combined with registration reason
    Individual <- Individual |>
      # Lump together factor levels into "other" if less than 10% of frequency
      dplyr::mutate(
        LegalStatusCont =   paste0(LegalStatus,
                                   dplyr::if_else( is.na(RefugeeStatusCategory),
                                            paste0(""),
                                            paste0("-", RefugeeStatusCategory)),
                                   dplyr::if_else( is.na(RegistrationReason),
                                            paste0(""),
                                            paste0("-", RegistrationReason)) ),
        LegalStatusCat2 = forcats::fct_lump_prop( LegalStatusCont, prop = .01))
    #table(Individual$LegalStatusCont, useNA = "ifany" ) 
    #table(Individual$LegalStatusCat2, useNA = "ifany" ) 
    
    
    ## Marrital Status 
    #levels(as.factor(Individual$MaritalStatus))
    #table(Individual$MaritalStatus , useNA = "ifany" )
    Individual <- Individual |>
      dplyr::mutate(MaritalStatusCat = dplyr::case_when(
        MaritalStatus == "Common Law Married" ~ "Married-Engaged",
        MaritalStatus == "Married" ~ "Married-Engaged",
        MaritalStatus == "Engaged" ~ "Married-Engaged",
        MaritalStatus == "Partnership" ~ "Married-Engaged",
        MaritalStatus == "Single" & Age >= 18 ~ "Single_Adult",
        MaritalStatus == "Single"& Age < 18 ~ "Single_Minor",
        MaritalStatus == "Separated" ~ "Divorced-Separated-Widow",
        MaritalStatus == "Divorced" ~ "Divorced-Separated-Widow",
        MaritalStatus == "Widowed" ~ "Divorced-Separated-Widow",
        MaritalStatus == "Unknown" ~ "Unknown",
        is.na(MaritalStatus)  ~ "Unknown" )) 
    
    # table(Individual$MaritalStatusCat , useNA = "ifany" )
    # View(Individual[is.na(Individual$MaritalStatusCat) , c("MaritalStatus", "MaritalStatusCat")] )
    
    ## Linsk in Group
    #levels(as.factor(Individual$RelationshipToFP  ))
    #table(Individual$RelationshipToFP , useNA = "ifany" )
    Individual <- Individual |>
      dplyr::mutate(RelationshipToFPCat = forcats::fct_lump_prop( RelationshipToFP, prop = .005)) 
    
    #table(Individual$RelationshipToFPCat , useNA = "ifany" )
    #View(Individual[is.na(Individual$RelationshipToFPCat) , c("RelationshipToFPCat", "RelationshipToFP")] )
    
    Individual <- Individual |>
      dplyr::mutate(RelationshipToFPCat2 = dplyr::case_when(
        RelationshipToFP == "Focal Point" ~ "Focal Point", 
        RelationshipToFP == "Husband" ~ "Partner", 
        RelationshipToFP == "Wife" ~ "Partner", 
        RelationshipToFP == "Partner (Female)" ~ "Partner", 
        RelationshipToFP == "Partner (Male)" ~ "Partner", 
        RelationshipToFP == "Common Law Husband" ~ "Partner", 
        RelationshipToFP == "Common Law Wife" ~ "Partner", 
        
        RelationshipToFP == "Son" ~ "Family Line", 
        RelationshipToFP == "Daughter" ~ "Family Line", 
        RelationshipToFP == "Grandfather" ~ "Family Line", 
        RelationshipToFP == "Grandmother" ~ "Family Line", 
        RelationshipToFP == "Grandson" ~ "Family Line", 
        RelationshipToFP == "Granddaughter" ~ "Family Line", 
        RelationshipToFP == "Mother" ~ "Family Line", 
        RelationshipToFP == "Father" ~ "Family Line", 
        
        RelationshipToFP == "Aunt" ~ "Extended",  
        RelationshipToFP == "Uncle" ~ "Extended", 
        RelationshipToFP == "Brother" ~ "Extended", 
        RelationshipToFP == "Sister" ~ "Extended", 
        RelationshipToFP == "Cousin (female)" ~ "Extended", 
        RelationshipToFP == "Cousin (male)" ~ "Extended", 
        RelationshipToFP == "Ex-husband" ~ "Extended", 
        RelationshipToFP == "Foster daughter" ~ "Extended", 
        RelationshipToFP == "Foster father" ~ "Extended", 
        RelationshipToFP == "Foster mother" ~ "Extended", 
        RelationshipToFP == "Foster son" ~ "Extended", 
        RelationshipToFP == "Half-brother" ~ "Extended", 
        RelationshipToFP == "Half-sister" ~ "Extended",  
        RelationshipToFP == "Nephew" ~ "Extended", 
        RelationshipToFP == "Niece" ~ "Extended", 
        RelationshipToFP == "Other blood relation (female)" ~ "Extended", 
        RelationshipToFP == "Other blood relation (male)" ~ "Extended",
        
        
        RelationshipToFP == "In Law - Brother" ~ "Extended", 
        RelationshipToFP == "In Law - Sister" ~ "Extended", 
        RelationshipToFP == "In-Law - Daughter" ~ "Extended", 
        RelationshipToFP == "In-Law - Father" ~ "Extended", 
        RelationshipToFP == "In-Law - Mother" ~ "Extended", 
        RelationshipToFP == "In-Law - Son" ~ "Extended", 
        RelationshipToFP == "In-Law (female)" ~ "Extended", 
        RelationshipToFP == "In-Law (male)" ~ "Extended",
        
        RelationshipToFP == "Step-brother" ~ "Extended", 
        RelationshipToFP == "Step-daughter"  ~ "Extended", 
        RelationshipToFP == "Step-father" ~ "Extended", 
        RelationshipToFP == "Step-mother" ~ "Extended", 
        RelationshipToFP == "Step-sister" ~ "Extended", 
        RelationshipToFP == "Step-son" ~ "Extended", 
        
        RelationshipToFP == "No blood relation (female)" ~ "Other", 
        RelationshipToFP == "No blood relation (male)" ~ "Other", 
        RelationshipToFP == "Not specified/unknown (female)" ~ "Other", 
        RelationshipToFP == "Not specified/unknown (male)" ~ "Other", 
        is.na(RelationshipToFP)  ~ "Other" )) 
    #table(Individual$RelationshipToFPCat2 , useNA = "ifany" ) 
    
    ## year of arrival - grouping together pre-2017
    Individual <- Individual |>
      dplyr::mutate( ArrivalYear = lubridate::year(lubridate::as_date(ArrivalDate)),
                     ArrivalYear2 = cut(ArrivalYear, 
                                        breaks = c(0,2017,2018,2019,2020,2021,2022),
                                        labels = c("Arrived in 2017 and before",
                                                   "Arrived in 2018",
                                                   "Arrived in 2019", 
                                                   "Arrived in 2020", 
                                                   "Arrived in 2021",
                                                   "Arrived in 2022"))) 
    
    #table(Individual$ArrivalYear , useNA = "ifany" )
    #table(Individual$ArrivalYear2 , useNA = "ifany" )
 
    ## Adjust Education Level ########
    Individual <- Individual |>
      dplyr::left_join(Education |>
                         dplyr::mutate(ModifiedOnEd = ModifiedOn) |>
                         dplyr::select(IndividualID, Level, Ranking,ModifiedOnEd) ,
                       by = c("IndividualID")) |> 
      dplyr::arrange(desc(ModifiedOnEd)) |> 
      dplyr::filter(!duplicated(IndividualID, fromLast = FALSE)) |> 
      dplyr::mutate(EducationLevelCat = dplyr::case_when(
        Level == "Informal education" ~ "Other",
        Level == "Technical or vocational" ~ "Other",
        Level == "No education" ~ "Up to Grade 5",
        Level == "Kindergarten" ~ "Up to Grade 5",
        Level == "1 year (or Grade 1)" ~ "Up to Grade 5",
        Level == "2 years (or Grade 2)" ~ "Up to Grade 5",
        Level == "3 years (or Grade 3)" ~ "Up to Grade 5",
        Level == "4 years (or Grade 4)" ~ "Up to Grade 5",
        Level == "5 years (or Grade 5)" ~ "Up to Grade 5",
        Level == "6 years (or Grade 6)" ~ "Grade 6-8",
        Level == "7 years (or Grade 7)" ~ "Grade 6-8",
        Level == "8 years (or Grade 8)" ~ "Grade 6-8",
        Level == "9 years (or Grade 9)" ~ "Grade 9-11",
        Level == "10 years (or Grade 10)" ~ "Grade 9-11",
        Level == "11 years (or Grade 11)" ~ "Grade 9-11",
        Level == "12 years (or Grade 12)" ~ "Grade 12-14",
        Level == "13 years (or Grade 13)" ~ "Grade 12-14",
        Level == "14 years (or Grade 14)" ~ "Grade 12-14",
        Level == "University level" ~ "Higher Education",
        Level == "Post university level" ~ "Higher Education",
        Level == "Unknown" ~ "Unknown",
        is.na(Level) ~ "Unknown"))  |>    
    
    #table(Individual$EducationLevelCat, useNA = "ifany")
    # SE.PRE.ENRR School enrollment, preprimary (% gross)
    # SE.PRM.ENRR School enrollment, primary (% gross)
    # SE.SEC.ENRR School enrollment, secondary (% gross)
    # SE.TER.ENRR School enrollment, tertiary (% gross)
    
    # Individual <- Individual |>
    # 
    #   dplyr::left_join(Education |>
    #                      dplyr::mutate(ModifiedOnEd = ModifiedOn) |>
    #                      dplyr::select(IndividualID, Level, Ranking,ModifiedOnEd) ,
    #                    by = c("IndividualID")) |> 
    #   dplyr::arrange(desc(ModifiedOnEd)) |> 
    #   dplyr::filter(!duplicated(IndividualID, fromLast = FALSE)) |>   
      # Education Enroll Level #####
      dplyr::mutate(EducationEnroll = dplyr::case_when(
         Level == "Kindergarten" ~ "is.in.preprimary",
         Level %in% c(  "1 year (or Grade 1)",
                                  "2 years (or Grade 2)",
                                  "3 years (or Grade 3)",
                                  "4 years (or Grade 4)", 
                                  "5 years (or Grade 5)") ~ "is.in.primary",
         Level %in% c( "6 years (or Grade 6)",
                                 "7 years (or Grade 7)" ,
                                 "8 years (or Grade 8)",
                                 "9 years (or Grade 9)",
                                 "10 years (or Grade 10)",
                                 "11 years (or Grade 11)",
                                 "12 years (or Grade 12)",
                                 "13 years (or Grade 13)",
                                 "14 years (or Grade 14)") ~ "is.in.secondary",
         Level %in% c( "University level",
                                 "Post university level") ~ "is.in.tertiary" ))  |>
      
      # EducationEnroll Should #####    
      dplyr::mutate(EducationEnrollShould = dplyr::case_when(
        Age >=3 & Age <6   ~ "should.be.in.preprimary",
        Age >=6 &   Age <11    ~ "should.be.in.primary",
        Age >=11 &   Age <20    ~ "should.be.in.secondary",
        Age >=20 &   Age < 24   ~ "should.be.in.tertiary" )) |>
      
      # Education Enroll atRightAge #####  
      dplyr::mutate(EducationEnrollatRightAge = dplyr::case_when(
        Age >=3 & Age <6 & 
          Level == "Kindergarten" ~ "yes",
        Age >=6 &   Age <11  & 
          Level %in% c(  "1 year (or Grade 1)",
                                "2 years (or Grade 2)",
                                "3 years (or Grade 3)",
                                "4 years (or Grade 4)", 
                                "5 years (or Grade 5)") ~ "yes",
        Age >=11 &   Age <20  & 
          Level %in% c( "6 years (or Grade 6)",
                                "7 years (or Grade 7)" ,
                                "8 years (or Grade 8)",
                                "9 years (or Grade 9)",
                                "10 years (or Grade 10)",
                                 "11 years (or Grade 11)",
                                 "12 years (or Grade 12)",
                                 "13 years (or Grade 13)",
                                 "14 years (or Grade 14)") ~ "yes",
        Age >=20 &   Age < 24 & 
          Level %in% c( "University level",
                                 "Post university level") ~ "yes" ))  |>
      
      dplyr::mutate(EducationEnrollatRightAge = dplyr::if_else(
        is.na(EducationEnrollatRightAge) ,paste0("no"),  EducationEnrollatRightAge )) |>
    
    # View(Individual[ !(is.na(Individual$EducationEnrollShould)) ,
    #                  c("Age",  "EducationEnroll", 
    #                     "EducationEnrollShould", 
    #                     "EducationEnrollatRightAge"#, 
    #                     # "EducationEnrollGross", 
    #                     #"EducationEnrollNet"
    #                    )])
    # 
    # table(Individual$EducationEnroll , useNA = "ifany")
    # table(Individual$EducationEnrollatRightAge , useNA = "ifany")
    # table(Individual$EducationEnrollShould, useNA = "ifany")
    # table(Individual$EducationEnrollatRightAge, Individual$EducationEnrollShould, useNA = "ifany")
    # table(Individual$EducationEnroll, Individual$EducationEnrollShould, useNA = "ifany")
    
    # SE.PRM.CUAT.ZS Educational attainment, at least completed primary, population 25+ years, total (%) (cumulative)
    # SE.SEC.CUAT.LO.ZS Educational attainment, at least completed lower secondary, population 25+, total (%) (cumulative)
    # SE.SEC.CUAT.UP.ZS Educational attainment, at least completed upper secondary, population 25+, total (%) (cumulative)
    # SE.SEC.CUAT.PO.ZS Educational attainment, at least completed post-secondary, population 25+, total (%) (cumulative) 
    # SE.TER.CUAT.DO.ZS Educational attainment, Doctoral or equivalent, population 25+, total(%) (cumulative)
    
    # SE.TER.CUAT.ST.ZS Educational attainment, at least completed short-cycle tertiary, population 25+,total (%) (cumulative)
    # SE.TER.CUAT.BA.ZS Educational attainment, at least Bachelor's or equivalent, population 25+, total (%) (cumulative)
    # SE.TER.CUAT.MS.ZS Educational attainment, at least Master's or equivalent, population 25+, total (%) (cumulative)
    #Individual <- Individual |>
      dplyr::mutate(EducationAttainment = dplyr::case_when(
        Level == "Informal education" ~ "Not Measured",
        Level == "Technical or vocational" ~ "Not Measured",
        Level == "No education" ~ "Not Measured",
        Level == "Kindergarten" ~ "Not Measured",
        Level == "1 year (or Grade 1)" ~ "PRM",
        Level == "2 years (or Grade 2)" ~ "PRM",
        Level == "3 years (or Grade 3)" ~ "PRM",
        Level == "4 years (or Grade 4)" ~ "PRM",
        Level == "5 years (or Grade 5)" ~ "PRM",  
        Level == "6 years (or Grade 6)" ~ "SEC.LO",
        Level == "7 years (or Grade 7)" ~ "SEC.LO",
        Level == "8 years (or Grade 8)" ~ "SEC.LO",
        Level == "9 years (or Grade 9)" ~ "SEC.LO",
        Level == "10 years (or Grade 10)" ~ "SEC.UP",
        Level == "11 years (or Grade 11)" ~ "SEC.UP",
        Level == "12 years (or Grade 12)" ~ "SEC.UP",
        Level == "13 years (or Grade 13)" ~ "SEC.UP",
        Level == "14 years (or Grade 14)" ~ "SEC.UP",
        Level == "University level" ~ "SEC.PO",
        Level == "Post university level" ~ "TER.DO",
        Level == "Unknown" ~ "Not Measured",
        is.na(Level) ~ "Not Measured")) 
    #table(Individual$EducationAttainment, useNA = "ifany")
    
    Individual<- Individual |>
      dplyr::mutate(EducationAttainment = dplyr::if_else( Age <25,
                                                          "Not Applicable",
                                                          EducationAttainment ))
    
    # table(Individual$EducationAttainment, useNA = "ifany")

 
## Occupation - https://ilostat.ilo.org/resources/concepts-and-definitions/description-employment-by-occupation/ 
## EMP_TEMP_SEX_OC2_NB_A -->  ILOSTAt

  ## Isco code to analyse workexperience
  # isco <- readr::read_csv(paste0(mainDirroot,"/data-raw/isco.csv")) 
  isco <- readxl::read_excel( system.file("isco.xlsx", package = "proGresAnalysis") , sheet = "isco") |>
    dplyr::select( - isco_parent2, - isco_parent_name2, 
                    - isco_parent3, - isco_parent_name3, 
                    - level1dup, - level2dup, - level3dup )
# names(isco)

Individual <- Individual |> 
  dplyr::left_join(WorkExperience |>
                     dplyr::mutate(WorkExperienceAsy = WorkType) |>
                     dplyr::mutate(ModifiedOnWorkAsy = ModifiedOn)  |> 
                     dplyr::filter(CountryOfWork == ctr ) |> 
                     dplyr::arrange(desc(ModifiedOnWorkAsy)) |> 
                     dplyr::filter(!duplicated(IndividualID, fromLast = FALSE)) |>
                     dplyr::select(IndividualID, WorkExperienceAsy, 
                                   #CountryOfWork,
                                   ModifiedOnWorkAsy),
                   by = c("IndividualID")) |> 
  dplyr::left_join(WorkExperience |>
                     dplyr::mutate(WorkExperience = WorkType) |>
                     dplyr::mutate(ModifiedOnWork = ModifiedOn)  |> 
                     dplyr::filter(CountryOfWork != ctr ) |> 
                     dplyr::arrange(desc(ModifiedOnWork)) |> 
                     dplyr::filter(!duplicated(IndividualID, fromLast = FALSE)) |>
                     dplyr::select(IndividualID, 
                                   WorkExperience, 
                                   CountryOfWork,
                                   ModifiedOnWork),
                   by = c("IndividualID"))   |> 

#Individual <- Individual |> 
  dplyr::left_join(isco, 
                    by = c("WorkExperience" = "isco_name"))  |> 
  dplyr::left_join(isco, 
                    by = c("WorkExperienceAsy" = "isco_name"))  |> 
  dplyr::mutate( Lskill = max(LSkill.x, LSkill.y),
                 isei = max(isei.x,isei.y),
                 siops = max(siops.x, siops.y),
                 isco_parent1 = max(isco_parent1.x, isco_parent1.y) )


 ## Specific Needs ########################
SpecificNeed <- SpecificNeed |> 
  dplyr::mutate( SpecificNeedSub = paste0( SPNCategory,
                                  if_else( is.na(`SPNSub.Category`),
                                           paste0(""),
                                           paste0("- ", `SPNSub.Category`))))

 ## Filter Assistance type ################
Assistance <-  Assistance |>
  dplyr::mutate( AssistanceSub = paste0( AssistanceType,
                                          dplyr::if_else( is.na(`AssistanceSub.Type`),
                                                          paste0(""),
                                                          paste0("-", `AssistanceSub.Type`)),
                                          dplyr::if_else( is.na(`AssistanceSub.Sub.Type`),
                                                                   paste0(""),
                                                                   paste0("- ", `AssistanceSub.Sub.Type`)) ))|>
  dplyr::mutate( AssistanceCash =  dplyr::if_else( stringr::str_detect(AssistanceSub,  "cash" ),
                                                          TRUE,
                                                          FALSE))  |>
  dplyr::mutate( AssistanceCash =  dplyr::if_else( stringr::str_detect(AssistanceSub,   "Cash") ,
                                                    TRUE,
                                                    FALSE))  |>
  dplyr::mutate( AssistanceWASH =  dplyr::if_else( stringr::str_detect(AssistanceSub,  "WASH" ),
                                                    TRUE,
                                                    FALSE))  |>
  dplyr::mutate( AssistanceShelter =  dplyr::if_else( stringr::str_detect(AssistanceSub,   "Shelter") ,
                                                    TRUE,
                                                    FALSE))   |> 
 dplyr::mutate( AssistanceYear = lubridate::year(lubridate::as_date(ActualStartDate))  )
 

# table(Asstype$AssistanceSub, useNA = "ifany")
# table(Asstype$AssistanceCash, useNA = "ifany")
# table(Asstype$AssistanceWASH, useNA = "ifany")
# table(Asstype$AssistanceShelter, useNA = "ifany")
# levels(as.factor(Assistance$AssistanceType))

#  aggregateAtCaseLevel ####################

## variables are then aggregated to Registration Case level which is the main unit of analysis
## Aggregate key information at case level #####
RegistrationGroupall <- RegistrationGroup |> 
  
  
  ## Add gender, age group of representative #######
  dplyr::left_join(Individual |> 
                   dplyr::filter(RelationshipToFP == "Focal Point")   |>
                   dplyr::select(RegistrationGroupID, Age, Sex) |>
                   dplyr::mutate( AgeFP = Age,
                                  SexFP = Sex) |>
                   dplyr::select(-Age, -Sex)    , # |>
                 by = c("RegistrationGroupID")) |>
  
  dplyr::filter(!(is.na(SexFP)) ) |>
  ## Case when there's no Focal Point
  # #   table(RegistrationGroupall$SexFP, useNA = "ifany")
  # View( Individual |>
  #         dplyr::inner_join(RegistrationGroupall |>
  #                            dplyr::filter(is.na(SexFP))|>
  #                          dplyr::select(RegistrationGroupID),                          , 
  #                          by = c("RegistrationGroupID")) )
  
  
  ##  WorkExperience skill level #######
# dplyr::left_join(Individual |> 
#                    dplyr::group_by( RegistrationGroupID ) |>
#                    dplyr::summarise ( 
#                      EducRankMax = max(Ranking),
#                      OccupMaxSkill = max(Lskill),
#                      OccupMaxisei = max(isei),
#                      OccupMaxsiops = max(siops),
#                      OccupMaxisco_parent1 = max(isco_parent1)
#                    ),
#                  by = c("RegistrationGroupID")) |>
  
  
  ## Case Size #####
  dplyr::mutate(GroupSize1 = cut(GroupSize, 
                               breaks = c(0,1,2,3,4,5, 60),
                               labels = c("Size1", "Size2", "Size3",
                                          "Size4", "Size5", "Size6+"))) |>
  
  
  ## Add HH Ratio Dependency, , average & standard deviation age ..  ####
  dplyr::left_join(Individual |> 
                   dplyr::group_by( RegistrationGroupID    ) |>
                   dplyr::summarise ( totalInd = dplyr::n(),
                                      totalF =  sum(Sex == "Female"),
                                      totalWorkingAge =  sum(Age >=15 & Age < 60),
                                      totalYouth =  sum(Age <15  ),
                                      totalEldern =  sum(Age > 60) ,
                                      ageAvg = mean(Age),
                                      ageSd = sd(Age) ),
                 by = c("RegistrationGroupID")) |>
  
  ## Remove records with no match case t Ind
  dplyr::filter(!(is.na(totalInd))) |>
  
  ## Discretise Average & SD for age
  # table(RegistrationGroupall$ageAvg, useNA= "ifany") hist(RegistrationGroupall$ageAvg)
  dplyr::mutate(ageAvgCat = dplyr::case_when(
    ageAvg <= 18   ~ "below.18", 
    ageAvg > 18 & ageAvg <= 35  ~ "between.19.35",
    ageAvg > 35 & ageAvg <= 59  ~ "between.36.59",
    ageAvg > 59 ~ "over.60")) |>
  dplyr::mutate(ageAvgCat = factor(ageAvgCat, 
                                   levels = c("below.18", "between.19.35", "between.36.59", 
                                              "over.60"))) |>
  # table(RegistrationGroupall$ageAvgCat, useNA= "ifany")
  
  # table(RegistrationGroupall$ageSd, useNA= "ifany") hist(RegistrationGroupall$ageSd)
  dplyr::mutate(ageSdCat = dplyr::case_when(
    is.na(ageSd) ~ "unique",  
    ageSd <= 5   ~ "below.5",  
    ageSd > 5 & ageSd <= 10  ~ "between.6.10",
    ageSd > 10 & ageSd <= 20  ~ "between.11.20",
    ageSd > 20 ~ "over.21")) |>
  dplyr::mutate(ageSdCat = factor(ageSdCat, 
                                  levels = c("unique","below.5", "between.6.10", "between.11.20", 
                                             "over.21"))) |>
  # table(RegistrationGroupall$ageSdCat, useNA= "ifany")
  
  #table(RegistrationGroupall$ratio_f, useNA= "ifany") hist(RegistrationGroupall$ratio_f)
  dplyr::mutate ( ratioFemale = totalF/ totalInd ) |>
  dplyr::mutate(ratioFemaleCat = dplyr::case_when(
    ratioFemale == 0 ~ "no.female", 
    ratioFemale > 0 & ratioFemale < 0.5  ~ "few.female",
    ratioFemale == 0.5 ~ "half.female",
    ratioFemale > 0.5 & ratioFemale < 1  ~ "majority.female",
    ratioFemale == 1 ~ "all.female")) |>
  dplyr::mutate(ratioFemaleCat = factor(ratioFemaleCat, 
                                        levels = c("no.female", "few.female", "half.female", 
                                                   "majority.female", "all.female"))) |>
  
  dplyr::mutate ( ratioDependant = totalWorkingAge / totalInd ) |>
  dplyr::mutate(ratioDependantCat = dplyr::case_when(
    ratioDependant == 0 ~ "all.dependant", 
    ratioDependant > 0 & ratioDependant < 0.5  ~ "few.dependant",
    ratioDependant == 0.5 ~ "half.dependant",
    ratioDependant > 0.5 & ratioDependant < 1  ~ "majority.dependant",
    ratioDependant == 1 ~ "no.dependant")) |>
  dplyr::mutate(ratioDependantCat = factor(ratioDependantCat, 
                                           levels = c("no.dependant", "few.dependant", "half.dependant",
                                                      "majority.dependant", "all.dependant"))) |>
  
  # table(RegistrationGroupall$ratioDependantCat, useNA= "ifany")
  # View(RegistrationGroupall[ is.na(RegistrationGroupall$ratioDependantCat), ])
  
  dplyr::mutate ( ratioYouth = totalYouth/ totalInd ) |>
  dplyr::mutate(ratioYouthCat = dplyr::case_when(
    ratioYouth == 0 ~ "no.youth", 
    ratioYouth > 0 & ratioYouth < 0.5  ~ "few.youth",
    ratioYouth == 0.5 ~ "half.youth",
    ratioYouth > 0.5 & ratioYouth < 1  ~ "majority.youth",
    ratioYouth == 1 ~ "all.youth")) |>
  dplyr::mutate(ratioYouthCat = factor(ratioYouthCat, 
                                       levels = c("no.youth", "few.youth", "half.youth", 
                                                  "majority.youth", "all.youth"))) |>
  
  
  dplyr::mutate ( ratioEldern = totalEldern/ totalInd ) |>
  dplyr::mutate(ratioEldernCat = dplyr::case_when(
    ratioEldern == 0 ~ "no.eldern", 
    ratioEldern > 0 & ratioEldern < 0.5  ~ "few.eldern",
    ratioEldern == 0.5 ~ "half.eldern",
    ratioEldern > 0.5 & ratioEldern < 1  ~ "majority.eldern",
    ratioEldern == 1 ~ "all.eldern")) |>
  dplyr::mutate(ratioEldernCat = factor(ratioEldernCat, 
                                        levels = c("no.eldern", "few.eldern", "half.eldern", 
                                                   "majority.eldern", "all.eldern"))) |>
  
  
  
  dplyr::select ( - ratioEldern)  |>
  dplyr::select ( - ratioYouth)  |>
  dplyr::select ( - ratioDependant)  |>
  dplyr::select ( - ageAvg)  |>
  dplyr::select ( - ageSd)  |>
  
  
  ## Add marital Status #######
  dplyr::left_join(Individual |> 
                   tidyr::pivot_wider(id_cols = c("RegistrationGroupID") ,
                                      names_from = MaritalStatusCat,
                                      values_from = "IndividualID",
                                      values_fn =  length ),
                 by = c("RegistrationGroupID")) |>
  
  
  ## Add aggregated spNeeds  #######
  dplyr::left_join(SpecificNeed |> 
                   dplyr::left_join( y = Individual,
                                     by = c("IndividualID") ) |> 
                   dplyr::group_by( RegistrationGroupID, SPNCategory   ) |> 
                   dplyr::summarise(n = dplyr::n())  |> 
                   dplyr::filter( ! (is.na(RegistrationGroupID) ))  |>
                   tidyr::pivot_wider(names_from  = SPNCategory,
                                      values_from = n) ,
                 by = c("RegistrationGroupID")) |>
  
  
  ## Add count of needs within Case
  dplyr::left_join(SpecificNeed |> 
                     dplyr::left_join( y = Individual,
                                       by = c("IndividualID") ) |> 
                     dplyr::group_by( RegistrationGroupID   ) |> 
                     dplyr::summarise(countneed = dplyr::n()),
                   by = c("RegistrationGroupID")) |>
  
  ## Add Assistance Records #######
  dplyr::left_join(Assistance |> 
                   # filter( AssistanceYear == 2020) |> 
                   dplyr::left_join( y = Individual,
                                     by = c("IndividualID", "RegistrationGroupID") ) |> 
                   dplyr::group_by( RegistrationGroupID, AssistanceCash   ) |> 
                   dplyr::summarise(n = dplyr::n()) |> 
                   filter( ! (is.na(RegistrationGroupID) ))  |>
                   tidyr::pivot_wider(names_from  = AssistanceCash,
                                      names_glue = "{AssistanceCash}_{.value}",
                                      values_from = n) |>
                   dplyr:: mutate( AssistanceCash =  dplyr::case_when(
                     TRUE_n >= 0  & is.na(FALSE_n) ~ "All.case.get.cash",
                     TRUE_n >= 0  & FALSE_n >= 0 ~ "Some.members.get.cash",
                     is.na(TRUE_n) ~ "No.cash"))  |>
                   dplyr::select ( - TRUE_n)  |>
                   dplyr::select ( - FALSE_n)  ,
                 by = c("RegistrationGroupID")) |> 
 
    dplyr:: mutate( AssistanceCash2 =  dplyr::if_else( is.na(AssistanceCash),
                                                     "No.cash",
                                                     AssistanceCash))  |>
    dplyr:: mutate( AssistanceCashBol =  dplyr::if_else( AssistanceCash2 == "No.cash",
                                                       FALSE,TRUE
                                                        )) |> 
    dplyr:: mutate( GotAssistance =  dplyr::if_else( is.na(AssistanceCash),
                                                   FALSE,TRUE
                                                        )) |>
    dplyr::select ( - AssistanceCash) |>   
  
  # dplyr::left_join(Assistance |> 
  #                    # filter( AssistanceYear == 2020) |> 
  #                    dplyr::left_join( y = Individual) |> 
  #                    dplyr::group_by( RegistrationGroupID, AssistanceSub   ) |> 
  #                    dplyr::summarise(n = dplyr::n()) |> 
  #                    filter( ! (is.na(RegistrationGroupID) ))  |>
  #                    tidyr::pivot_wider(names_from  = AssistanceSub,
  #                                       values_from = n)    )  |> 
  
  #RegistrationGroupall1 <- RegistrationGroupall  |> 
# 
#   library(dplyr)
# library(tidyr)
# df |> mutate(val=1) |> 
#   pivot_wider(names_from = country,
#               values_from = val) |> 
#   mutate(across(-RegistrationGroupID, ~replace_na(.x, 0))) |>
#   mutate(across(-RegistrationGroupID, ~ifelse(.x==1, TRUE,FALSE)))

## Clean  that fame... ######
## Replace NA by 0 
  dplyr::select ( - OwningOffice)  |>
  dplyr::select ( - WillingToReturn)  |>
  dplyr::select ( - BusinessUnit)  |>
  dplyr::filter(!(is.na(GroupSize1))) |> 

    
    
  ## Some records have missing age info preventing ratio to be calculated
  # table(RegistrationGroupall$ageAvgCat, useNA = "ifany")
  # View(RegistrationGroupall[ is.na(RegistrationGroupall$ageAvgCat), ])
  dplyr::filter(!(is.na(ageAvgCat)))  |>
  dplyr::mutate( dplyr::across(where(is.integer), ~ tidyr::replace_na(.x, 0)) ) |>
#  dplyr::mutate( dplyr::across(dplyr::everything(), ~ tidyr::replace_na(.x, 0)) ) |>
#  replace(is.na(), 0) #|>
#RegistrationGroupall1 <- RegistrationGroupall |> 
  #  dplyr::mutate(dplyr::across(everything(), ~ replace_na(.x, 0))) |>
  dplyr::mutate(dplyr::across( where(is.integer), ~ dplyr::if_else( .x > 0 , TRUE,FALSE) ) ) |>
  
  ## Clean variable name
  janitor::clean_names()
  


## Filter popdata for the country report
popdatactr <-   popdata::pd_asr("demographics", year = 2021)  %>% 
  as.data.frame() %>% 
  #mutate( total = as.integer(total))  %>%
  dplyr::left_join( y= unhcrdatapackage::reference, 
                    by = c("asylum" = "UNHCRcode"))  %>%
  dplyr::filter(ctryname  == ctr ) %>%
  dplyr::select(ctryname , populationType, total) %>%
  dplyr::group_by( ctryname, populationType  ) %>%
  dplyr::summarise(totalasr = sum( total) )  %>%
  mutate(LegalStatus = case_when(
                 populationType == "ASY" ~ "Asylum Seeker",
                 populationType == "HST" ~ "Not of concern", 
                 populationType == "IDP" ~ "Internally displaced person",
                 populationType == "OOC" ~ "Other of concern",
                 populationType == "RDP" ~ "Returned IDP",
                 populationType == "REF" ~ "Refugee",
                 populationType == "RET" ~ "Returnee",
                 populationType == "ROC" ~ "???",
                 populationType == "STA" ~ "Stateless (non-refugee)",
                 populationType == "VDA" ~ "Other of concern")) %>%
  dplyr::select(LegalStatus, totalasr)  %>%
  dplyr::group_by( LegalStatus ) %>%
  dplyr::summarise(totalasr = sum( totalasr) ) 

 #require(wbstats)
 wb_data <- wbstats::wb_data(
  indicator = c( "SE.PRM.CUAT.ZS", # Educational attainment, at least completed primary, population 25+ years, total (%) (cumulative)
                 "SE.SEC.CUAT.LO.ZS", # Educational attainment, at least completed lower secondary, population 25+, total (%) (cumulative)
                 "SE.SEC.CUAT.UP.ZS", # Educational attainment, at least completed upper secondary, population 25+, total (%) (cumulative)
                 "SE.SEC.CUAT.PO.ZS", # Educational attainment, at least completed post-secondary, population 25+, total (%) (cumulative) 
                 "SE.TER.CUAT.DO.ZS",  # Educational attainment, Doctoral or equivalent, population 25+, total(%) (cumulative)
                 "SE.TER.CUAT.ST.ZS", # Educational attainment, at least completed short-cycle tertiary, population 25+,total (%) (cumulative)
                 "SE.TER.CUAT.BA.ZS", # Educational attainment, at least Bachelor's or equivalent, population 25+, total (%) (cumulative)
                 "SE.TER.CUAT.MS.ZS", # Educational attainment, at least Master's or equivalent, population 25+, total (%) (cumulative)  
                 "SE.PRE.ENRR", # School enrollment, preprimary (% gross)
                 "SE.PRM.ENRR", # School enrollment, primary (% gross)
                 "SE.SEC.ENRR", # School enrollment, secondary (% gross)
                 "SE.TER.ENRR" # School enrollment, tertiary (% gross)
                   ),
  #start_date = "2010",
  mrv = 1,
  country = ctr,
  return_wide = FALSE) |>
  dplyr::select( indicator_id, indicator, date, value ) |>
  dplyr::mutate( source = "UNESCO Institute for Statistics")

  
  progres <- list(Individual, #[1]  
                  RegistrationGroup, #[2] 
                  Assistance , #[3] 
                  Document , #[4] 
                  Education , #[5] 
                  EntitlementCard , #[6] 
                  IndividualProperty , #[7] 
                  Language , #[8] 
                  Nationality , #[9] 
                  Relative , #[10] 
                  Representative , #[11] 
                  Skill , #[12] 
                  SocioEconomic , #[13] 
                  SpecificNeed , #[14] 
                  Transit , #[15] 
                  WorkExperience,  #[16]
                  RegistrationGroupall, #[17]
                  popdatactr, #[18] 
                  wb_data) #[19]
  return(progres)
    
    
  }
