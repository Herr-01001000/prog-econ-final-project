/*
The file "table1_sumstat.do" creates table 1 with the summary statistics
of the main indicators (loan_amnt log_loan_amnt loan_no log_loan_no log_bank_loan
log_bank_loan_c failure hhi internet income unemployment bachelor young poverty) 
from the corresponding dta-file in the data directory "data_all.dta".
It writes the results to LaTeX file "table1_sumstat.tex".
*/


clear
include project_paths
log using `"${PATH_OUT_TABLES}/log/`1'.log"', replace
graph set window fontface "Times New Roman"


// Import Data
use "${PATH_OUT_DATA}/data_all.dta"


// Table 1: Summary Statistics
eststo clear
eststo: qui estpost summarize loan_amnt log_loan_amnt loan_no log_loan_no ///
	log_bank_loan log_bank_loan_c failure hhi internet income unemployment ///
	bachelor young poverty
esttab est* using "${PATH_OUT_TABLES}/`1'.tex", booktabs ///
	unstack cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(2))") ///
	replace style(tex) drop() noobs nonumbers nodepvars nomtitles ///
	prehead("\tabularnewline\hline") postfoot("\bottomrule") noomitted varwidth(25)

