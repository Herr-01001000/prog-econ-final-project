/* 
The file "data_prep_all.do" convertes all processed data to one final data file
for further analysis.
*/


// Header do-File with path definitions, those end up in global macros.
clear
include project_paths
log using `"${PATH_OUT_DATA}/log/`1'.log"', replace


// Clean lending club data to state-year level. 
use "${PATH_OUT_DATA}/LoanStats_all.dta"
keep loan_amnt funded_amnt funded_amnt issue_d addr_state year zip_code
gen id = _n

collapse (count) loan_no=id (sum) loan_amnt , by(zip_code year addr_state)
egen county_id = group(zip_code)
rename addr_state state


// Add bank failures and HHI to lending club data.
merge n:n zip_code year using "${PATH_OUT_DATA}/sod.dta"
keep if _merge==3
drop _merge


// Add GDP, computer GDP, education GDP, real GDP and per capita real GDP to lending club data. 
merge n:1 state year using "${PATH_OUT_DATA}/gdp.dta"
drop if _merge==2
drop _merge


// Add PI, population and per capita PI to lending club data. 
merge n:1 state year using "${PATH_OUT_DATA}/pi.dta"
drop if _merge==2
drop _merge


// Add unemployment rate to lending club data.
merge n:1 state year using "${PATH_OUT_DATA}/unemployment.dta"
drop if _merge==2
drop _merge


// Add internet use to lending club data.
merge n:1 state year using "${PATH_OUT_DATA}/internet.dta"
drop if _merge==2
drop _merge


// Add population data to lending club data.
merge n:1 state year using "${PATH_OUT_DATA}/population.dta"
drop if _merge==2
drop _merge
gen density_k = density / 1000


// Add bank loan data to lending club data.
merge n:1 state year using "${PATH_OUT_DATA}/bankloan.dta"
drop if _merge==2
drop _merge
gen bank_loan = bank_loan_pc_total * population
gen bank_loan_c = bank_loan_pc_creditcard * population
gen ratio = loan_amnt / bank_loan
gen ratio_c = loan_amnt / bank_loan_c


// Add dummies to distinguish for financial crisis.
gen after_crisis = (year > 2009)
gen d_failure = (failure != 0)


// Make numerical identifier and logarithm of certain variables.
egen state_id = group(state)
gen log_loan_amnt = log(loan_amnt)
gen log_loan_no = log(loan_no)
gen log_hhi = log(hhi)
gen log_bank_loan = log(bank_loan)
gen log_bank_loan_c = log(bank_loan_c)
gen log_ratio = log(ratio)
gen log_ratio_c = log(ratio_c)

gen loan_diff = log_loan_amnt - log_bank_loan
gen loan_c_diff = log_loan_amnt - log_bank_loan_c

label variable state "50 States and 1 District in United States"
label variable state_id "ID of state names in dictionary order"
label variable county_id "ID order of first 3 digits in zip code"
label variable year "Year from 2007-2017"
label variable loan_no "Number of loans"
label variable log_loan_no "Logarithm of number of loans"
label variable loan_amnt "Volume of the loan(dollars)"
label variable log_loan_amnt "Logarithm of volume of the loan(dollars)"
label variable depsum "Total amount of the deposits(Thousands of dollars)"
label variable hhi "HHI for market concentration"
label variable log_hhi "Logarithm of HHI for market concentration"
label variable after_crisis "Dummy = 1 if year is after crisis"
label variable d_failure "Dummy = 1 if there is at least a bank failure in state"
label variable bank_loan "Volume of traditional banking loan(dollars)"
label variable log_bank_loan "Logarithm of volume of traditional banking loan(dollars)"
label variable density_k "Population density per square mile(thousand people)"

order zip_code county_id state state_id year
sort county_id state year

save "${PATH_OUT_DATA}/data_all.dta", replace
log close
