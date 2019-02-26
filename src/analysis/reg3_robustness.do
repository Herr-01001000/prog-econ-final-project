/*
In the file "reg3_robustness.do", we regress the lagged potential FinTech 
drivers and interaction terms on FinTech lending developments to support the 
robustness of previous findings.

The file requires to be called with a model specification as the argument,
a corresponding do-file must exist in ${PATH_OUT_MODEL_SPECS}. That file needs
to define globals:
    
    * ${DEPVAR} - the dependent variables
    * ${lagEXPVAR} - the one year lagged explanatory variables
	* ${intEXPVAR} - the explanatory variables which include interaction terms
    * ${FE} - fix effect variables
    * ${VCE} - standard error cluster variable

Finally, we store a LaTeX file with estimation results.
*/


clear
include project_paths
log using `"${PATH_OUT_ANALYSIS}/log/`1'.log"', replace
graph set window fontface "Times New Roman"

// Read in model specs
do `"${PATH_OUT_MODEL_SPECS}/`1'"'

// Import data
use "${PATH_OUT_DATA}/data_all.dta"


// Regression 3: Robustness test
eststo clear
foreach expvar in lagEXPVAR intEXPVAR {
	global depvars ${DEPVAR}
	foreach depvar in $depvars {
		eststo: qui reghdfe `depvar' ${`expvar'}, absorb(${FE}) vce(cluster ${VCE})
	}
}
esttab est* using "${PATH_OUT_ANALYSIS}/`1'.tex", booktabs ///
	prehead("\toprule" "Dep. variable: &\multicolumn{4}{c}{FinTech Lending} \\") ///
	postfoot("\bottomrule")  ///
	unstack cells(b(star fmt(4)) p(par fmt(4))) ///
	mtitles("volume" "number" "volume" "number") numbers ///
	collabels(none) varlabels(_cons Constant "c.failure#c.hhi" "failure $\times$ hhi") ///
	prefoot("\midrule" "Time FE & Yes & Yes & Yes & Yes \\" ///
		"State FE & Yes & Yes & Yes & Yes \\" "\midrule") ///
	stats(N_clust N r2_a, fmt(0 0 4) ///
	labels("N. of counties" "N. of Obs." "Adj. R2")) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) replace style(tex) drop() ///
	noomitted varwidth(25)

