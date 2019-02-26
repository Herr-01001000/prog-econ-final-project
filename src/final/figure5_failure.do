/*
The file "figure5_failure.do" creates the figure, plotting bank failure development
from the corresponding dta-file in the data directory "data_collapse.dta". 
It writes the results to eps file "figure5_failure.eps".
*/


clear
include project_paths
log using `"${PATH_OUT_FIGURES}/log/`1'.log"', replace
graph set window fontface "Times New Roman"


// Import Data
use "${PATH_OUT_DATA}/data_collapse.dta"


// Figure 5: Bank failures development
twoway (bar failure year, barwidth(0.5) color(gs13)) ///
	(line failure year, clcolor(red) clwidth(thick)), ///
	title("County Averaged Bank Failures Growth") ///
	xtitle("Year") xlabel(2007(1)2017) xtick(2007(1)2017) ///
	ytitle("Bank Failures") caption("Data Source: Summary of Deposits", size(small)) ///
	legend(label(1 "Bar Graph") label(2 "Line Graph") order(1 2) ring(0) pos(2) ///
	cols(1) region(lwidth(none))) scheme(s1color) graphregion(margin(tiny))	
graph export "${PATH_OUT_FIGURES}/`1'.eps", replace
