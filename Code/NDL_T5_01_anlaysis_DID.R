# Project Name: NDL - TOPIC 5
# Project Short Description: Waiting List - DID Modelling 
# 
# Purpose of this script:
# [x] Re-run the 4.1 and 4.2 output of Objective 4 outlined in the SAP with the defined 
#     scope of hip replacement & cardiothoracic surgery OPCS procedure(s)
# 
# Notes:
# [X] 10032025 - Duplicates - different treatment functions with a different outcome code, 
#                as they are different pathways for the same treatment with same KEY and 
#                same start date.  Duplicates with earlier end date removed.
# [X] 11032025 - PATHWAY_ID - create PATHWAY_ID based on PATIENT_KEY to treat each entry 
#                as unique case. This approach allows patient to have multiple pathways 
#                for RTT.
# 
# Re-useable features:
# [] 
# 
# Author: Alex Cheuk
# Contributor: 

################################################################################
# Load libraries

library(tidyverse)
library(broom)
library(readxl)
library(fixest)
library(roxygen2)
library(ggrepel)

################################################################################
# Read data extract(s) and prepare lookup(s)

## Filename/ Date of extraction(DDMMYYYY): casual_final_outcomes_v2.csv/ 10032025
df_causal <- read.csv('./data/external/causal_final_outcomes_v2.csv')

wrangled_df <- df_causal %>%
  filter(!is.na(RTT_END_DATE)) %>%   ### Ensure all entries with RTT_END_DATE
  rename("WAIT_WEEKS" = "PERSON_WEEKS") %>%
  filter(!WAIT_WEEKS < 6) %>%   ### Remove 6 weeks waiting time (i.e. very early weeks of waiting as potential urgent cases)
  mutate(
    RTT_START_DATE = as.Date(RTT_START_DATE), 
    RTT_END_DATE = as.Date(RTT_END_DATE), 
    PATIENT_KEY = as.factor(PATIENT_KEY), 
    WASHOUT_PERIOD_END_DATE = as.Date(RTT_END_DATE + 28), ## 4 weeks as normal recovery period
    FOLLOW_UP_END_DATE = as.Date(WASHOUT_PERIOD_END_DATE + WAIT_WEEKS*7),
    WASHOUT_PERIOD_END_DAYS = WAIT_WEEKS*7 + 28,
    FOLLOW_UP_END_DAYS = WASHOUT_PERIOD_END_DAYS + WAIT_WEEKS*7 ,
    WAIT_TIME = case_when(
      WAIT_WEEKS <= 18 ~ '<= 18 weeks',
      WAIT_WEEKS > 18 ~ '> 18 weeks',
      TRUE ~ NA
      ),
    WAIT_DAYS = WAIT_WEEKS * 7  
  ) %>%
  distinct()


## Examine duplicated PATIENT_KEY (if any)
df_duplicated <- wrangled_df[duplicated(wrangled_df[c('PATIENT_KEY')]), ]
duplicated_PATIENT_KEYs <- df_duplicated |> pull("PATIENT_KEY")

### Create a PATHWAY_ID to treat each entry as unique case, regardless having the same PATIENT_KEY
df_duplicates <- wrangled_df |> 
  filter(PATIENT_KEY %in% duplicated_PATIENT_KEYs) |> 
  group_by(PATIENT_KEY) |> 
  mutate(PATHWAY_ID = paste0(PATIENT_KEY , '_', row_number()))
df_nonduplicates <- wrangled_df |> filter(!PATIENT_KEY %in% duplicated_PATIENT_KEYs)  |>
  mutate(PATHWAY_ID = PATIENT_KEY)


wrangled_df_pathway <- rbind(df_duplicates, df_nonduplicates) |>
  select(PATHWAY_ID, PATIENT_KEY, everything()) %>%
  ungroup()

## List of columns to keep for each DiD comparison
cols_tokeep <- c(
  'PATHWAY_ID', 'PATIENT_KEY', 'RTT_START_DATE', 'RTT_END_DATE', 'PROCEDURE', 'WAIT_WEEKS', 'WAIT_TIME', 
  'WASHOUT_PERIOD_END_DATE', 'FOLLOW_UP_END_DATE', 'WASHOUT_PERIOD_END_DAYS', 'FOLLOW_UP_END_DAYS', 'WAIT_DAYS'
  )

## List of parameter pairs for looping the output function
parameter_pairs <- split(
  names(wrangled_df_pathway %>% select(!cols_tokeep)), 
  rep(1:(length(names(wrangled_df_pathway %>% select(!cols_tokeep)))/2), each = 2)
  )

