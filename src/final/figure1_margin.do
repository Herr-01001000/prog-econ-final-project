/*
The file "figure1_margin.do" creates two figures, plotting the marginal effects 
among bank failures, HHI and FinTech lending from the corresponding dta-file 
in the data directory "data_all.dta". It writes the results to eps file 
"figure1_margin_failure.eps" and "figure1_margin_hhi.eps".
*/


clear
include project_paths
log using `"${PATH_OUT_FIGURES}/log/`1'.log"', replace
graph set window fontface "Times New Roman"


// Import Data
use "${PATH_OUT_DATA}/data_all.dta"


// Figure 1: Marginal Plot
qui reghdfe log_loan_amnt c.failure##c.hhi internet income unemployment ///
	bachelor young poverty, absorb(year state_id) vce(cluster county_id)
	
margins, dydx(failure) ///
	at(hhi=(0 0.25 0.5 0.75 1))
marginsplot, recast(line) recastci(rarea) yline(0) xlabel(,format(%9.2f)) ///
			ciopt(color(gs13)) ytitle(Cond. marginal effects) ///
			title("Cond. marginal effect of bank failures on log(loan amount)") ///
			xtitle("HHI") scheme(s1color) graphregion(margin(tiny)) 
graph export "${PATH_OUT_FIGURES}/`1'_failure.eps", replace

margins, dydx(hhi) ///
	at(failure=(0 2.5 5 7.5 10))
marginsplot, recast(line) recastci(rarea) yline(0) xlabel(,format(%9.2f)) ///
			ciopt(color(gs13)) ytitle(Cond. marginal effects) ///
			title("Cond. marginal effect of HHI on log(loan amount)") ///
			xtitle("Bank Failures") scheme(s1color) graphregion(margin(tiny))
graph export "${PATH_OUT_FIGURES}/`1'_hhi.eps", replace
