SELECT
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    CASE
        WHEN d.age BETWEEN 0 AND  17
            THEN '00-17'
        WHEN d.age BETWEEN 18 AND 34
            THEN '18-34'
        WHEN d.age BETWEEN 35 AND 49
            THEN '35-49'
        WHEN d.age BETWEEN 50 AND 64
            THEN '50-64'
        WHEN d.age BETWEEN 65 AND 84
            THEN '65-84'
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
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END,
    CASE
        WHEN d.age BETWEEN 0 AND  17
            THEN '00-17'
        WHEN d.age BETWEEN 18 AND 34
            THEN '18-34'
        WHEN d.age BETWEEN 35 AND 49
            THEN '35-49'
        WHEN d.age BETWEEN 50 AND 64
            THEN '50-64'
        WHEN d.age BETWEEN 65 AND 84
            THEN '65-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END
ORDER BY
    gender,
    age_band
;
SELECT
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
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
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END,
    imd_decile
ORDER BY
    gender,
    imd_decile
;
SELECT
    CASE
        WHEN d.age BETWEEN 0 AND  17
            THEN '00-17'
        WHEN d.age BETWEEN 18 AND 34
            THEN '18-34'
        WHEN d.age BETWEEN 35 AND 49
            THEN '35-49'
        WHEN d.age BETWEEN 50 AND 64
            THEN '50-64'
        WHEN d.age BETWEEN 65 AND 84
            THEN '65-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END AS age_band,
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
    CASE
        WHEN d.age BETWEEN 0 AND  17
            THEN '00-17'
        WHEN d.age BETWEEN 18 AND 34
            THEN '18-34'
        WHEN d.age BETWEEN 35 AND 49
            THEN '35-49'
        WHEN d.age BETWEEN 50 AND 64
            THEN '50-64'
        WHEN d.age BETWEEN 65 AND 84
            THEN '65-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END,
    imd_decile
ORDER BY
    age_band,
    imd_decile
;