parameter_name <-c(
  'GP_APPOINTMENT', 'GP_COST', 
  'AE_ACTIVITY', 'AE_COST', 
  'EMERGENCY_ACTIVITY', 'EMERGENCY_COST', 
  'ELECTIVE_ACTIVITY', 'ELECTIVE_COST', 
  'SICKNOTE', 'PRESCRIPTION')


################################################################################
# Functions

## FUNCTION to define df based on OPCS profile and outcome parameter of interest (i.e. activity/ cost)
fn_filtereddf_OPCS <- function(df
  , col_opcs ### Column of OPCS to be filtered
  , opcs ### OPCS to be filtered - as STRING
  , cols_tokeep ### Columns not to be pivoted
  , col_parameter  ### Column of outcome parameter to be filtered 
  , parameter ### Parameter of interest for rename column (i.e. activity/ cost) - as STRING
  ){
  df_opcs <- df %>%
    filter(!!sym(col_opcs) %in% c(opcs)) %>%
    select(c(cols_tokeep, col_parameter)) %>%
    pivot_longer(
      cols = !cols_tokeep, 
      names_to = 'TIME_GROUP',
      values_to = parameter) %>%
    mutate(TIME_GROUP = case_when(
      endsWith(TIME_GROUP, 'PRE') ~ 1,  ## Time = 1 (waiting)
      endsWith(TIME_GROUP, 'POST') ~ 0,   ## Time = 0 (reference)
      TRUE ~ NA
    )) %>%
    # group_by(PATIENT_KEY) %>%   ## ?? how to deal with Duplicate cases
    mutate(
      AVG_WEEK_USE = !!sym(parameter)/WAIT_WEEKS,
      WAIT_TIME := case_when(
      WAIT_TIME == "<= 18 weeks" ~ 0,  ## Target waiting time group
      WAIT_TIME == "> 18 weeks" ~ 1)   ## Non-Target waiting time group
    )
  
  return(df_opcs)
}



## FUNCTION to run placebo test by spiting the reference time into half to check parallel assumption 
## INTERPRETATION: If statistics is significant, then parallel trend is not deduced.
fn_placebo_test <- function(df_filtered
  , cols_tokeep   ### Columns not to be pivoted
  , parameter   ### Parameter of interest for FE placebo test - as STRING
  ){
  
  splited_df_placebo <- df_filtered %>%
    filter(TIME_GROUP == 0) %>%
    mutate(
      PLACEBO_GROUP_BEFORE = 0,
      PLACEBO_GROUP_AFTER = 1, 
    ) %>%
    pivot_longer(
      cols = !c(cols_tokeep, 'TIME_GROUP', parameter, 'AVG_WEEK_USE'),
      names_to = "PLACEBO",
      values_to = "PLACEBO_PERIOD") %>%
    mutate(PLACEBO := case_when(
      endsWith(PLACEBO, 'BEFORE') ~ 1,  ## Time = 1 (waiting)
      endsWith(PLACEBO, 'AFTER') ~ 0,   ## Time = 0 (reference)
      TRUE ~ NA
    )) %>%
    rename('HEALTHCARE_USE' = parameter)
  
  placebo_test <- feols(HEALTHCARE_USE ~ i(PLACEBO_PERIOD, WAIT_TIME, ref = 0) | PATHWAY_ID + PLACEBO_PERIOD,  ### USE unique PATHWAY_ID instead of PATIENT_KEY
                        data = splited_df_placebo)
  
  return(summary(placebo_test))
}



