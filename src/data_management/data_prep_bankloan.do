/* 
The file "data_prep_bankloan.do" cleans the data from area_report_by_year.xlsx.
It prepares the dataset we use for further analysis.

Data source: FRBNY Consumer Credit Panel / Equifax
*/


// Header do-File with path definitions, those end up in global macros.
clear
include project_paths
log using `"${PATH_OUT_DATA}/log/`1'.log"', replace


// Read in file names
do `"${PATH_OUT_MODEL_SPECS}/file_names"'

global list ${bankloan}
foreach name in $list {
	import excel "${PATH_IN_DATA}/area_report_by_year.xlsx", ///
		sheet("`name'") cellrange(A4:P57) firstrow clear

	drop if state == "allUS"

	reshape long Q4_, i(state) j(year)
	drop if year < 2007
	rename Q4_ bank_loan_pc_`name'
	label variable bank_loan_pc_`name' "Household `name' debt balance per capita(dollars)"

	sort state year

	save "${PATH_OUT_DATA}/bankloan_`name'.dta", replace
}


// Make one big file
clear
local loan ${bankloan}
gettoken first rest: loan, parse(" ")

use "${PATH_OUT_DATA}/bankloan_`first'.dta"
foreach name of local rest {
	merge 1:1 state year using "${PATH_OUT_DATA}/bankloan_`name'.dta"
	drop if _merge==2
	drop _merge
}


save "${PATH_OUT_DATA}/bankloan.dta", replace
log close
