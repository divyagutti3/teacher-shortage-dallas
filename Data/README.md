# Data Sources

Main data sources include Texas Education Agency educator reports and data, selected Texas ISD recruitment websites, and, if feasible, publicly available substitute staffing data.

**A. Texas Education Agency (TEA) Administrative Data**
The first source will be TEA’s publicly available educator reports and data. The team will review TEA educator reports and datasets for indicators related to teacher employment, certification, new hires, attrition, and retention. Each source will be assessed for its geographic coverage, reporting period, and level of detail. In particular, the team will determine whether the available data contain directly comparable district-level measures of vacancies or whether other workforce indicators are more appropriate. The project will not treat these indicators as direct measures of vacancies unless their definitions support that interpretation. 

The team will also use the TEA Regional Dashboards to identify and review available district-level educator workforce indicators.
Potential datasets include:
   - Newly Certified and New Teacher Hires
   - Educator Employment
   - Educator Attrition and Retention
   - Educator and Certificate Production
   - Teacher FTE Counts and Student Course Enrollment

**B. ISD Recruitment Websites**
The team will collect teacher job advertisements from selected ISD recruitment websites. For each listing, the dataset will record the district, school where available, job title, subject or grade level, posting date where available, collection date, source, and URL. The team will investigate whether the recruitment platforms provide accessible APIs or structured data endpoints. If automated collection is not feasible or permitted, a manual collection method will be considered. Duplicate listings will be identified and handled using consistent rules so that the same position is not counted multiple times.

The team identified recruitment websites for independent school districts serving any portion of Dallas County. Because districts use different recruitment platforms, the accessibility and technical structure of the websites vary. The team reviewed each site to identify the recruitment platform, whether the site is dynamically generated, and whether robots.txt or related access checks indicate restrictions on automated collection. These characteristics will help determine whether data can be collected through automated methods or whether manual collection will be required.

 *Table 1:* Independent School District Recruitment Websites and Data Collection Characteristics

| Independent School District | Recruitment Platform | Site Type | Access / robots.txt Notes |
|---|---|---|---|
| [Irving ISD](https://irvingisd.schoolspring.com/) | SchoolSpring | Dynamic | No disallowed paths identified |
| [Dallas ISD](https://aa142.taleo.net/careersection/ext/jobsearch.ftl) | Oracle Taleo | Dynamic | `robots.txt` unavailable; path check returned `TRUE` |
| [Richardson ISD](https://www.applitrack.com/risd/OnlineApp/default.aspx?all=1) | AppliTrack | Dynamic | Parent `robots.txt` available |
| [Highland Park ISD](https://app.txedjobnetwork.org/ords/r/vai/recruit-ai-applicants/organization-job-postings) | Texas Education Job Network | Dynamic | Automated scraping disallowed |
| [Carrollton-Farmers Branch ISD](https://www.applitrack.com/cfbisd/onlineapp/) | AppliTrack | Dynamic | Parent `robots.txt` available |
| [Cedar Hill ISD](https://finance.chisd.net/Business/web/rappljoblst484.w) | District recruitment system | To be determined | Access rules require further review |
| [Coppell ISD](https://apps2.winocular.com/coppell/workspace/wSpace.exe?Action=wsJobsMain) | WinOcular | Dynamic | Path check returned `TRUE` |
| [DeSoto ISD](https://desoto.teams.hosting/submission/EntryPointBrowseJobPostingsAction.do?applicantType=external) | TEAMS | Dynamic | Path check returned `TRUE` |
| [Duncanville ISD](https://skyward.iscorp.com/p12finduncanvilletx/web/rappljoblst484.w?hqrbgrtid=165162) | Skyward | Dynamic | Path check timed out; `robots.txt` retrievable |
| [Garland ISD](https://www.applitrack.com/garlandisd/onlineapp/default.aspx?all=1) | AppliTrack | Dynamic | Path check error; `robots.txt` retrievable |
| [Grand Prairie ISD](https://skyward.iscorp.com/p12fingrandprairietx/web/rappljoblst484.w) | Skyward | Dynamic | Path check timed out; `robots.txt` retrievable |
| [Lancaster ISD](https://www.applitrack.com/lancasterisd/onlineapp/default.aspx?all=1) | AppliTrack | Dynamic | Path check error; `robots.txt` retrievable |
| [Mesquite ISD](https://www.applitrack.com/MesquiteISD/onlineapp/default.aspx?all=1) | AppliTrack | Dynamic | Parent `robots.txt` available |
| [Sunnyvale ISD](https://www.applitrack.com/MesquiteISD/onlineapp/default.aspx?all=1) | AppliTrack | Dynamic | URL to be verified |
| Grapevine-Colleyville ISD (split district) | To be documented | TBD | Serves a portion of Dallas County |
| Ferris ISD (split district) | To be documented | TBD | Serves a portion of Dallas County |


**C. Potential Supplementary Data on Substitute Teachers**
Substitute staffing may provide an additional indication of unmet demand, particularly if districts publish information on substitute requests and the proportion of assignments filled:

$$\text{Fulfillment Rate} = \frac{\text{Filled Substitute Requests}}{\text{Total Substitute Requests}} \times 100$$

However, job advertisements for substitute teachers alone would not show how often districts fail to fill assignments. This component will be included only if reliable and sufficiently comparable data are available.

### Data Structure and Collection

The collected information will be organized into linked datasets containing district characteristics, advertised positions, and relevant workforce indicators. Descriptive statistics will be used to examine differences between districts and, where the data permit, differences across subject areas or grade levels.

*Table 2:* Planned Datasets and Variables for Analysis
Dataset	Potential variables

| Dataset | Potential Variables |
|---|---|
| ISD characteristics | District identifier, county, enrollment, number of schools, reporting year |
| Advertised teacher positions | District, school, position title, subject, posting date, collection date, source, URL |
| Teacher workforce indicators | District, year, teacher employment, certification, new hires, attrition or retention |
| Substitute staffing (if available) | District, date or reporting period, requests, filled assignments, unfilled assignments |

The ISD will be the primary unit of analysis. County will be used to define the geographic scope and identify the districts included in the study, rather than as the unit of analysis. 

The team will also document missing information, inconsistencies in job titles, duplicate advertisements, and differences in the periods covered by each source. These issues are important because apparent differences between districts may partly reflect differences in reporting or recruitment practices rather than differences in staffing demand. 

The team will also document differences in the definitions and time periods used by the various sources. Current job postings, for example, may not be directly comparable to annual workforce statistics.