## FUNCTION to create table for total summary - for output tbl_4.1
fn_tbl_forfeols <- function(df_filtered
                            , parameter   ### Parameter of interest for rename column (i.e. activity/ cost) - as STRING
                            , intervention_group  ### LONG waiting time group - as STRING 
                            , control_group   ### TARGET waiting time group - as STRING
                            ){
  
  df_totalbygroup <- df_filtered %>%
    group_by(TIME_GROUP, WAIT_TIME) %>%
    summarise(
      USE_TOTAL = sum(as.numeric(!!sym(parameter))),
      DAYS_TOTAL = sum(as.numeric(WAIT_DAYS))
      , NOS_PAITENTS = n() 
    )
  
  tbl_total <-data.frame(matrix(ncol=3, nrow=8))
  
  colnames(tbl_total) <- c('metrics', control_group, intervention_group)
  
  tbl_total$metrics <- c(
    'Sample size', 
    'Total healthcare use reference period', 'Avg healthcare use per person reference period',  
    'Total healthcare use intervention period', 'Avg healthcare use per person intervention period', 
    'Excess use', 
    'person-weeks', 'Avg excess per person')
  
  ### Estimates of control_group (i.e. Target WAIT_GROUP = 0)
  tbl_total[2] <- c(
    ## 'Sample size'
    df_totalbygroup$NOS_PAITENTS[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 0],
    ## 'Total healthcare use reference period'
    df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 0],
    ## 'Avg healthcare use per person reference period'
    (df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 0] / df_totalbygroup$NOS_PAITENTS[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 0]),
    ## 'Total healthcare use intervention period'
    df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 0],
    ## 'Avg healthcare use per person intervention period'
    (df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 0] / df_totalbygroup$NOS_PAITENTS[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 0]),
    ## 'Excess use' 
    NA,
    ## 'person-weeks'
    df_totalbygroup$DAYS_TOTAL[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 0] / 7,
    ## 'Avg excess per person'
    NA
  )
  
  ## Estimates of intervention_group (i.e. Non-target group WAIT_GROUP = 1)
  tbl_total[3] <- c(
    ## 'Sample size'
    df_totalbygroup$NOS_PAITENTS[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 1],
    ## 'Total healthcare use reference period'
    df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 1],
    ## 'Avg healthcare use per person reference period'
    (df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 1] / df_totalbygroup$NOS_PAITENTS[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 1]),
    ## 'Total healthcare use intervention period'
    df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 1],
    ## 'Avg healthcare use per person intervention period'
    (df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 1]/ df_totalbygroup$NOS_PAITENTS[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 1]),
    ## ' Excess use'
    ((df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 1] - df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 1]) 
    - (tbl_total[[4,2]] - tbl_total[[2,2]])),
    ## 'person-weeks'
    df_totalbygroup$DAYS_TOTAL[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 1] / 7,
    ## 'Avg excess per person'
    (((df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 1]/ df_totalbygroup$NOS_PAITENTS[df_totalbygroup$TIME_GROUP == 1 & df_totalbygroup$WAIT_TIME == 1]) 
      - (df_totalbygroup$USE_TOTAL[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 1] / df_totalbygroup$NOS_PAITENTS[df_totalbygroup$TIME_GROUP == 0 & df_totalbygroup$WAIT_TIME == 1])) 
    - (tbl_total[[5,2]] - tbl_total[[3,2]]))
    )
  
  return(tbl_total)
}


## FUNCTION to run Fixed Effect OLS - for output tbl_4.2
fn_feols <- function(df_filtered
  , parameter  ### Parameter of interest for rename column (i.e. activity/ cost) - as STRING
  ){
  model <- feols(
    HEALTHCARE_USE ~ i(TIME_GROUP, WAIT_TIME, ref =0) | PATHWAY_ID + TIME_GROUP,    ### USE unique PATHWAY_ID instead of PATIENT_KEY
    data = df_filtered %>% rename('HEALTHCARE_USE' = parameter)
    )
  
  return(summary(model))
}


## FUNCTION to run the output at once
fn_output <- function(df
                      , col_opcs ### Column of OPCS to be filtered
                      , opcs ### OPCS to be filtered - as STRING
                      , cols_tokeep ### Columns not to be pivoted
                      , col_parameter  ### Column of outcome parameter to be filtered 
                      , parameter ### Parameter of interest for rename column (i.e. activity/ cost) - as STRING
                      , intervention_group  ### LONG waiting time group - as STRING 
                      , control_group   ### TARGET waiting time group - as STRING
                      ) {
  
  #' ORDER of the output ###
  #'   [1] - PARAMETER of interest (activity or cost)
  #'   [2] - PLACEBO assumption test output
  #'   [3] - SUMMARY STATISTICS TABLE 
  #'   [4] - FE OLS output
  
  df_filtered <- fn_filtereddf_OPCS(df, col_opcs, opcs, cols_tokeep, col_parameter, parameter)
  
  # [2]
  placebo_test <- fn_placebo_test(df_filtered, cols_tokeep, parameter)
  
  # [3]
  tbl_forfeols <- fn_tbl_forfeols(df_filtered, parameter, intervention_group, control_group)
  
  # [4]
  model <- fn_feols(df_filtered, parameter)
  
  return(list(parameter, placebo_test, tbl_forfeols, model))
}

