/* 
The file "data_prep_lc.do" cleans all original data from Lending Club for 
further analysis.

Note: Due to the size of loan data is too large, I don't include them under 
version control. They can be downloaded from "DOWNLOAD LOAN DATA" on
Lending Club's website.
Data source: https://www.lendingclub.com/info/download-data.action
*/


// Header do-File with path definitions, those end up in global macros.
clear
include project_paths
log using `"${PATH_OUT_DATA}/log/`1'.log"', replace


// Generate clean loan data from Lending Club
import delimited "${PATH_IN_DATA}/LoanStats`2'.csv", varnames(2) rowrange(2) clear
drop if loan_amnt==.
compress

save "${PATH_OUT_DATA}/LoanStats`2'.dta", replace
log close
