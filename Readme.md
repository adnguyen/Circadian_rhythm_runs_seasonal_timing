### Rhagoletis project on circadian rhythms     

Authors: Dan Hahn and Andrew Nguyen

Start date: 2017-08-14
End date/last edited:    

This project is funded by the National Science Foundation, grant #...   

## Table of Contents:   

* [Repository Layout](#id-section1)
* [Project Workflow](#id-section2)
* [Meta data for critical datasets](#id-section3)

imm making make change

------

<div id='id-section1'/>   

### Repository Layout

* **Data/**:
  * 2017-08-24_rhagoletis_data_sheet.xlsx : master datasheet where we collated data; metadata below 
  * 2017-08-24_rhagoletis_data_sheet_2017-12-13_dataslice.csv; a snapshot of the data on 2017-12-13 
  * 2017-10-12_trik_cohort_list_free_run.xlsx : table indicating when each cohort needs to be put into free run experiment (day 8) 
  * 2017-10-16_Trikinetics_cohorts_eclosion.csv : csv of trikinetics cohorts 
  * 2017-10-22_skipped_apple_cohort_eclosions.xlsx : data collected of skipped cohorts
  * 2017-11-17_subset_host_comparison_trik_data_extract.csv
  * 2017-12-03_summary_table_finding_periods.xlsx
  * 2017-12-05-overwintering_table_of_months.xlsx
  * 2018-01-08__overwintering_exit_timing_5months.xlsx
  * **randomizing/**: Folder used to save cohorts into separate files to randomize and includes the randomized outputs with uniqueIDs
  * **raw/**: 
    * **Respirometry/**: expedata and csv files 	
    * **Trikinetics/**:  trikinetics monitor data sets; raw  
  * Sampling_mass_purgetimes.xlsx : datacollection sheet that we print out  and fill in to put into our physical notebook 

* **Documents/**:
  * Detailed Experimental workflow.md : markdown file using mermaid to draw a workflow
  * Detailed Experimental workflow.png : png version
  * Methods.md
  * Rhagoletis_handling_processing.md : protocols for handling *Rhagoletis*
  * Rhagoletis_handling_processing.pdf : pdf version
  * Workflow_for_trikinetics_data_transformation.md : markdown file of the workflow for trikinetics data 
  * Workflow_for_trikinetics_data_transformation.pdf : pdf version 

* **Results/**: Preliminary figures right now 

* **Scripts_analyses/**:

  * 2017-09-04_randomization.Rmd
  * 2017-09-27_prelim_circadian_rhythm_trikinetics.Rmd
  * 2017-10-16_prelim_free_run.Rmd
  * 2017-11-16_processing_master_data.html
  * 2017-11-16_processing_master_data.Rmd
  * 2017-11-19_prelim_data_subset_extract_behaviors.Rmd
  * 2017-12-08_15min_bins_subset_behavior.csv
  * 2017-12-08_allm_all_monitorscombined.csv
  * 2017-12-08_subset_inds_15min_bins_vsdays.png 
  * Scripts_analyses.Rproj

* Readme.md : ...this file...

* Research_Plan.md : initial research plan 

  ​

------

<div id='id-section2'/>   

### Project Workflow: 

![](https://user-images.githubusercontent.com/4654474/31616112-cd198846-b259-11e7-876b-98a62e379c45.png)

------

<div id='id-section3'/>     

### Meta data for critical datasets   

**2017-08-24_rhagoletis_data_sheet.xlsx** : master dataset where we collated different sources of data (respirometry, mass, and trikinetics annotations)  

* Maggot_collections tab: Details of fruit collections, maggot collections, and when to process at different times of the workflow  
  * Site: broad site name 
  * Site_name: micro site name
  * Host: host fruit
  * Collect_fruit: when we collected fruit; should only be 2 dates to indicate apple and haw collection
  * Collect_day: cohort day 
  * Collect_larvae: collection date of larvae for that cohort
  * Petri_dish: petri dish number; we tried to put 100 maggots per dish
  * Collector: person who collected; AN = Andrew Nguyen, PE= Pepa, TG = Tatiana, CH= Chelsea, KL= Kylie
  * Petri_density: number of maggots we placed in that petri dish
  * Day10_weights_date: day 10 date for when to weigh and purge a given cohort
  * Day11_respirometry_date: day 11 date for when we measure co2 for a given cohort
  * Day14_weights_date : day 14 date for when to weigh and purge a given cohort
  * Day15_respirometry_date: day 15 date for when we measure co2 for a given cohort   
* Data_collect tab: Datasheet where we entered cohort details; weights, purge times, and respirometry data; trikinetics handling details; as well as notes   
  * Ind_ID: initial numerical ID
  * tape : tape associated with Ind_ID
  * Site_name: general site name
  * mass_day10: mass values at day 10 in mgs
  * purge_time_1: purge time in military time (hours: minutes) at day 10
  * purge1: going to convert military time to hours decimals at day 10
  * collection_date: Date the fruit was collected 
  * day10: day 10 date
  * cohort_date: initial cohort date from which we collected maggots
  * cohort_day: the cohort day 
  * Host: host fruit ; apple or haw
  * Li-cor_1: respirometry machine we used for each sample 
  * resp_time_1: time of when we measured sample respirometrically day 11
  * resp_day11: raw respirometry values day 11
  * mass_day14: mass values at day 11 in mgs 
  * purge_time_2: purge times in military time for the cohort at day 14
  * resp_time_2: time of when we measured sample respirometrically day 15  
  * resp_day15:  raw respirometry values day 15
  * Li_cor2: additional licor id if different licor was used between days
  * notes: notes for respirometry; weights; indication of deaths and observations
  * Resp_code: either 0 or 1, depending on if CO2 was produced during respirometry 
  * treatment: whether sample was split into the genetic control, rearing temperature (RT eclosion), or in the fridge (simulated overwintering)  
  * uniqueID: for apple, the ID is a combination of cohort day, first letter of tape color, and Ind_ID number; for haw, it is the same thing but uniqueIDs start with an "h" to indicate haw
  * eclosion_date: eclosion day defined as an adult at least 50% emerged from pupal case. 
  * eclosion_days: number of days from maggot collection(cohort date) until eclosion_date
  * well_id: if in RT or fridge treatment, the well id in a 96 well plate set up 
  * organism: fly or parasitic wasp 
  * Trikinetics_position: initial trikinetics position for entrainment
  * Trik_monitor: initial trikinetics monitor for entrainment
  * Trikinetics_entry_LD_time: entry date for entrainment
  * Trikinetic_exit_date: date sample taken out from either death or moved to free-run experiment
  * Trikinetics_exit_LD_time: time of exit
  * notes_2: trikinetics notes for entrainment ; including deaths or escapees
  * Free_run_trik_monitor: trikinetics monitor for free- run experiment
  * Free_run_trik_position: trikinetics position for free - run experiment
  * Free_run_entry_date: the date when a sample entered the free- run experiment
  * Free_run_entry_time: the time when a sample entered the free- run experiment
  * Free_run_exit_date: the date when a sample exited the free run experiment due to death 
  * Free_run_exit_time: the time when a sample exited the free-run experiment 
  * notes_3: notes for free run experiment