################################################################################
# TEST FUNCTIONS - output_hip_replacement_GP_APPOINTMENT

# TEST fn_filtereddf_OPCS
df_filtered <- fn_filtereddf_OPCS(wrangled_df_pathway,
                                  col_opcs = 'PROCEDURE',
                                  'hip_replacement',
                                  cols_tokeep,
                                  col_parameter = c("GP_ACTIVITY_PRE", "GP_ACTIVITY_POST"),
                                  parameter = 'GP_APPOINTMENT'
                                  )


# TEST fn_tbl_forfeols
fn_tbl_forfeols(df_filtered, 'GP_APPOINTMENT', '> 18 weeks', '<= 18 weeks')


################################################################################
# OUTPUT

## Output - loop through all parameter pairs

## Create a list to host outputs and loop through to generate all outputs
list_output <- list()

for (y in c('hip_replacement', 'cardiothoracic')) {
  for (i in 1:length(parameter_pairs)) {
    
    output <- fn_output(df = wrangled_df_pathway
                        , col_opcs = 'PROCEDURE'
                        , opcs = y
                        , cols_tokeep
                        , col_parameter = unlist(parameter_pairs[i], use.names = FALSE)
                        , parameter = parameter_name[i]
                        , intervention_group = '> 18 weeks'
                        , control_group = '<= 18 weeks') 
    
    #' Store [y] procedure in output 
    #' [5] - PROCEDURE of interest
    output[[length(output) + 1]] <- y
    
    # Name output as [y]_[x] (i.e. PROCEDURE_PARAMETER)
    name <- paste0(y, '_', parameter_name[i])
    
    # Append to list of outputs
    list_output[[name]] <- output
  }
}

## Produced individual output for each parameter (i.e. activity/ cost)
output_hip_replacement_GP_APPOINTMENT <- list_output[["hip_replacement_GP_APPOINTMENT"]]
output_hip_replacement_GP_COST <- list_output[["hip_replacement_GP_COST"]]
output_hip_replacement_AE_ACTIVITY <- list_output[["hip_replacement_AE_ACTIVITY"]]
output_hip_replacement_AE_COST <- list_output[["hip_replacement_AE_COST"]]
output_hip_replacement_EMERGENCY_ACTIVITY <- list_output[["hip_replacement_EMERGENCY_ACTIVITY"]]
output_hip_replacement_EMERGENCY_COST <- list_output[["hip_replacement_EMERGENCY_COST"]]
output_hip_replacement_ELECTIVE_ACTIVITY <- list_output[["hip_replacement_ELECTIVE_ACTIVITY"]]
output_hip_replacement_ELECTIVE_COST <- list_output[["hip_replacement_ELECTIVE_COST"]]
output_hip_replacement_SICKNOTE <- list_output[["hip_replacement_SICKNOTE"]]
output_hip_replacement_PRESCRIPTION <- list_output[["hip_replacement_PRESCRIPTION"]]
output_cardiothoracic_GP_APPOINTMENT <- list_output[["cardiothoracic_GP_APPOINTMENT"]]
output_cardiothoracic_GP_COST <- list_output[["cardiothoracic_GP_COST"]]
output_cardiothoracic_AE_ACTIVITY <- list_output[["cardiothoracic_AE_ACTIVITY"]]
output_cardiothoracic_AE_COST <- list_output[["cardiothoracic_AE_COST"]]
output_cardiothoracic_EMERGENCY_AVTIVITY <- list_output[["cardiothoracic_EMERGENCY_AVTIVITY"]]
output_cardiothoracic_EMERGENCY_COST <- list_output[["cardiothoracic_EMERGENCY_COST"]]
output_cardiothoracic_ELECTIVE_ACTIVITY <- list_output[["cardiothoracic_ELECTIVE_ACTIVITY"]]
output_cardiothoracic_ELECTIVE_COST <- list_output[["cardiothoracic_ELECTIVE_COST"]]
output_cardiothoracic_SICKNOTE <- list_output[["cardiothoracic_SICKNOTE"]]
output_cardiothoracic_PRESCRIPTION <- list_output[["cardiothoracic_PRESCRIPTION"]]

