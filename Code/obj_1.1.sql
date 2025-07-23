SELECT
    SUM(1) AS total,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 IS NULL
            OR DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 < 0
            THEN 1
        ELSE 0
        END) AS unknown,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 18
            THEN 1
        ELSE 0
        END) AS wks00,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 18
            THEN 1
        ELSE 0
        END) AS wks18,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 36
            THEN 1
        ELSE 0
        END) AS wks36,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 52
            THEN 1
        ELSE 0
        END) AS wks52
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
;
SELECT
    s.specialty,
    SUM(1) AS total,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 IS NULL
            OR DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 < 0
            THEN 1
        ELSE 0
        END) AS unknown,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 18
            THEN 1
        ELSE 0
        END) AS wks00,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 18
            THEN 1
        ELSE 0
        END) AS wks18,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 36
            THEN 1
        ELSE 0
        END) AS wks36,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 52
            THEN 1
        ELSE 0
        END) AS wks52
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
    LEFT JOIN did_sandbox_ndl.ndl.t5_ref_tfc AS s ON w.wlmds_tfc = TO_VARCHAR(s.treatment_function_code)
GROUP BY
    s.specialty
ORDER BY
    specialty
;
SELECT
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS total,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 IS NULL
            OR DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 < 0
            THEN 1
        ELSE 0
        END) AS unknown,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 18
            THEN 1
        ELSE 0
        END) AS wks00,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 18
            THEN 1
        ELSE 0
        END) AS wks18,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 36
            THEN 1
        ELSE 0
        END) AS wks36,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 52
            THEN 1
        ELSE 0
        END) AS wks52
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
GROUP BY
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END
ORDER BY
    gender
;
SELECT
    CASE
        WHEN d.age BETWEEN 0 AND 10
            THEN '00-10'
        WHEN d.age BETWEEN 11 AND 17
            THEN '11-17'
        WHEN d.age BETWEEN 18 AND 24
            THEN '18-24'
        WHEN d.age BETWEEN 25 AND 34
            THEN '25-34'
        WHEN d.age BETWEEN 35 AND 44
            THEN '35-44'
        WHEN d.age BETWEEN 45 AND 54
            THEN '45-54'
        WHEN d.age BETWEEN 55 AND 64
            THEN '55-64'
        WHEN d.age BETWEEN 65 AND 74
            THEN '65-74'
        WHEN d.age BETWEEN 75 AND 84
            THEN '75-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END AS age_band,
    SUM(1) AS total,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 IS NULL
            OR DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 < 0
            THEN 1
        ELSE 0
        END) AS unknown,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 18
            THEN 1
        ELSE 0
        END) AS wks00,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 18
            THEN 1
        ELSE 0
        END) AS wks18,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 36
            THEN 1
        ELSE 0
        END) AS wks36,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 52
            THEN 1
        ELSE 0
        END) AS wks52
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
GROUP BY
    CASE
        WHEN d.age BETWEEN 0 AND 10
            THEN '00-10'
        WHEN d.age BETWEEN 11 AND 17
            THEN '11-17'
        WHEN d.age BETWEEN 18 AND 24
            THEN '18-24'
        WHEN d.age BETWEEN 25 AND 34
            THEN '25-34'
        WHEN d.age BETWEEN 35 AND 44
            THEN '35-44'
        WHEN d.age BETWEEN 45 AND 54
            THEN '45-54'
        WHEN d.age BETWEEN 55 AND 64
            THEN '55-64'
        WHEN d.age BETWEEN 65 AND 74
            THEN '65-74'
        WHEN d.age BETWEEN 75 AND 84
            THEN '75-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END
ORDER BY
    age_band
;
SELECT
    imd_decile,
    SUM(1) AS total,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 IS NULL
            OR DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 < 0
            THEN 1
        ELSE 0
        END) AS unknown,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 18
            THEN 1
        ELSE 0
        END) AS wks00,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 18
            THEN 1
        ELSE 0
        END) AS wks18,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 36
            THEN 1
        ELSE 0
        END) AS wks36,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 52
            THEN 1
        ELSE 0
        END) AS wks52
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS total,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 IS NULL
            OR DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 < 0
            THEN 1
        ELSE 0
        END) AS unknown,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 18
            THEN 1
        ELSE 0
        END) AS wks00,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 18
            THEN 1
        ELSE 0
        END) AS wks18,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 36
            THEN 1
        ELSE 0
        END) AS wks36,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 52
            THEN 1
        ELSE 0
        END) AS wks52
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
GROUP BY
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END
ORDER BY
    ethnic_category
;
SELECT
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS total,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 IS NULL
            OR DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 < 0
            THEN 1
        ELSE 0
        END) AS unknown,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 18
            THEN 1
        ELSE 0
        END) AS wks00,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 18
            THEN 1
        ELSE 0
        END) AS wks18,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 36
            THEN 1
        ELSE 0
        END) AS wks36,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 52
            THEN 1
        ELSE 0
        END) AS wks52
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    CASE
        WHEN d.no_of_ltcs = 0
            THEN '0 LTCs'
        WHEN d.no_of_ltcs = 1
            THEN '1 LTCs'
        WHEN d.no_of_ltcs = 2
            THEN '2 LTCs'
        WHEN d.no_of_ltcs >= 3
            THEN '3+ LTCs'
        ELSE 'Unknown'
        END AS no_of_ltcs,
    SUM(1) AS total,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 IS NULL
            OR DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 < 0
            THEN 1
        ELSE 0
        END) AS unknown,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 18
            THEN 1
        ELSE 0
        END) AS wks00,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 18
            THEN 1
        ELSE 0
        END) AS wks18,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 36
            THEN 1
        ELSE 0
        END) AS wks36,
    SUM(CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 52
            THEN 1
        ELSE 0
        END) AS wks52
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
GROUP BY
    CASE
        WHEN d.no_of_ltcs = 0
            THEN '0 LTCs'
        WHEN d.no_of_ltcs = 1
            THEN '1 LTCs'
        WHEN d.no_of_ltcs = 2
            THEN '2 LTCs'
        WHEN d.no_of_ltcs >= 3
            THEN '3+ LTCs'
        ELSE 'Unknown'
        END
ORDER BY
    no_of_ltcs
;