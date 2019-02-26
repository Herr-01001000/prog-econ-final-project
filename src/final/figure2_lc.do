/*
The file "figure2_lc.do" creates two figures, plotting the Lending Club 
loan volume and number development from the corresponding dta-file 
in the data directory "data_collapse.dta". It writes the results to eps file 
"figure2_lc_volume.eps" and "figure2_lc_number.eps".
*/


clear
include project_paths
log using `"${PATH_OUT_FIGURES}/log/`1'.log"', replace
graph set window fontface "Times New Roman"


// Import Data
use "${PATH_OUT_DATA}/data_collapse.dta"


// Figure 2: Lending club loan volume and number development
twoway (bar loan_amnt_b year, barwidth(0.5) color(gs13)) ///
	(line loan_amnt_b year, clcolor(red) clwidth(thick)), ///
	title("Lending Club Loan Volume Growth(in billions of dollars)") ///
	xtitle("Year") xlabel(2007(1)2017) xtick(2007(1)2017) ///
	ytitle("Loan Amount(Billions)") caption("Data Source: Lending Club", size(small)) ///
	legend(label(1 "Bar Graph") label(2 "Line Graph") order(1 2) ring(0) pos(10) ///
	cols(1) region(lwidth(none))) scheme(s1color) graphregion(margin(tiny))	
graph export "${PATH_OUT_FIGURES}/figure2_lc_volume.eps", replace

twoway (bar loan_no year, barwidth(0.5) color(gs13)) ///
	(line loan_no year, clcolor(red) clwidth(thick)), ///
	title("Lending Club Loan Quantity Growth") ///
	xtitle("Year") xlabel(2007(1)2017) xtick(2007(1)2017) ///
	ytitle("Number of Loans") caption("Data Source: Lending Club", size(small)) ///
	legend(label(1 "Bar Graph") label(2 "Line Graph") order(1 2) ring(0) pos(10) ///
	cols(1) region(lwidth(none))) scheme(s1color) graphregion(margin(tiny))	
graph export "${PATH_OUT_FIGURES}/figure2_lc_number.eps", replace