## Names of all outputs
names_output <- list(
  output_hip_replacement_GP_APPOINTMENT, output_hip_replacement_GP_COST, 
  output_hip_replacement_AE_ACTIVITY, output_hip_replacement_AE_COST, 
  output_hip_replacement_EMERGENCY_AVTIVITY, output_hip_replacement_EMERGENCY_COST, 
  output_hip_replacement_ELECTIVE_ACTIVITY, output_hip_replacement_ELECTIVE_COST, 
  output_hip_replacement_SICKNOTE, output_hip_replacement_PRESCRIPTION, 
  output_cardiothoracic_GP_APPOINTMENT, output_cardiothoracic_GP_COST, 
  output_cardiothoracic_AE_ACTIVITY, output_cardiothoracic_AE_COST, 
  output_cardiothoracic_EMERGENCY_AVTIVITY, output_cardiothoracic_EMERGENCY_COST, 
  output_cardiothoracic_ELECTIVE_ACTIVITY, output_cardiothoracic_ELECTIVE_COST, 
  output_cardiothoracic_SICKNOTE, output_cardiothoracic_PRESCRIPTION
  )

## Output: 
###################################################################################
## - TBL.4.1 Difference-in-difference results - total healthcare usage and costs ##
###################################################################################

### Create dummy matrix for hosting the output 
output_tbl_4.1 <- data.frame()

### Loop through all outputs to concat the output table 4.1
for (n in names_output) {
  
  output_toadd <- as.data.frame(n[[3]]) |>
    mutate(
      "Parameter" = n[[1]],
      "Procedure" = as.character(n[[5]])) %>%
    mutate(Procedure := case_when(
      startsWith(Procedure, 'cardio') ~ "Cardiothoracic surgery",
      startsWith(Procedure, 'hip') ~ "Hip replacement",
      TRUE ~ NA)
      )
  
  output_tbl_4.1 <-rbind(output_tbl_4.1, output_toadd)
}

### Format output table 4.1
output_tbl_4.1_fmt <- output_tbl_4.1 %>%
  mutate(
    `<= 18 weeks` = sprintf("%.3f", round(`<= 18 weeks`, 3)), 
    `> 18 weeks` = sprintf("%.3f", round(`> 18 weeks`, 3)),
    "Point of delivery" := case_when(
      startsWith(Parameter, 'GP') ~ "GP appointments",
      startsWith(Parameter, 'AE') ~ "A&E attendances",
      startsWith(Parameter, 'EMERGENCY') ~ "Emergency addmissions",
      startsWith(Parameter, 'ELECTIVE') ~ "Elective addmissions",
      TRUE ~ Parameter)
    ) %>%
  mutate(Parameter := case_when(
    str_detect(Parameter, 'COST') ~ "(£)",
    TRUE ~ "(use)"
  )) %>%
  select(Procedure, `Point of delivery`, Parameter, everything()) |>
  group_by(Procedure, `Point of delivery`) |> 
  pivot_wider(names_from = c('Parameter'), names_sep = "\n", values_from = c('<= 18 weeks', '> 18 weeks')) 

tbl_4.1 <- output_tbl_4.1_fmt |>
  filter(
    !metrics %in% c(
      "Avg healthcare use per person reference period", 
      "Avg healthcare use per person intervention period", 
      "Avg excess per person")
    )%>%
  ungroup() |>
  mutate_at(names(output_tbl_4.1_fmt)[4:7], as.numeric) %>%
  mutate_at(names(output_tbl_4.1_fmt)[4:7], ~ifelse(. > 0 & . <=5, '*', .)) %>%
  mutate_at(names(output_tbl_4.1_fmt)[4:7], ~ifelse(is.na(.), '-', .))

### Save formatted output table 4.1 as csv in "processed" folder
View(tbl_4.1)
write_csv(tbl_4.1, na = "NA", './data/processed/tbl_4_1.csv')


##############################################################################
## - TBL.4.2 Difference-in-difference results - per person healthcare usage ##
##############################################################################

output_tbl_4.2 <- output_tbl_4.1_fmt |>
  filter(
    metrics %in% c(
      'Sample size', "Avg healthcare use per person reference period", 
      "Avg healthcare use per person intervention period", "Avg excess per person")
    ) %>%
  select(!c("<= 18 weeks\n(£)", "> 18 weeks\n(£)" ))

output_statistics <- data.frame()


