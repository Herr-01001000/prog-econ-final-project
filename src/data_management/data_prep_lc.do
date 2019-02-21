/* 
The file "data_prep_lc.do" convertes all original data from Lending Club to 
one big data file for further analysis.

Note: Due to the size of loan data is too large, I don't include them under 
versioncontrol. They can be downloaded from "DOWNLOAD LOAN DATA" on
Lending Club's website.
Data source: https://www.lendingclub.com/info/download-data.action
*/


// Header do-File with path definitions, those end up in global macros.
clear
include project_paths
log using `"${PATH_OUT_DATA}/log/`1'.log"', replace


// Read in file names
do `"${PATH_OUT_MODEL_SPECS}/file_names"'


// Generate all loan data
global list ${lending_club}
foreach name in $list {
	import delimited "${PATH_IN_DATA}/`name'.csv", varnames(2) rowrange(2) clear
	drop if loan_amnt==.
	compress
	save "${PATH_OUT_DATA}/`name'.dta", replace
}


// Make one big file until 2017
clear
local loan ${lending_club}
gettoken 3a rest: loan, parse(" ")
use "${PATH_OUT_DATA}/`3a'.dta"
foreach name of local rest {
	append using "${PATH_OUT_DATA}/`name'.dta", force
}


gen year=substr(issue_d,5,4)
destring year, replace


save "${PATH_OUT_DATA}/LoanStats_all.dta", replace
log close
