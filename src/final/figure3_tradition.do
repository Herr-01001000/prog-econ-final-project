/*
The file "figure3_tradition.do" creates the figure, plotting the Traditional 
banking loan amount per capita development from the corresponding dta-file 
in the data directory "bankloan.dta". It writes the results to eps file 
"figure3_tradition.eps".
*/


clear
include project_paths
log using `"${PATH_OUT_FIGURES}/log/`1'.log"', replace
graph set window fontface "Times New Roman"


// Import Data
use "${PATH_OUT_DATA}/bankloan.dta"

gen bank_loan = bank_loan_pc_total * bank_loan_pc_population
collapse (sum) bank_loan, by(year)
gen bank_loan_b = bank_loan / 1000000000
label variable bank_loan_b "Volume Traditional banking loan(billion dollars)"

// Figure 3: Traditional banking loan amount per capita development
twoway (bar bank_loan_b year, barwidth(0.5) color(gs13)) ///
	(line bank_loan_b year, clcolor(red) clwidth(thick)), ///
	title("Traditional Banking Loan Growth") ///
	subtitle("(in billions of dollars)") ///
	xtitle("Year") xlabel(2007(1)2017) xtick(2007(1)2017) ///
	ytitle("Loan Amount(Billions)") ylabel(10000(800)13500) ///
	caption("Data Source: FRBNY Consumer Credit Panel / Equifax", size(small)) ///
	legend(label(1 "Bar Graph") label(2 "Line Graph") order(1 2) ring(0) pos(10) ///
	cols(1) region(lwidth(none))) scheme(s1color) graphregion(margin(tiny))	
graph export "${PATH_OUT_FIGURES}/`1'.eps", replace