### Loop through all outputs to concat the output table 4.2
for (n in names_output) {
  m <- n[[4]]
  
  output_toadd <- as.data.frame(m$coeftable) %>%
    select("Std. Error", "Pr(>|t|)") %>%
    mutate(
      "Parameter" = n[[1]],
      "Procedure" = as.character(n[[5]]),
      'p-value (se)' = paste0(
        sprintf("%.3f", round(`Pr(>|t|)`, 3))
                , ' ('
                , sprintf("%.3f", round(`Std. Error`, 3))
                , ')')) %>%
    mutate(
      Procedure := case_when(
        startsWith(Procedure, 'cardio') ~ "Cardiothoracic surgery",
        startsWith(Procedure, 'hip') ~ "Hip replacement",
        TRUE ~ NA)) %>%
    filter(!str_detect(Parameter, 'COST')) %>%
    mutate(
      "Point of delivery" := case_when(
        startsWith(Parameter, 'GP') ~ "GP appointments",
        startsWith(Parameter, 'AE') ~ "A&E attendances",
        startsWith(Parameter, 'EMERGENCY') ~ "Emergency addmissions",
        startsWith(Parameter, 'ELECTIVE') ~ "Elective addmissions",
        TRUE ~ Parameter)
      ) |>
    select(Procedure, `Point of delivery`, `p-value (se)`)
  
  row.names(output_toadd) <- NULL
  output_statistics <-rbind(output_statistics, output_toadd)
}

### Join summary estimates with statistics for output table 4.2
tbl_4.2 <- output_tbl_4.2 %>%
  left_join(output_statistics, by= c("Procedure", "Point of delivery")) %>%
  mutate(`p-value (se)` = case_when(
    str_detect(metrics, "excess") ~ `p-value (se)`,
    TRUE ~ '-'
  ))

tbl_4.2[tbl_4.2 == 'NA' | is.na(tbl_4.2)] <- '-'

### Save formatted output table 4.2 as csv in "processed" folder
View(tbl_4.2)
write_csv(tbl_4.2, na = "NA", './data/processed/tbl_4_2.csv')



##############################################################################
# Visualisation - create DID plots

## Plot significant results 

df_plt_hip_GP <- output_hip_replacement_GP_APPOINTMENT[[3]] |>
  filter(metrics %in% c('Avg healthcare use per person reference period', 'Avg healthcare use per person intervention period')) |>
  pivot_longer(cols = !metrics, names_to = 'Waiting Time', values_to = 'Healthcare Use') |>
  mutate(metrics = case_when(
    metrics == 'Avg healthcare use per person reference period' ~ 'After treatment',
    metrics == 'Avg healthcare use per person intervention period' ~ 'Before treatment')) |> 
  mutate(metrics := factor(metrics, levels = c('Before treatment', 'After treatment')))

df_plt_hip_EM <- output_hip_replacement_EMERGENCY_AVTIVITY[[3]] |>
  filter(metrics %in% c('Avg healthcare use per person reference period', 'Avg healthcare use per person intervention period')) |>
  pivot_longer(cols = !metrics, names_to = 'Waiting Time', values_to = 'Healthcare Use') |>
  mutate(metrics = case_when(
    metrics == 'Avg healthcare use per person reference period' ~ 'After treatment',
    metrics == 'Avg healthcare use per person intervention period' ~ 'Before treatment')) |> 
  mutate(metrics := factor(metrics, levels = c('Before treatment', 'After treatment')))

df_plt <- rbind(df_plt_hip_GP |> mutate(PARAMETER = 'GP Appointments'), 
                df_plt_hip_EM |> mutate(PARAMETER = 'Emergency Admissions'))
