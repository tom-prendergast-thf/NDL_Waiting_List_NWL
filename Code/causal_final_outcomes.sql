CREATE OR REPLACE TABLE did_sandbox_ndl.ndl.t5_pt_list_causal_final_outcomes (
    patient_key NUMBER,
    rtt_start_date DATE,
    rtt_end_date DATE,
    procedure VARCHAR,
    person_weeks FLOAT,
    wait_time VARCHAR,
    gp_activity_pre NUMBER,
    gp_activity_post NUMBER,
    gp_cost_pre FLOAT,
    gp_cost_post FLOAT,
    ae_activity_pre NUMBER,
    ae_activity_post NUMBER,
    ae_cost_pre FLOAT,
    ae_cost_post FLOAT,
    emergency_activity_pre NUMBER,
    emergency_activity_post NUMBER,
    emergency_cost_pre FLOAT,
    emergency_cost_post FLOAT,
    elective_activity_pre NUMBER,
    elective_activity_post NUMBER,
    elective_cost_pre FLOAT,
    elective_cost_post FLOAT,
    sicknote_pre NUMBER,
    sicknote_post NUMBER,
    prescription_pre NUMBER,
    prescription_post NUMBER
)
;
INSERT INTO did_sandbox_ndl.ndl.t5_pt_list_causal_final_outcomes
SELECT
    c.patient_key,
    c.rtt_start_date,
    c.rtt_end_date,
    c.procedure,
    DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 AS person_weeks,
    CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 18
            THEN '>=18'
        ELSE '<18'
        END AS wait_time,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'GP appointment'
            AND o.outcome_date <= c.rtt_end_date
            THEN 1
        END), 0) AS gp_activity_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'GP appointment'
            AND o.outcome_date > c.rtt_end_date
            THEN 1
        END), 0) AS gp_activity_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'GP appointment'
            AND o.outcome_date <= c.rtt_end_date
            THEN o.outcome_cost
        END), 0) AS gp_cost_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'GP appointment'
            AND o.outcome_date > c.rtt_end_date
            THEN o.outcome_cost
        END), 0) AS gp_cost_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome IN('Type 1 A&E attendance', 'Type 2 A&E attendance', 'Type 3 & 4 A&E attendance')
            AND o.outcome_date <= c.rtt_end_date
            THEN 1
        END), 0) AS ae_activity_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome IN('Type 1 A&E attendance', 'Type 2 A&E attendance', 'Type 3 & 4 A&E attendance')
            AND o.outcome_date > c.rtt_end_date
            THEN 1
        END), 0) AS ae_activity_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome IN('Type 1 A&E attendance', 'Type 2 A&E attendance', 'Type 3 & 4 A&E attendance')
            AND o.outcome_date <= c.rtt_end_date
            THEN o.outcome_cost
        END), 0) AS ae_cost_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome IN('Type 1 A&E attendance', 'Type 2 A&E attendance', 'Type 3 & 4 A&E attendance')
            AND o.outcome_date > c.rtt_end_date
            THEN o.outcome_cost
        END), 0) AS ae_cost_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'Emergency admission'
            AND o.outcome_date <= c.rtt_end_date
            THEN 1
        END), 0) AS emergency_activity_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'Emergency admission'
            AND o.outcome_date > c.rtt_end_date
            THEN 1
        END), 0) AS emergency_activity_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'Emergency admission'
            AND o.outcome_date <= c.rtt_end_date
            THEN o.outcome_cost
        END), 0) AS emergency_cost_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'Emergency admission'
            AND o.outcome_date > c.rtt_end_date
            THEN o.outcome_cost
        END), 0) AS emergency_cost_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome IN('Ordinary elective admission', 'Day case admission')
            AND o.outcome_date <= c.rtt_end_date
            THEN 1
        END), 0) AS elective_activity_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome IN('Ordinary elective admission', 'Day case admission')
            AND o.outcome_date > c.rtt_end_date
            THEN 1
        END), 0) AS elective_activity_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome IN('Ordinary elective admission', 'Day case admission')
            AND o.outcome_date <= c.rtt_end_date
            THEN o.outcome_cost
        END), 0) AS elective_cost_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome IN('Ordinary elective admission', 'Day case admission')
            AND o.outcome_date > c.rtt_end_date
            THEN o.outcome_cost
        END), 0) AS elective_cost_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'Med3 certificate'
            AND o.outcome_date <= c.rtt_end_date
            THEN 1
        END), 0) AS sicknote_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'Med3 certificate'
            AND o.outcome_date > c.rtt_end_date
            THEN 1
        END), 0) AS sicknote_post,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'Unique prescription'
            AND o.outcome_date <= c.rtt_end_date
            THEN 1
        END), 0) AS prescription_pre,
    IFNULL(SUM(CASE
        WHEN
            o.outcome = 'Unique prescription'
            AND o.outcome_date > c.rtt_end_date
            THEN 1
        END), 0) AS prescription_post
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_outcomes AS o USING (patient_key, rtt_start_date, rtt_end_date)
GROUP BY
    c.patient_key,
    c.rtt_start_date,
    c.rtt_end_date,
    c.procedure,
    DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0
;