/* 
The file "data_prep_sod.do" cleans the data from Summary of Deposits.
It prepares the dataset we use for further analysis.

Note: Due to the size of loan data is too large, I don't include them under 
version control. They can be downloaded from "SOD Download" on
Summary of Deposits's website.
Data source: https://www5.fdic.gov/sod/dynaDownload.asp?barItem=6
*/


// Header do-File with path definitions, those end up in global macros.
clear
include project_paths
log using `"${PATH_OUT_DATA}/log/`1'.log"', replace


// Bank Failure Data
tempfile failure
import delimited "${PATH_IN_DATA}/bank-data.csv", clear

gen state = substr(cityst,-2,.)
gen year_short = substr(faildate,-2,.)
destring year_short, replace
gen year = year_short + 2000
gen id = _n

save `failure', replace


// HHI Data
import delimited "${PATH_IN_DATA}/ALL_`2'.csv", clear

keep year cert brnum namefull stalpbr zipbr depsumbr 

if `2' > 2009 {
	destring depsumbr, replace ignore(",")
}
tostring zipbr,format(%05.0f) replace
gen zip_code = substr(zipbr,1,3) + "xx"

collapse (sum) depsumins=depsumbr, by(zip_code cert namefull year stalpbr)

drop if stalpbr == "AS"
drop if stalpbr == "GU"
drop if stalpbr == "MP"
drop if stalpbr == "PR"
drop if stalpbr == "VI"
drop if stalpbr == "FM"
drop if stalpbr == "MH"
drop if stalpbr == "PW"

bysort zip_code: egen mktshare = pc(depsumins), prop
gen mktshare_2 = mktshare*mktshare

label variable mktshare "Market share"
label variable mktshare_2 "Squared market share"

merge n:1 cert year using `failure'
drop if _merge==2
drop _merge

collapse (count) failure=id (sum) depsum=depsumins hhi=mktshare_2, by(zip_code year stalpbr)

save "${PATH_OUT_DATA}/sod_`2'.dta", replace
log close
