
*****************************************************************************************
*                   EOSE12 - Economy & Society 2024 - Bachelor Thesis                   *
*****************************************************************************************
* Last modified: May 2024


*                  Thesis title: Remittances and Household Welfare in Morocco - a Propensity Score Matching approach                  *
**              RQ: To what extent can international remittances impact household welfare through household expenditure?              **
***                                                      Author: Anas Haouat                                                          ***
****                                                    Supervisor: Kirk Scott                                                        ****

*Star by installing PSMATCH2, a community package used to run PSM.:
ssc install psmatch2

clear all 
set more off 

* Select the directory:
global datadir  "/Users/anas/Desktop/Analysis/raw_data/Stata"

** Import the CSV file:
import delimited "/Users/anas/Desktop/Analysis/raw_data/Stata/2007_database.csv", clear

*--------------------**--------------------*

***** I- Data cleaning & processing:

**** The original file was compiled from two different databases using Python, here I will continue with a minor data manipualtion before proceeding to the analysis.

* Drop useless columns:
drop up us v181


* Rename variables in English from French:
rename ident_ménage household
rename transfert01 remittance
rename transfert_nature remittance_kind
rename transfert_argent remittance_monetary
rename montant_transfert remittance_total

rename dam annual_exp
rename age_cm age
rename sexe_cm gender_st
rename milieu residence_st
rename quintiles quint_exp
rename niveau_scolaire_cm education
rename statut_professionnel_cm work
rename taille_ménage household_size

* Relabel - consider converting this to a loop:
label variable household "Household ID in the survery"
label variable remittance "Dummy variable if the household received remittances or not"
label variable remittance_kind "In-kind remittances"
label variable remittance_monetary "Monetary remittances"
label variable remittance_total "Total value of remittances received by the household"

label variable annual_exp "Annual expenditure by the household to the acquisition of all goods and services"
label variable age "Household head age"
label variable gender_st "Household head gender"
label variable residence "Rural vs. Urban type of residence"
label variable quint_exp "Household level of expenditure by quintiles"
label variable education "Household head highest achieved level of education"
label variable work "Household head work status"
label variable household_size "Household size by number of people"


* Create the new variables needed for the analysis:

	*Necessary goods:

gen necs_good=.
replace necs_good=dam_g01+dam_g02+dam_g03+dam_g04+dam_g05+dam_g06+dam_g07+dam_g08+dam_g11+dam_g12+dam_g17+dam_g18+dam_g2+dam_g3+dam_g4+dam_g5+dam_g6+dam_g7+dam_g84+dam_g85+dam_g86+dam_g87+dam_g88+dam_g91+dam_g92+dam_g93+dam_g94
label variable necs_good "Annual expenditure on essential goods"


	*Temptation goods: 
gen temp_good=.
replace temp_good=dam_g14+dam_g89
label variable temp_good "Annual expenditure on temptation goods"


	*Dummy variable for gender (male = 1):
gen gender = (gender_st == "Masculin")
label variable gender "Dummy variable for household head gender"

	*Dummy variable for urban/rural residence:
gen residence = (residence_st == "Rural")
label variable residence "Dummy variable for households living in a rural area"

	*Recode the education variable into 3 categories, then convert it to a dummy:
replace edu = "Fondamental" if edu == "Autres niveaux"
replace edu = "Secondaire" if edu == "Fondamental"
		*Convert to dmmy variables:
tabulate edu, generate(edu_dummy)


	*Same for the work status variable:
replace work = "chômeur n'ayant jamais travaillé" if work == "Aide familiale ou apprenti"
replace work = "chômeur n'ayant jamais travaillé" if work == "Autres situations"
replace work = "Indépendant" if work == "employeur"
		*Then translate the categories' names to English
replace work = "Unemployed" if work == "chômeur n'ayant jamais travaillé"
replace work = "Employed" if work == "Salarié"
replace work = "Self-employed" if work == "Indépendant"
		*Finally, create dummy variables:		
tabulate work, generate(work_dummy)

	
*Table 1:
sum remittance_total remittance_monetary remittance_kind

*Table 2:
dtable annual_exp household_size age gender residence, by(remittance, notests notestnotes nomissing) column( by(hide) ) nosample nformat(%9.3g mean) nformat(%9.3g sd) novarlabel

*Table 3:
asdoc tab quint_exp remittance

*Table 4: (this uses the original education variable provided by the database before any modifications)
asdoc tab education remittance

*Table 5: (Same remark as per Table 4)
tab quint_exp education

* DROP ZONE:

drop dam_g1 dam_g2 dam_g3 dam_g4 dam_g5 dam_g6 dam_g7 dam_g8 dam_g9 dam_hygiène dam_soinsmédicaux dam_transport dam_communication dam_loisirs dam_enseignement dam_autres_dépenses dam_g01 dam_g02 dam_g03 dam_g04 dam_g05 dam_g06 dam_g07 dam_g08 dam_g09 dam_g10 dam_g11 dam_g12 dam_g13 dam_g14 dam_g15 dam_g17 dam_g18 dam_g21 dam_g22 dam_g23 dam_g24 dam_g25 dam_g26 dam_g27 dam_g28 dam_g31 dam_g32 dam_g33 dam_g34 dam_g41 dam_g42 dam_g43 dam_g44 dam_g45 dam_g46 dam_g47 dam_g51 dam_g52 dam_g53 dam_g61 dam_g62 dam_g63 dam_g71 dam_g72 dam_g73 dam_g74 dam_g75 dam_g76 dam_g81 dam_g82 dam_g83 dam_g84 dam_g85 dam_g86 dam_g87 dam_g88 dam_g89 dam_g91 dam_g92 dam_g93 dam_g94 dap dap_g1 dap_g2 dap_g3 dap_g4 dap_g5 dap_g6 dap_g7 dap_g8 dap_g9 dap_hygiène dap_soins_médicaux dap_transport dap_communication dap_loisirs dap_enseignement dap_autres_dépenses dap_g01 dap_g02 dap_g03 dap_g04 dap_g05 dap_g06 dap_g07 dap_g08 dap_g09 dap_g10 dap_g11 dap_g12 dap_g13 dap_g14 dap_g15 dap_g17 dap_g18 dap_g21 dap_g22 dap_g23 dap_g24 dap_g25 dap_g26 dap_g27 dap_g28 dap_g31 dap_g32 dap_g33 dap_g34 dap_g41 dap_g42 dap_g43 dap_g44 dap_g45 dap_g46 dap_g47 dap_g51 dap_g52 dap_g53 dap_g61 dap_g62 dap_g63 dap_g71 dap_g72 dap_g73 dap_g74 dap_g75 dap_g76 dap_g81 dap_g82 dap_g83 dap_g84 dap_g85 dap_g86 dap_g87 dap_g88 dap_g89 dap_g91 dap_g92 dap_g93 dap_g94

drop n_ménage coef_ménage coef_individu residence_st strate_habitat taille_ménage_agreg gender_st age_quin_cm type_activité_cm profession_cm etat_matrimonial_cm secteur_activité_cm



*--------------------**--------------------*

***** II- Data analysis:

**** 1- PSM:

*** Step 1 - validate the two assumptions:

** Assumption 1: Selection on observables (impossible empirically)
** Assumption 2: Common support.

*We need to generate the propensity score - to predict the probability of receiving remittance from a probit model.

*The probit model with the treatment variable (remittance) is the dependent variable:
probit remittance age gender household_size residence edu_dummy1 edu_dummy2 edu_dummy3
predict pscore

*Visual inspection:

twoway (kdensity pscore if remittance == 1, lp(solid) color(maroon) legend(label(1 "Treatment group pscore"))) (kdensity pscore if remittance == 0, lp(dash) color(teal) legend(label(2 "Control group pscore"))), xtitle("Propensity Score") ytitle("Density") legend(order(1 "Treatment group pscore" 2 "Control group pscore"))

*graph export "/Users/anas/Desktop/Analysis/output/Figure 2.png", width(2000) replace

*Find minima/maxima:
su pscore if remittance == 1
su pscore if remittance == 0

*Get rid of values too big/small:
gen common_support = (pscore >= max(0.0409384, 0.0535432)) & (pscore <= min(0.4033653, 0.3691303))
label variable common_support "Common support value"


*Generate the new variables to eliminate the value not supported:
gen necs_good_supported = necs_good if common_support == 1
gen temp_good_supported = temp_good if common_support == 1



*** Step 2 - Matching:


** (1) - NN (1):
* NN (1) without replacement for essential goods:
set seed 2024
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(necs_good_supported) neighbor (1) ate

* NN (1) without replacement for temptation goods:
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(temp_good_supported) neighbor (1) ate


** (2) - NN (5):
* NN (5) without replacement for essential goods:
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(necs_good_supported) neighbor (5) ate

* NN (5) without replacement for temptation goods:
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(temp_good_supported) neighbor (5) ate


** (3) - Caliper (0.05%):
* Caliper (0.05%) without replacement for essential goods:
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(necs_good_supported) caliper(0.05) ate

* Caliper (0.05%) without replacement for temptation goods:
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(temp_good_supported) caliper(0.05) ate

** (4) - Kernel:
* Kernel for essential goods:
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(necs_good_supported) kernel ate

* Kernel for temptation goods:
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(temp_good_supported) kernel ate


*** Step 3 - Balancing test:

pstest age gender household_size residence edu_dummy1 edu_dummy2, graph

* To export the table to doc
asdoc pstest age gender household_size residence edu_dummy1 edu_dummy2, saving(mytable.xlsx, replace)

*A better looking table:
psmatch2 remittance age gender household_size residence edu_dummy1 edu_dummy2, outcome(necs_good_supported) caliper(0.05) ate




*** Step 4 - Sensitivity analysis:

gen delta = necs_good_supported - _necs_good_supported if _treat==1 & _support==1
rbounds delta, gamma(1 (0.1) 1.5)


gen delta2 = temp_good_supported - _temp_good_supported if _treat==1 & _support==1
rbounds delta2, gamma(1 (0.1) 1.5)

































