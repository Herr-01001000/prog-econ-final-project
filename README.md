# Final Project of Effective Programming Practices for Economists
This is my research model about drivers of FinTech lending. I use the data from Lending Club and other data sources to explore the empirical evidence of potential FinTech lending drivers by econometric method. This model is accomplished by two major programming languages, Python and Stata. The entire research process is built on the Waf template from Professor Hans-Martin von Gaudecker.

## Important notes about large datasets
Majority of the data has been pushed here. However, due to the size of loan data from **Lending Club** and **Summary of Deposits** is too large, I don't include them here under version control. The number of these data is **25 .csv files**. Their names are in this [list](#names). 

### Data usage：
All 25 .csv data files should be **directly** put under directory `src/original_data`. Then the project is good to go.

### Access portal:
In order to be more specific about these data in this final project, I uploaded them on Google Drive. The access link is https://drive.google.com/open?id=1sQnrjOcsekY7OEGmb0XTgBRNf3sV7mGd. There is also a zip file called `original_data.rar` for better download experience. It consists of all large datasets I mentioned above.

In the meantime, I sent the zipped data file by email to `janos.gabler@gmail.com` and `hmgaudecker@uni-bonn.de`.

These data can also be downloaded from *"DOWNLOAD LOAN DATA"* on [**Lending Club's website**](https://www.lendingclub.com/info/download-data.action) and *"SOD Download"* on [**Summary of Deposits's website**](https://www5.fdic.gov/sod/dynaDownload.asp?barItem=6).



<span id="names"></span>
#### Data File Names: 
* *Lending Club*
1. LoanStats3a.csv
2. LoanStats3b.csv
3. LoanStats3c.csv
4. LoanStats3d.csv
5. LoanStats_2016Q1.csv
6. LoanStats_2016Q2.csv
7. LoanStats_2016Q3.csv
8. LoanStats_2016Q4.csv
9. LoanStats_2017Q1.csv
10. LoanStats_2017Q2.csv
11. LoanStats_2017Q3.csv
12. LoanStats_2017Q4.csv
13. LoanStats_2018Q1.csv
14. LoanStats_2018Q2.csv
* *Summary of Deposits*
15. ALL_2007.csv
16. ALL_2008.csv
17. ALL_2009.csv
18. ALL_2010.csv
19. ALL_2011.csv
20. ALL_2012.csv
21. ALL_2013.csv
22. ALL_2014.csv
23. ALL_2015.csv
24. ALL_2016.csv
25. ALL_2017.csv
