/* 
The file "data_prep_sod_append.do" convertes all processed data from 
Summary of Deposits to one big data file for further analysis.
*/


// Header do-File with path definitions, those end up in global macros.
clear
include project_paths
log using `"${PATH_OUT_DATA}/log/`1'.log"', replace

use "${PATH_OUT_DATA}/sod_2007.dta"
forvalues year = 2008(1)2017 {
	append using "${PATH_OUT_DATA}/sod_`year'.dta"
}

rename stalpbr state

sort zip_code year
by zip_code: gen L_failure = failure[_n-1]
by zip_code: gen L_hhi = hhi[_n-1]

label variable failure "Number of bank failures"
label variable L_hhi "First lag of HHI"


save "${PATH_OUT_DATA}/sod.dta", replace
log close