df_plt_annotate <- data.frame(
  PARAMETER = c('GP Appointments', 'Emergency Admissions'),
  x_1 = c('Before treatment', 'Before treatment'),
  x_2 = c('After treatment', 'After treatment'),
  x_label = c('After treatment', 'After treatment'),
  x_end_1 = c('After treatment', 'After treatment'),
  x_end_2 = c('After treatment', 'After treatment'),
  y_1 = c(df_plt_hip_GP |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use'), 
          df_plt_hip_EM |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use')),
  y_2 = c(df_plt_hip_GP |> filter(metrics == 'After treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use'),
          df_plt_hip_EM |> filter(metrics == 'After treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use')),
  y_label = c((df_plt_hip_GP |> filter(metrics == 'After treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') - 0.5),
              as.numeric(df_plt_hip_EM |> filter(metrics == 'After treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') -0.05)),
  y_end_1 = c(as.numeric(df_plt_hip_GP |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') -
    diff(df_plt_hip_GP |> filter(`Waiting Time` == '<= 18 weeks') |> pull())),
    as.numeric(df_plt_hip_EM |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') - 
      diff(df_plt_hip_EM |> filter(`Waiting Time` == '<= 18 weeks') |> pull()))),
  y_end_2 = c(as.numeric(df_plt_hip_GP |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') - 
    diff(df_plt_hip_GP |> filter(`Waiting Time` == '<= 18 weeks') |> pull())),
    as.numeric(df_plt_hip_EM |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') - 
      diff(df_plt_hip_EM |> filter(`Waiting Time` == '<= 18 weeks') |> pull()))),
  labels = c(round(diff(df_plt_hip_GP |> filter(`Waiting Time` == '> 18 weeks') |> pull()), 3),
    round((diff(df_plt_hip_EM |> filter(`Waiting Time` == '> 18 weeks') |> pull()) - diff(df_plt_hip_EM |> filter(`Waiting Time` == '<= 18 weeks') |> pull())), 3))
)

plt_hip_significant <- ggplot(df_plt, aes(x = as.factor(metrics), y = `Healthcare Use`, color = `Waiting Time`)) + 
  geom_point() + 
  geom_line(aes(group = `Waiting Time`)) + 
  scale_color_manual(values = c('cadetblue', 'tomato')) +
  facet_wrap(~PARAMETER, scales = 'free') +
  theme_light() +
  theme(text = element_text(size = 14, family = 'Relaway'),
        panel.spacing.x = unit(0.5, 'cm'),
        axis.title.y = element_text(margin = margin (r= 25)),
        axis.title.x = element_text(margin = margin (t= 20))
        ) +
  labs(
    x = 'Time Period', 
    y = 'Healthcare Use', 
    title = "Average Healthcare Use in Hip Replacement Procedure"
    ) +
  geom_text_repel(aes(label = round(`Healthcare Use`, 3)),
                  point.padding = 15,
                  nudge_x = -0.05,
                  nudge_y = 0.03, show.legend = FALSE)  +
  geom_segment(data= df_plt_annotate,
    aes(x = x_1, xend = x_end_1, y = y_1, yend = y_end_1), linetype = 'dashed', color = 'grey60', show.legend = FALSE) +
  geom_segment(data= df_plt_annotate,
    aes(x = x_2, xend = x_end_2, y = y_2, yend = y_end_2), linetype = 'dotted', color = 'grey60', show.legend = FALSE ) +
  geom_label_repel(data= df_plt_annotate,
    aes(x = x_label, y = y_label, label = labels, color = NULL, group = NULL),
    nudge_x = 0.06, show.legend = FALSE)

plt_hip_significant

###############################################################################
df_plt_hip_GP_total <- output_hip_replacement_GP_APPOINTMENT[[3]] |>
  filter(metrics %in% c('Total healthcare use reference period', 'Total healthcare use intervention period')) |>
  pivot_longer(cols = !metrics, names_to = 'Waiting Time', values_to = 'Healthcare Use') |>
  mutate(metrics = case_when(
    metrics == 'Total healthcare use reference period' ~ 'After treatment',
    metrics == 'Total healthcare use intervention period' ~ 'Before treatment')) |> 
  mutate(metrics := factor(metrics, levels = c('Before treatment', 'After treatment')))

df_plt_hip_EM_total <- output_hip_replacement_EMERGENCY_AVTIVITY[[3]] |>
  filter(metrics %in% c('Total healthcare use reference period', 'Total healthcare use intervention period')) |>
  pivot_longer(cols = !metrics, names_to = 'Waiting Time', values_to = 'Healthcare Use') |>
  mutate(metrics = case_when(
    metrics == 'Total healthcare use reference period' ~ 'After treatment',
    metrics == 'Total healthcare use intervention period' ~ 'Before treatment')) |> 
  mutate(metrics := factor(metrics, levels = c('Before treatment', 'After treatment')))

df_plt_total <- rbind(df_plt_hip_GP_total |> mutate(PARAMETER = 'GP Appointments'), 
                      df_plt_hip_EM_total |> mutate(PARAMETER = 'Emergency Admissions'))

df_plt_annotate_total <- data.frame(
  PARAMETER = c('GP Appointments', 'Emergency Admissions'),
  x_1 = c('Before treatment', 'Before treatment'),
  x_2 = c('After treatment', 'After treatment'),
  x_label = c('After treatment', 'After treatment'),
  x_end_1 = c('After treatment', 'After treatment'),
  x_end_2 = c('After treatment', 'After treatment'),
  y_1 = c(df_plt_hip_GP_total |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use'), 
          df_plt_hip_EM_total |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use')),
  y_2 = c(df_plt_hip_GP_total |> filter(metrics == 'After treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use'),
          df_plt_hip_EM_total |> filter(metrics == 'After treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use')),
  y_label = c((df_plt_hip_GP_total |> filter(metrics == 'After treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') - 300),
              as.numeric(df_plt_hip_EM_total |> filter(metrics == 'After treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') -30)),
  y_end_1 = c(as.numeric(df_plt_hip_GP_total |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') -
    diff(df_plt_hip_GP_total |> filter(`Waiting Time` == '<= 18 weeks') |> pull())),
    as.numeric(df_plt_hip_EM_total |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') - 
      diff(df_plt_hip_EM_total |> filter(`Waiting Time` == '<= 18 weeks') |> pull()))),
  y_end_2 = c(as.numeric(df_plt_hip_GP_total |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') - 
    diff(df_plt_hip_GP_total |> filter(`Waiting Time` == '<= 18 weeks') |> pull())),
              as.numeric(df_plt_hip_EM_total |> filter(metrics == 'Before treatment', `Waiting Time` == '> 18 weeks') |> pull('Healthcare Use') - 
    diff(df_plt_hip_EM_total |> filter(`Waiting Time` == '<= 18 weeks') |> pull()))),
  labels = c(round(diff(df_plt_hip_GP_total |> filter(`Waiting Time` == '> 18 weeks') |> pull()), 3),
    round((diff(df_plt_hip_EM_total |> filter(`Waiting Time` == '> 18 weeks') |> pull()) - diff(df_plt_hip_EM_total |> filter(`Waiting Time` == '<= 18 weeks') |> pull())), 3))
)


plt_hip_significant_total <- ggplot(df_plt_total, 
                              aes(x = as.factor(metrics), y = `Healthcare Use`, color = `Waiting Time`)) + 
  geom_point() + 
  geom_line(aes(group = `Waiting Time`)) + 
  scale_color_manual(values = c('cadetblue', 'tomato')) +
  facet_wrap(~PARAMETER, scales = 'free') +
  theme_light() +
  theme(text = element_text(size = 14, family = 'Relaway'),
        panel.spacing.x = unit(0.5, 'cm'),
        axis.title.y = element_text(margin = margin (r= 25)),
        axis.title.x = element_text(margin = margin (t= 20))
  ) +
  labs(x = 'Time Period', y = 'Healthcare Use', 
    title = "Total Healthcare Use in Hip Replacement Procedure") +
  geom_text_repel(aes(label = round(`Healthcare Use`, 3)),
                  point.padding = 15,
                  nudge_x = -0.05,
                  nudge_y = 0.03, show.legend = FALSE)  +
  geom_segment(data= df_plt_annotate_total,
    aes(x = x_1, xend = x_end_1, y = y_1, yend = y_end_1), linetype = 'dashed', color = 'grey60', show.legend = FALSE) +
  geom_segment(data= df_plt_annotate_total,
    aes(x = x_2, xend = x_end_2, y = y_2, yend = y_end_2), linetype = 'dotted', color = 'grey60', show.legend = FALSE ) +
  geom_label_repel(data= df_plt_annotate_total,
      aes(x = x_label, y = y_label, label = labels, color = NULL, group = NULL),
      nudge_x = 0.06, show.legend = FALSE)

plt_hip_significant_total

################################################################################
### Interpretation

estimate_hip_GP <- round(as.numeric(output_hip_replacement_GP_APPOINTMENT[[4]]$coefficients) / 
  output_hip_replacement_GP_APPOINTMENT[[3]] |> filter(metrics == 'Avg healthcare use per person reference period') |> pull(`<= 18 weeks`) * 100, 2)
cat('The statistical test indicates that patients that waited more than 18 weeks use are ', as.character(abs(estimate_hip_GP)), '% more likely to have GP appointment(s) after treatment, as compared to those who waited 18 weeks or less.')


estimate_hip_EM <- round(as.numeric(output_hip_replacement_EMERGENCY_AVTIVITY[[4]]$coefficients) / 
  output_hip_replacement_EMERGENCY_AVTIVITY[[3]] |> filter(metrics == 'Avg healthcare use per person reference period') |> pull(`<= 18 weeks`) * 100, 2)
cat('The statistical test indicates that patients that waited more than 18 weeks use are ', as.character(abs(estimate_hip_EM)), '% more likely to have emergency admission(s) after treatment, as compared to those who waited 18 weeks or less.')
