# proGres-analysis

Script for advanced statistical analysis of Refugee Registration database & assistance tracking

* Basic demographic variables

* Specific needs

* Case management events

* Individual assistance events

## Output

The package is designed to work on a standard query in the registration database that aggregates key variables at houshold levels

Many reports are already produced from proGres but they mostly look at univariate analysis, i.e each variable within the dataset is displayed one by one. The present document is an attempt to explore various dimensions interact between each others. 


## Data description

The information recorded in the Refugee Registration Database covers not only basic demographic characteristics but also identification of Specific Needs and recording of Events such as Resettlement Acceptation or Voluntary Departure. UNHCR Registration system is described in the [Handbook for Registration](http://www.unhcr.org/4a278ea1d.pdf) and particularly in the [annex 7](https://drive.google.com/file/d/0BzY6xxaS0lO3TXYwaUpzWi1zTW8/view) that displays the Standard Categories and Codes.

The used dataset correspond to the analysis of all cases (i.e. group of individuals registered together that often corresponds to a family unit or household) whose status is **active** within the database. Some of the indivdual information is kept for the head of household.

### Household Level Information

Variable          | Description
------------------|---------------------------------------
Num_Inds          | Number of Individual in the household
Case.size         | Size of the household - Discretisation & recategorisation of the *Num_Inds* variable
Child_0_14        | Number of Child under 14 in the household
Youth_15_17       | Number of Youth between 15 & 17 years old in the household
Work_15_64        | Number of Working age Individual (15-) in the household
Eldern_65         | Number of Working age Individual (15-) in the household
dependency        | [Dependency Ratio](https://en.wikipedia.org/wiki/Dependency_ratio) (Child + Eldern / Working)
youthdependency   | Youth Dependency Ratio (Child + Eldern / Working)
elederndependency | Youth Dependency Ratio (Child + Eldern / Working)
Male              | Number of Male in the Household
Female            | Number of Female in the Household
female.ratio      | % of Female in the Household categorised in 5 classes 
AVG_Age           | Average age within the household
AVGAgecohort      | Average age within the household categorised in 5 classes
STDEV_Age         | Standard Deviation of ages within the household
STDEVAgeclass     | Standard Deviation of ages within the household categorised in 5 classes


### Information related to the head of household

Variable          | Description
------------------|---------------------------------------
dem_age           | Age of the Head
agecohort         | Age of the head of Household categorised in 5 classes
dem_sex           | Sex of the head of Household
dem_marriage      | Marrital status of the head of Household.
dem_marriagecat   | Recategorisation of the *dem_marriage* variable
dem_birth_country | Birth Country of the head of Household. 
occupation        | Occupation type  of the head of Household according to [International Standard Classification of Occupations](http://www.ilo.org/public/english/bureau/stat/isco/isco08/) 
occupationcat     | Recategorisation of the *occupation* variable
edu_highest       | Highest edcuation level of the head of Household 
edu_highestcat    | Recategorisation of the *edu_highest* variable

### Geographic Information

Variable                 | Description
-------------------------|---------------------------------------
CountryOrigin            | Three letters code for Country of Origin.
CountryOriginCategory    | Recategorised Country of origin - classes with low numbers are aggregated.
cool1                    | Administrative level 1 in Country of Origin- classes with low numbers are aggregated. Unknown adresses are recorded as 'other'. 
CountryAsylum            | Three letters code for Country of Asylum.
coal1                    | Administrative level 1 in Country of Asylum- classes with low numbers are aggregated. Unknown adresses are recorded as 'other'. 

### Chronologic Information

Variable             | Description
---------------------|---------------------------------------
YearArrival          | Year of Arrival
YearArrivalCategory  | Discretisation & recategorisation of the *Year of Arrival* variable
Montharrival         | Month of Arrival
season               | Discretisation & recategorisation of the *Month of Arrival* variable


### Specific need within household

The [Specific Needs Codes](https://drive.google.com/file/d/0B95I9qaU50xgYWNpSWxXNGhTaUk/view) provide a standardized and exhaustive list of an individual’s particular characteristics, background, or risks that may provoke protection exigencies. UNHCR used the  [Heightened Risk Identification Tool](http://www.refworld.org/docid/4c46c6860.html) to identify specific needs.

The 10 Categories below are then subdivided in finer categories.

Variable                                    | Description
--------------------------------------------|---------------------------------------
Unaccompanied.or.separated.child            | Certain Unaccompanied & separated child applicants (under 18 years)
Child.at.risk                               | Chidl at risk because of Child-headed household,special education needs. Not at School, in conflict with the law, etc.
Woman.at.risk                               | Women with special needs or who are at risk in the host country. May include single women or women who are members of family or household, as well as women that are survivors of violence
Older.person.at.risk                        | Elderly asylum-seekers without support in the host country
Serious.medical.condition                   | Asylum-seekers who require urgent medical assistance
Disability                                  | Disabled asylum-seekers without necessary support
SGBV                                        | Victims of Sex & Gender Based Violence
Single.parent                               | May be either a man or a woman. Also may be girl or a boy under the age of 18 years.
Specific.legal.physical.protection.needs    | Persons manifestly in need of protection intervention (i.e. with urgent protection needs in the host country)
Torture                                     | Victims of torture and persons suffering from trauma
Family.unity                                | in need of Family Reunification



## Installation

You can install `proGresAnalysis` from GitHub with:

```{r gh-installation, eval = FALSE}
# install.packages("devtools")
devtools::install_github("unhcr-americas/proGres-analysis")
```

Users are welcome to flag bugs and or submit feature request [here](https://github.com/unhcr-americas/proGres-analysis/issues/new)

#### Building package documentation 

`devtools::document()`

`devtools::check(document = FALSE)`

`pkgdown::build_site()` 



## Key Research questions for UNHCR Registration data

when analyzing registration data, based on the percentage of the population by sex, age group, and other factors, the following [10 questions](http://www.unhcr.org/47f0a6db2.pdf) can be used:

* Is it the same as the local population? Does it coincide with the data from the country of origin? 

* Is there  a higher-than-average  percentage  of  women?  Children? Older persons? Persons with disabilities? 

* If one group, such as adult men or young children, seems under- or over-represented, find out why. 

* Has the registration team been trained on how to identify and register groups with specific needs and persons at heightened risk? 

* Have groups with specific needs been registered in detail in coordination with community services? If not, why not and how will this be done?

* Have those responsible for registration understood the criteria for unaccompanied and separated children? 

* Does the population profile indicate potential protection risks for any particular group? 

* Who might be at heightened risk? Why? What immediate action isbeing taken to protect these persons? Has a confidential, individual case-management system been established? 

* Do you have data on the leadership structure? Are any groups,especially minorities, youth and women, not represented? If so, why? 

* How does the socio-economic status and ethnic, linguistic and religious composition of the refugee population compare with that of the local host population? 

