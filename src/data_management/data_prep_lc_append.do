/* 
The file "data_prep_lc_append.do" convertes all processed data from Lending Club
to one big data file for further analysis.
*/


// Header do-File with path definitions, those end up in global macros.
clear
include project_paths
log using `"${PATH_OUT_DATA}/log/`1'.log"', replace


// Read in file names
do `"${PATH_OUT_MODEL_SPECS}/file_names"'


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

keep loan_amnt funded_amnt funded_amnt issue_d addr_state year zip_code
gen id = _n

collapse (count) loan_no=id (sum) loan_amnt , by(zip_code year addr_state)
egen county_id = group(zip_code)
rename addr_state state

save "${PATH_OUT_DATA}/LoanStats_all.dta", replace
log close
