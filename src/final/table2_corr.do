/*
The file "table2_corr.do" creates table 2 with the correlation matrix
of the main indicators (log_loan_amnt log_loan_no log_bank_loan
log_bank_loan_c failure hhi internet income unemployment bachelor young poverty) 
from the corresponding dta-file in the data directory "data_all.do".
*/


clear
include project_paths
log using `"${PATH_OUT_TABLES}/log/`1'.log"', replace
graph set window fontface "Times New Roman"


// Import data
use "${PATH_OUT_DATA}/data_all.dta"


// Table 2: Correlation Matrix
eststo clear
eststo: qui estpost correlate log_loan_amnt log_loan_no log_bank_loan failure ///
	hhi internet income unemployment bachelor young poverty, matrix
esttab est* using "${PATH_OUT_TABLES}/`1'.tex", booktabs long ///
	unstack replace style(tex) drop() noobs nonumbers nodepvars nomtitles ///
	noomitted varwidth(25)

