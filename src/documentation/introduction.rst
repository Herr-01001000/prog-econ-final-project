.. _introduction:


************
Introduction
************

This is my research model about drivers of FinTech lending. I use the data from Lending Club and other data sources to explore the empirical evidence of potential FinTech lending drivers by econometric method. This model is accomplished by two major programming languages, Python and Stata. The entire research process is built on the Waf template from Professor Hans-Martin von Gaudecker :cite:`GaudeckerEconProjectTemplates`.

Documentation on the rationale, Waf, and more background is at http://hmgaudecker.github.io/econ-project-templates/


.. _getting_started:

Getting started
===============

Importing necessary datasets
----------------------------

Majority of the data has been pushed here. However, due to the size of loan data from **Lending Club** and **Summary of Deposits** is too large, I don't include them here under version control. The number of these data is **25 .csv files**. Their names are in this :ref:`list`.

All 25 .csv data files should be **directly** put under directory **src/original_data**. Then the project is good to go. 

In order to be more specific about these data in this final project, I uploaded them on Google Drive. The access link is https://drive.google.com/open?id=1sQnrjOcsekY7OEGmb0XTgBRNf3sV7mGd. There is also a zip file called `original_data.rar` for better download experience. It consists of all large datasets I mentioned above.

In the meantime, I sent the zipped data file by email to `janos.gabler@gmail.com` and `hmgaudecker@uni-bonn.de`.

These data can also be downloaded from *"DOWNLOAD LOAN DATA"* on `Lending Club's website <https://www.lendingclub.com/info/download-data.action>`_ and *"SOD Download"* on `Summary of Deposits's website <https://www5.fdic.gov/sod/dynaDownload.asp?barItem=6>`_.

Waf template usage
------------------

**This assumes you have completed the steps in the** `README.md file <https://github.com/hmgaudecker/econ-project-templates/>`_ **and everything worked.**

The logic of the project template works by step of the analysis: 

1. Data management
2. The actual estimations / simulations / ?
3. Visualisation and results formatting (e.g. exporting of LaTeX tables)
4. Research paper and presentations. 

It can be useful to have code and model parameters available to more than one of these steps, in that case see sections :ref:`model_specifications`, :ref:`model_code`, and :ref:`library`.

First of all, think about whether this structure fits your needs -- if it does not, you need to adjust (delete/add/rename) directories and files in the following locations:

    * Directories in **src/**;
    * The list of included wscript files in **src/wscript**;
    * The documentation source files in **src/documentation/** (Note: These should follow the directories in **src** exactly);
    * The list of included documentation source files in **src/documentation/index.rst**

Later adjustments should be painlessly possible, so things won't be set in stone.

Once you have done that, move your source data to **src/original_data/** and start filling up the actual steps of the project workflow (data management, analysis, final steps, paper). All you should need to worry about is to call the correct task generators in the wscript files. Always specify the actions in the wscript that lives in the same directory as your main source file. Make sure you understand how the paths work in Waf and how to use the auto-generated files in the language you are using particular language (see the section :ref:`project_paths` below).


.. _project_paths:

Project paths
=============

A variety of project paths are defined in the top-level wscript file. These are exported to header files in other languages. So in case you require different paths (e.g. if you have many different datasets, you may want to have one path to each of them), adjust them in the top-level wscript file.

The following is taken from the top-level wscript file. Modify any project-wide path settings there.

.. literalinclude:: ../../wscript
    :start-after: out = "bld"
    :end-before:     # Convert the directories into Waf nodes


As should be evident from the similarity of the names, the paths follow the steps of the analysis in the :file:`src` directory:

    1. **data_management** → **OUT_DATA**
    2. **analysis** → **OUT_ANALYSIS**
    3. **final** → **OUT_FINAL**, **OUT_FIGURES**, **OUT_TABLES**

These will re-appear in automatically generated header files by calling the ``write_project_paths`` task generator (just use an output file with the correct extension for the language you need -- ``.py``, ``.r``, ``.m``, ``.do``)

By default, these header files are generated in the top-level build directory, i.e. ``bld``. The Python version defines a dictionary ``project_paths`` and a couple of convencience functions documented below. You can access these by adding a line::

    from bld.project_paths import XXX

at the top of you Python-scripts. Here is the documentation of the module:

    **bld.project_paths**

    .. automodule:: bld.project_paths
        :members:


.. _list:

List of data file names
=======================

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
