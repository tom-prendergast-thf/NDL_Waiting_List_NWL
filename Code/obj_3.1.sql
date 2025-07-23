SELECT
    'Emergency admissions' AS pod,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(em_3m_prior) AS events_prior,
    SUM(em_during) AS events_during,
    SUM(em_3m_after) AS events_after,
    SUM(em_cost_3m_prior) AS cost_prior,
    SUM(em_cost_during) AS cost_during,
    SUM(em_cost_3m_after) AS cost_after,
    AVG(em_3m_prior) AS mean_events_prior,
    AVG(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(em_3m_after) AS mean_events_after,
    AVG(em_cost_3m_prior) AS mean_cost_prior,
    AVG(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(em_cost_3m_after) AS mean_cost_after,
    MEDIAN(em_3m_prior) AS median_events_prior,
    MEDIAN(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(em_3m_after) AS median_events_after,
    MEDIAN(em_cost_3m_prior) AS median_cost_prior,
    MEDIAN(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(em_cost_3m_after) AS median_cost_after,
    STDDEV(em_3m_prior) AS sd_events_prior,
    STDDEV(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(em_3m_after) AS sd_events_after,
    STDDEV(em_cost_3m_prior) AS sd_cost_prior,
    STDDEV(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(em_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_em AS em USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
;
SELECT
    'Emergency admissions' AS pod,
    s.specialty,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(em_3m_prior) AS events_prior,
    SUM(em_during) AS events_during,
    SUM(em_3m_after) AS events_after,
    SUM(em_cost_3m_prior) AS cost_prior,
    SUM(em_cost_during) AS cost_during,
    SUM(em_cost_3m_after) AS cost_after,
    AVG(em_3m_prior) AS mean_events_prior,
    AVG(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(em_3m_after) AS mean_events_after,
    AVG(em_cost_3m_prior) AS mean_cost_prior,
    AVG(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(em_cost_3m_after) AS mean_cost_after,
    MEDIAN(em_3m_prior) AS median_events_prior,
    MEDIAN(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(em_3m_after) AS median_events_after,
    MEDIAN(em_cost_3m_prior) AS median_cost_prior,
    MEDIAN(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(em_cost_3m_after) AS median_cost_after,
    STDDEV(em_3m_prior) AS sd_events_prior,
    STDDEV(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(em_3m_after) AS sd_events_after,
    STDDEV(em_cost_3m_prior) AS sd_cost_prior,
    STDDEV(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(em_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_em AS em USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
    LEFT JOIN did_sandbox_ndl.ndl.t5_ref_tfc AS s ON w.wlmds_tfc = TO_VARCHAR(s.treatment_function_code)
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    s.specialty
ORDER BY
    specialty
;
SELECT
    'Emergency admissions' AS pod,
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(em_3m_prior) AS events_prior,
    SUM(em_during) AS events_during,
    SUM(em_3m_after) AS events_after,
    SUM(em_cost_3m_prior) AS cost_prior,
    SUM(em_cost_during) AS cost_during,
    SUM(em_cost_3m_after) AS cost_after,
    AVG(em_3m_prior) AS mean_events_prior,
    AVG(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(em_3m_after) AS mean_events_after,
    AVG(em_cost_3m_prior) AS mean_cost_prior,
    AVG(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(em_cost_3m_after) AS mean_cost_after,
    MEDIAN(em_3m_prior) AS median_events_prior,
    MEDIAN(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(em_3m_after) AS median_events_after,
    MEDIAN(em_cost_3m_prior) AS median_cost_prior,
    MEDIAN(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(em_cost_3m_after) AS median_cost_after,
    STDDEV(em_3m_prior) AS sd_events_prior,
    STDDEV(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(em_3m_after) AS sd_events_after,
    STDDEV(em_cost_3m_prior) AS sd_cost_prior,
    STDDEV(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(em_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_em AS em USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Emergency admissions' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(em_3m_prior) AS events_prior,
    SUM(em_during) AS events_during,
    SUM(em_3m_after) AS events_after,
    SUM(em_cost_3m_prior) AS cost_prior,
    SUM(em_cost_during) AS cost_during,
    SUM(em_cost_3m_after) AS cost_after,
    AVG(em_3m_prior) AS mean_events_prior,
    AVG(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(em_3m_after) AS mean_events_after,
    AVG(em_cost_3m_prior) AS mean_cost_prior,
    AVG(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(em_cost_3m_after) AS mean_cost_after,
    MEDIAN(em_3m_prior) AS median_events_prior,
    MEDIAN(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(em_3m_after) AS median_events_after,
    MEDIAN(em_cost_3m_prior) AS median_cost_prior,
    MEDIAN(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(em_cost_3m_after) AS median_cost_after,
    STDDEV(em_3m_prior) AS sd_events_prior,
    STDDEV(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(em_3m_after) AS sd_events_after,
    STDDEV(em_cost_3m_prior) AS sd_cost_prior,
    STDDEV(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(em_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_em AS em USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Emergency admissions' AS pod,
    imd_decile,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(em_3m_prior) AS events_prior,
    SUM(em_during) AS events_during,
    SUM(em_3m_after) AS events_after,
    SUM(em_cost_3m_prior) AS cost_prior,
    SUM(em_cost_during) AS cost_during,
    SUM(em_cost_3m_after) AS cost_after,
    AVG(em_3m_prior) AS mean_events_prior,
    AVG(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(em_3m_after) AS mean_events_after,
    AVG(em_cost_3m_prior) AS mean_cost_prior,
    AVG(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(em_cost_3m_after) AS mean_cost_after,
    MEDIAN(em_3m_prior) AS median_events_prior,
    MEDIAN(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(em_3m_after) AS median_events_after,
    MEDIAN(em_cost_3m_prior) AS median_cost_prior,
    MEDIAN(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(em_cost_3m_after) AS median_cost_after,
    STDDEV(em_3m_prior) AS sd_events_prior,
    STDDEV(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(em_3m_after) AS sd_events_after,
    STDDEV(em_cost_3m_prior) AS sd_cost_prior,
    STDDEV(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(em_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_em AS em USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    'Emergency admissions' AS pod,
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(em_3m_prior) AS events_prior,
    SUM(em_during) AS events_during,
    SUM(em_3m_after) AS events_after,
    SUM(em_cost_3m_prior) AS cost_prior,
    SUM(em_cost_during) AS cost_during,
    SUM(em_cost_3m_after) AS cost_after,
    AVG(em_3m_prior) AS mean_events_prior,
    AVG(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(em_3m_after) AS mean_events_after,
    AVG(em_cost_3m_prior) AS mean_cost_prior,
    AVG(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(em_cost_3m_after) AS mean_cost_after,
    MEDIAN(em_3m_prior) AS median_events_prior,
    MEDIAN(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(em_3m_after) AS median_events_after,
    MEDIAN(em_cost_3m_prior) AS median_cost_prior,
    MEDIAN(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(em_cost_3m_after) AS median_cost_after,
    STDDEV(em_3m_prior) AS sd_events_prior,
    STDDEV(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(em_3m_after) AS sd_events_after,
    STDDEV(em_cost_3m_prior) AS sd_cost_prior,
    STDDEV(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(em_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_em AS em USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Emergency admissions' AS pod,
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(em_3m_prior) AS events_prior,
    SUM(em_during) AS events_during,
    SUM(em_3m_after) AS events_after,
    SUM(em_cost_3m_prior) AS cost_prior,
    SUM(em_cost_during) AS cost_during,
    SUM(em_cost_3m_after) AS cost_after,
    AVG(em_3m_prior) AS mean_events_prior,
    AVG(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(em_3m_after) AS mean_events_after,
    AVG(em_cost_3m_prior) AS mean_cost_prior,
    AVG(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(em_cost_3m_after) AS mean_cost_after,
    MEDIAN(em_3m_prior) AS median_events_prior,
    MEDIAN(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(em_3m_after) AS median_events_after,
    MEDIAN(em_cost_3m_prior) AS median_cost_prior,
    MEDIAN(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(em_cost_3m_after) AS median_cost_after,
    STDDEV(em_3m_prior) AS sd_events_prior,
    STDDEV(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(em_3m_after) AS sd_events_after,
    STDDEV(em_cost_3m_prior) AS sd_cost_prior,
    STDDEV(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(em_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_em AS em USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    'Emergency admissions' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(em_3m_prior) AS events_prior,
    SUM(em_during) AS events_during,
    SUM(em_3m_after) AS events_after,
    SUM(em_cost_3m_prior) AS cost_prior,
    SUM(em_cost_during) AS cost_during,
    SUM(em_cost_3m_after) AS cost_after,
    AVG(em_3m_prior) AS mean_events_prior,
    AVG(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(em_3m_after) AS mean_events_after,
    AVG(em_cost_3m_prior) AS mean_cost_prior,
    AVG(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(em_cost_3m_after) AS mean_cost_after,
    MEDIAN(em_3m_prior) AS median_events_prior,
    MEDIAN(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(em_3m_after) AS median_events_after,
    MEDIAN(em_cost_3m_prior) AS median_cost_prior,
    MEDIAN(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(em_cost_3m_after) AS median_cost_after,
    STDDEV(em_3m_prior) AS sd_events_prior,
    STDDEV(em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(em_3m_after) AS sd_events_after,
    STDDEV(em_cost_3m_prior) AS sd_cost_prior,
    STDDEV(em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(em_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY em_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY em_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_em AS em USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
SELECT
    'Elective admissions' AS pod,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(el_3m_prior) AS events_prior,
    SUM(el_during) AS events_during,
    SUM(el_3m_after) AS events_after,
    SUM(el_cost_3m_prior) AS cost_prior,
    SUM(el_cost_during) AS cost_during,
    SUM(el_cost_3m_after) AS cost_after,
    AVG(el_3m_prior) AS mean_events_prior,
    AVG(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(el_3m_after) AS mean_events_after,
    AVG(el_cost_3m_prior) AS mean_cost_prior,
    AVG(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(el_cost_3m_after) AS mean_cost_after,
    MEDIAN(el_3m_prior) AS median_events_prior,
    MEDIAN(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(el_3m_after) AS median_events_after,
    MEDIAN(el_cost_3m_prior) AS median_cost_prior,
    MEDIAN(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(el_cost_3m_after) AS median_cost_after,
    STDDEV(el_3m_prior) AS sd_events_prior,
    STDDEV(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(el_3m_after) AS sd_events_after,
    STDDEV(el_cost_3m_prior) AS sd_cost_prior,
    STDDEV(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(el_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_el AS el USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
;
SELECT
    'Elective admissions' AS pod,
    s.specialty,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(el_3m_prior) AS events_prior,
    SUM(el_during) AS events_during,
    SUM(el_3m_after) AS events_after,
    SUM(el_cost_3m_prior) AS cost_prior,
    SUM(el_cost_during) AS cost_during,
    SUM(el_cost_3m_after) AS cost_after,
    AVG(el_3m_prior) AS mean_events_prior,
    AVG(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(el_3m_after) AS mean_events_after,
    AVG(el_cost_3m_prior) AS mean_cost_prior,
    AVG(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(el_cost_3m_after) AS mean_cost_after,
    MEDIAN(el_3m_prior) AS median_events_prior,
    MEDIAN(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(el_3m_after) AS median_events_after,
    MEDIAN(el_cost_3m_prior) AS median_cost_prior,
    MEDIAN(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(el_cost_3m_after) AS median_cost_after,
    STDDEV(el_3m_prior) AS sd_events_prior,
    STDDEV(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(el_3m_after) AS sd_events_after,
    STDDEV(el_cost_3m_prior) AS sd_cost_prior,
    STDDEV(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(el_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_el AS el USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
    LEFT JOIN did_sandbox_ndl.ndl.t5_ref_tfc AS s ON w.wlmds_tfc = TO_VARCHAR(s.treatment_function_code)
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    s.specialty
ORDER BY
    specialty
;
SELECT
    'Elective admissions' AS pod,
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(el_3m_prior) AS events_prior,
    SUM(el_during) AS events_during,
    SUM(el_3m_after) AS events_after,
    SUM(el_cost_3m_prior) AS cost_prior,
    SUM(el_cost_during) AS cost_during,
    SUM(el_cost_3m_after) AS cost_after,
    AVG(el_3m_prior) AS mean_events_prior,
    AVG(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(el_3m_after) AS mean_events_after,
    AVG(el_cost_3m_prior) AS mean_cost_prior,
    AVG(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(el_cost_3m_after) AS mean_cost_after,
    MEDIAN(el_3m_prior) AS median_events_prior,
    MEDIAN(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(el_3m_after) AS median_events_after,
    MEDIAN(el_cost_3m_prior) AS median_cost_prior,
    MEDIAN(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(el_cost_3m_after) AS median_cost_after,
    STDDEV(el_3m_prior) AS sd_events_prior,
    STDDEV(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(el_3m_after) AS sd_events_after,
    STDDEV(el_cost_3m_prior) AS sd_cost_prior,
    STDDEV(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(el_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_el AS el USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Elective admissions' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(el_3m_prior) AS events_prior,
    SUM(el_during) AS events_during,
    SUM(el_3m_after) AS events_after,
    SUM(el_cost_3m_prior) AS cost_prior,
    SUM(el_cost_during) AS cost_during,
    SUM(el_cost_3m_after) AS cost_after,
    AVG(el_3m_prior) AS mean_events_prior,
    AVG(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(el_3m_after) AS mean_events_after,
    AVG(el_cost_3m_prior) AS mean_cost_prior,
    AVG(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(el_cost_3m_after) AS mean_cost_after,
    MEDIAN(el_3m_prior) AS median_events_prior,
    MEDIAN(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(el_3m_after) AS median_events_after,
    MEDIAN(el_cost_3m_prior) AS median_cost_prior,
    MEDIAN(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(el_cost_3m_after) AS median_cost_after,
    STDDEV(el_3m_prior) AS sd_events_prior,
    STDDEV(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(el_3m_after) AS sd_events_after,
    STDDEV(el_cost_3m_prior) AS sd_cost_prior,
    STDDEV(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(el_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_el AS el USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Elective admissions' AS pod,
    imd_decile,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(el_3m_prior) AS events_prior,
    SUM(el_during) AS events_during,
    SUM(el_3m_after) AS events_after,
    SUM(el_cost_3m_prior) AS cost_prior,
    SUM(el_cost_during) AS cost_during,
    SUM(el_cost_3m_after) AS cost_after,
    AVG(el_3m_prior) AS mean_events_prior,
    AVG(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(el_3m_after) AS mean_events_after,
    AVG(el_cost_3m_prior) AS mean_cost_prior,
    AVG(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(el_cost_3m_after) AS mean_cost_after,
    MEDIAN(el_3m_prior) AS median_events_prior,
    MEDIAN(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(el_3m_after) AS median_events_after,
    MEDIAN(el_cost_3m_prior) AS median_cost_prior,
    MEDIAN(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(el_cost_3m_after) AS median_cost_after,
    STDDEV(el_3m_prior) AS sd_events_prior,
    STDDEV(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(el_3m_after) AS sd_events_after,
    STDDEV(el_cost_3m_prior) AS sd_cost_prior,
    STDDEV(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(el_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_el AS el USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    'Elective admissions' AS pod,
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(el_3m_prior) AS events_prior,
    SUM(el_during) AS events_during,
    SUM(el_3m_after) AS events_after,
    SUM(el_cost_3m_prior) AS cost_prior,
    SUM(el_cost_during) AS cost_during,
    SUM(el_cost_3m_after) AS cost_after,
    AVG(el_3m_prior) AS mean_events_prior,
    AVG(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(el_3m_after) AS mean_events_after,
    AVG(el_cost_3m_prior) AS mean_cost_prior,
    AVG(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(el_cost_3m_after) AS mean_cost_after,
    MEDIAN(el_3m_prior) AS median_events_prior,
    MEDIAN(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(el_3m_after) AS median_events_after,
    MEDIAN(el_cost_3m_prior) AS median_cost_prior,
    MEDIAN(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(el_cost_3m_after) AS median_cost_after,
    STDDEV(el_3m_prior) AS sd_events_prior,
    STDDEV(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(el_3m_after) AS sd_events_after,
    STDDEV(el_cost_3m_prior) AS sd_cost_prior,
    STDDEV(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(el_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_el AS el USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Elective admissions' AS pod,
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(el_3m_prior) AS events_prior,
    SUM(el_during) AS events_during,
    SUM(el_3m_after) AS events_after,
    SUM(el_cost_3m_prior) AS cost_prior,
    SUM(el_cost_during) AS cost_during,
    SUM(el_cost_3m_after) AS cost_after,
    AVG(el_3m_prior) AS mean_events_prior,
    AVG(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(el_3m_after) AS mean_events_after,
    AVG(el_cost_3m_prior) AS mean_cost_prior,
    AVG(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(el_cost_3m_after) AS mean_cost_after,
    MEDIAN(el_3m_prior) AS median_events_prior,
    MEDIAN(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(el_3m_after) AS median_events_after,
    MEDIAN(el_cost_3m_prior) AS median_cost_prior,
    MEDIAN(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(el_cost_3m_after) AS median_cost_after,
    STDDEV(el_3m_prior) AS sd_events_prior,
    STDDEV(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(el_3m_after) AS sd_events_after,
    STDDEV(el_cost_3m_prior) AS sd_cost_prior,
    STDDEV(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(el_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_el AS el USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    'Elective admissions' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(el_3m_prior) AS events_prior,
    SUM(el_during) AS events_during,
    SUM(el_3m_after) AS events_after,
    SUM(el_cost_3m_prior) AS cost_prior,
    SUM(el_cost_during) AS cost_during,
    SUM(el_cost_3m_after) AS cost_after,
    AVG(el_3m_prior) AS mean_events_prior,
    AVG(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(el_3m_after) AS mean_events_after,
    AVG(el_cost_3m_prior) AS mean_cost_prior,
    AVG(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(el_cost_3m_after) AS mean_cost_after,
    MEDIAN(el_3m_prior) AS median_events_prior,
    MEDIAN(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(el_3m_after) AS median_events_after,
    MEDIAN(el_cost_3m_prior) AS median_cost_prior,
    MEDIAN(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(el_cost_3m_after) AS median_cost_after,
    STDDEV(el_3m_prior) AS sd_events_prior,
    STDDEV(el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(el_3m_after) AS sd_events_after,
    STDDEV(el_cost_3m_prior) AS sd_cost_prior,
    STDDEV(el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(el_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY el_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY el_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_el AS el USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
SELECT
    'A&E attendances' AS pod,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(ae_3m_prior) AS events_prior,
    SUM(ae_during) AS events_during,
    SUM(ae_3m_after) AS events_after,
    SUM(ae_cost_3m_prior) AS cost_prior,
    SUM(ae_cost_during) AS cost_during,
    SUM(ae_cost_3m_after) AS cost_after,
    AVG(ae_3m_prior) AS mean_events_prior,
    AVG(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(ae_3m_after) AS mean_events_after,
    AVG(ae_cost_3m_prior) AS mean_cost_prior,
    AVG(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(ae_cost_3m_after) AS mean_cost_after,
    MEDIAN(ae_3m_prior) AS median_events_prior,
    MEDIAN(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(ae_3m_after) AS median_events_after,
    MEDIAN(ae_cost_3m_prior) AS median_cost_prior,
    MEDIAN(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(ae_cost_3m_after) AS median_cost_after,
    STDDEV(ae_3m_prior) AS sd_events_prior,
    STDDEV(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(ae_3m_after) AS sd_events_after,
    STDDEV(ae_cost_3m_prior) AS sd_cost_prior,
    STDDEV(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(ae_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_ae AS ae USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
;
SELECT
    'A&E attendances' AS pod,
    s.specialty,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(ae_3m_prior) AS events_prior,
    SUM(ae_during) AS events_during,
    SUM(ae_3m_after) AS events_after,
    SUM(ae_cost_3m_prior) AS cost_prior,
    SUM(ae_cost_during) AS cost_during,
    SUM(ae_cost_3m_after) AS cost_after,
    AVG(ae_3m_prior) AS mean_events_prior,
    AVG(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(ae_3m_after) AS mean_events_after,
    AVG(ae_cost_3m_prior) AS mean_cost_prior,
    AVG(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(ae_cost_3m_after) AS mean_cost_after,
    MEDIAN(ae_3m_prior) AS median_events_prior,
    MEDIAN(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(ae_3m_after) AS median_events_after,
    MEDIAN(ae_cost_3m_prior) AS median_cost_prior,
    MEDIAN(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(ae_cost_3m_after) AS median_cost_after,
    STDDEV(ae_3m_prior) AS sd_events_prior,
    STDDEV(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(ae_3m_after) AS sd_events_after,
    STDDEV(ae_cost_3m_prior) AS sd_cost_prior,
    STDDEV(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(ae_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_ae AS ae USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
    LEFT JOIN did_sandbox_ndl.ndl.t5_ref_tfc AS s ON w.wlmds_tfc = TO_VARCHAR(s.treatment_function_code)
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    s.specialty
ORDER BY
    specialty
;
SELECT
    'A&E attendances' AS pod,
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(ae_3m_prior) AS events_prior,
    SUM(ae_during) AS events_during,
    SUM(ae_3m_after) AS events_after,
    SUM(ae_cost_3m_prior) AS cost_prior,
    SUM(ae_cost_during) AS cost_during,
    SUM(ae_cost_3m_after) AS cost_after,
    AVG(ae_3m_prior) AS mean_events_prior,
    AVG(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(ae_3m_after) AS mean_events_after,
    AVG(ae_cost_3m_prior) AS mean_cost_prior,
    AVG(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(ae_cost_3m_after) AS mean_cost_after,
    MEDIAN(ae_3m_prior) AS median_events_prior,
    MEDIAN(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(ae_3m_after) AS median_events_after,
    MEDIAN(ae_cost_3m_prior) AS median_cost_prior,
    MEDIAN(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(ae_cost_3m_after) AS median_cost_after,
    STDDEV(ae_3m_prior) AS sd_events_prior,
    STDDEV(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(ae_3m_after) AS sd_events_after,
    STDDEV(ae_cost_3m_prior) AS sd_cost_prior,
    STDDEV(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(ae_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_ae AS ae USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'A&E attendances' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(ae_3m_prior) AS events_prior,
    SUM(ae_during) AS events_during,
    SUM(ae_3m_after) AS events_after,
    SUM(ae_cost_3m_prior) AS cost_prior,
    SUM(ae_cost_during) AS cost_during,
    SUM(ae_cost_3m_after) AS cost_after,
    AVG(ae_3m_prior) AS mean_events_prior,
    AVG(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(ae_3m_after) AS mean_events_after,
    AVG(ae_cost_3m_prior) AS mean_cost_prior,
    AVG(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(ae_cost_3m_after) AS mean_cost_after,
    MEDIAN(ae_3m_prior) AS median_events_prior,
    MEDIAN(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(ae_3m_after) AS median_events_after,
    MEDIAN(ae_cost_3m_prior) AS median_cost_prior,
    MEDIAN(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(ae_cost_3m_after) AS median_cost_after,
    STDDEV(ae_3m_prior) AS sd_events_prior,
    STDDEV(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(ae_3m_after) AS sd_events_after,
    STDDEV(ae_cost_3m_prior) AS sd_cost_prior,
    STDDEV(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(ae_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_ae AS ae USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'A&E attendances' AS pod,
    imd_decile,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(ae_3m_prior) AS events_prior,
    SUM(ae_during) AS events_during,
    SUM(ae_3m_after) AS events_after,
    SUM(ae_cost_3m_prior) AS cost_prior,
    SUM(ae_cost_during) AS cost_during,
    SUM(ae_cost_3m_after) AS cost_after,
    AVG(ae_3m_prior) AS mean_events_prior,
    AVG(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(ae_3m_after) AS mean_events_after,
    AVG(ae_cost_3m_prior) AS mean_cost_prior,
    AVG(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(ae_cost_3m_after) AS mean_cost_after,
    MEDIAN(ae_3m_prior) AS median_events_prior,
    MEDIAN(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(ae_3m_after) AS median_events_after,
    MEDIAN(ae_cost_3m_prior) AS median_cost_prior,
    MEDIAN(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(ae_cost_3m_after) AS median_cost_after,
    STDDEV(ae_3m_prior) AS sd_events_prior,
    STDDEV(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(ae_3m_after) AS sd_events_after,
    STDDEV(ae_cost_3m_prior) AS sd_cost_prior,
    STDDEV(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(ae_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_ae AS ae USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    'A&E attendances' AS pod,
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(ae_3m_prior) AS events_prior,
    SUM(ae_during) AS events_during,
    SUM(ae_3m_after) AS events_after,
    SUM(ae_cost_3m_prior) AS cost_prior,
    SUM(ae_cost_during) AS cost_during,
    SUM(ae_cost_3m_after) AS cost_after,
    AVG(ae_3m_prior) AS mean_events_prior,
    AVG(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(ae_3m_after) AS mean_events_after,
    AVG(ae_cost_3m_prior) AS mean_cost_prior,
    AVG(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(ae_cost_3m_after) AS mean_cost_after,
    MEDIAN(ae_3m_prior) AS median_events_prior,
    MEDIAN(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(ae_3m_after) AS median_events_after,
    MEDIAN(ae_cost_3m_prior) AS median_cost_prior,
    MEDIAN(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(ae_cost_3m_after) AS median_cost_after,
    STDDEV(ae_3m_prior) AS sd_events_prior,
    STDDEV(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(ae_3m_after) AS sd_events_after,
    STDDEV(ae_cost_3m_prior) AS sd_cost_prior,
    STDDEV(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(ae_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_ae AS ae USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'A&E attendances' AS pod,
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(ae_3m_prior) AS events_prior,
    SUM(ae_during) AS events_during,
    SUM(ae_3m_after) AS events_after,
    SUM(ae_cost_3m_prior) AS cost_prior,
    SUM(ae_cost_during) AS cost_during,
    SUM(ae_cost_3m_after) AS cost_after,
    AVG(ae_3m_prior) AS mean_events_prior,
    AVG(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(ae_3m_after) AS mean_events_after,
    AVG(ae_cost_3m_prior) AS mean_cost_prior,
    AVG(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(ae_cost_3m_after) AS mean_cost_after,
    MEDIAN(ae_3m_prior) AS median_events_prior,
    MEDIAN(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(ae_3m_after) AS median_events_after,
    MEDIAN(ae_cost_3m_prior) AS median_cost_prior,
    MEDIAN(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(ae_cost_3m_after) AS median_cost_after,
    STDDEV(ae_3m_prior) AS sd_events_prior,
    STDDEV(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(ae_3m_after) AS sd_events_after,
    STDDEV(ae_cost_3m_prior) AS sd_cost_prior,
    STDDEV(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(ae_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_ae AS ae USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    'A&E attendances' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(ae_3m_prior) AS events_prior,
    SUM(ae_during) AS events_during,
    SUM(ae_3m_after) AS events_after,
    SUM(ae_cost_3m_prior) AS cost_prior,
    SUM(ae_cost_during) AS cost_during,
    SUM(ae_cost_3m_after) AS cost_after,
    AVG(ae_3m_prior) AS mean_events_prior,
    AVG(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(ae_3m_after) AS mean_events_after,
    AVG(ae_cost_3m_prior) AS mean_cost_prior,
    AVG(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(ae_cost_3m_after) AS mean_cost_after,
    MEDIAN(ae_3m_prior) AS median_events_prior,
    MEDIAN(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(ae_3m_after) AS median_events_after,
    MEDIAN(ae_cost_3m_prior) AS median_cost_prior,
    MEDIAN(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(ae_cost_3m_after) AS median_cost_after,
    STDDEV(ae_3m_prior) AS sd_events_prior,
    STDDEV(ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(ae_3m_after) AS sd_events_after,
    STDDEV(ae_cost_3m_prior) AS sd_cost_prior,
    STDDEV(ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(ae_cost_3m_after) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_prior) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ae_cost_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ae_cost_3m_after) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_ae AS ae USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
SELECT
    'GP appointments' AS pod,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(gp_3m_prior) AS events_prior,
    SUM(gp_during) AS events_during,
    SUM(gp_3m_after) AS events_after,
    SUM(gp_3m_prior * 26.91) AS cost_prior,
    SUM(gp_during / 26.91) AS cost_during,
    SUM(gp_3m_after * 26.91) AS cost_after,
    AVG(gp_3m_prior) AS mean_events_prior,
    AVG(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(gp_3m_after) AS mean_events_after,
    AVG(gp_3m_prior * 26.91) AS mean_cost_prior,
    AVG(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(gp_3m_after * 26.91) AS mean_cost_after,
    MEDIAN(gp_3m_prior) AS median_events_prior,
    MEDIAN(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(gp_3m_after) AS median_events_after,
    MEDIAN(gp_3m_prior * 26.91) AS median_cost_prior,
    MEDIAN(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(gp_3m_after * 26.91) AS median_cost_after,
    STDDEV(gp_3m_prior) AS sd_events_prior,
    STDDEV(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(gp_3m_after) AS sd_events_after,
    STDDEV(gp_3m_prior * 26.91) AS sd_cost_prior,
    STDDEV(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(gp_3m_after * 26.91) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_gp AS gp USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
;
SELECT
    'GP appointments' AS pod,
    s.specialty,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(gp_3m_prior) AS events_prior,
    SUM(gp_during) AS events_during,
    SUM(gp_3m_after) AS events_after,
    SUM(gp_3m_prior * 26.91) AS cost_prior,
    SUM(gp_during / 26.91) AS cost_during,
    SUM(gp_3m_after * 26.91) AS cost_after,
    AVG(gp_3m_prior) AS mean_events_prior,
    AVG(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(gp_3m_after) AS mean_events_after,
    AVG(gp_3m_prior * 26.91) AS mean_cost_prior,
    AVG(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(gp_3m_after * 26.91) AS mean_cost_after,
    MEDIAN(gp_3m_prior) AS median_events_prior,
    MEDIAN(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(gp_3m_after) AS median_events_after,
    MEDIAN(gp_3m_prior * 26.91) AS median_cost_prior,
    MEDIAN(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(gp_3m_after * 26.91) AS median_cost_after,
    STDDEV(gp_3m_prior) AS sd_events_prior,
    STDDEV(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(gp_3m_after) AS sd_events_after,
    STDDEV(gp_3m_prior * 26.91) AS sd_cost_prior,
    STDDEV(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(gp_3m_after * 26.91) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_gp AS gp USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
    LEFT JOIN did_sandbox_ndl.ndl.t5_ref_tfc AS s ON w.wlmds_tfc = TO_VARCHAR(s.treatment_function_code)
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    s.specialty
ORDER BY
    specialty
;
SELECT
    'GP appointments' AS pod,
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(gp_3m_prior) AS events_prior,
    SUM(gp_during) AS events_during,
    SUM(gp_3m_after) AS events_after,
    SUM(gp_3m_prior * 26.91) AS cost_prior,
    SUM(gp_during / 26.91) AS cost_during,
    SUM(gp_3m_after * 26.91) AS cost_after,
    AVG(gp_3m_prior) AS mean_events_prior,
    AVG(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(gp_3m_after) AS mean_events_after,
    AVG(gp_3m_prior * 26.91) AS mean_cost_prior,
    AVG(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(gp_3m_after * 26.91) AS mean_cost_after,
    MEDIAN(gp_3m_prior) AS median_events_prior,
    MEDIAN(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(gp_3m_after) AS median_events_after,
    MEDIAN(gp_3m_prior * 26.91) AS median_cost_prior,
    MEDIAN(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(gp_3m_after * 26.91) AS median_cost_after,
    STDDEV(gp_3m_prior) AS sd_events_prior,
    STDDEV(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(gp_3m_after) AS sd_events_after,
    STDDEV(gp_3m_prior * 26.91) AS sd_cost_prior,
    STDDEV(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(gp_3m_after * 26.91) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_gp AS gp USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'GP appointments' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(gp_3m_prior) AS events_prior,
    SUM(gp_during) AS events_during,
    SUM(gp_3m_after) AS events_after,
    SUM(gp_3m_prior * 26.91) AS cost_prior,
    SUM(gp_during / 26.91) AS cost_during,
    SUM(gp_3m_after * 26.91) AS cost_after,
    AVG(gp_3m_prior) AS mean_events_prior,
    AVG(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(gp_3m_after) AS mean_events_after,
    AVG(gp_3m_prior * 26.91) AS mean_cost_prior,
    AVG(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(gp_3m_after * 26.91) AS mean_cost_after,
    MEDIAN(gp_3m_prior) AS median_events_prior,
    MEDIAN(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(gp_3m_after) AS median_events_after,
    MEDIAN(gp_3m_prior * 26.91) AS median_cost_prior,
    MEDIAN(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(gp_3m_after * 26.91) AS median_cost_after,
    STDDEV(gp_3m_prior) AS sd_events_prior,
    STDDEV(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(gp_3m_after) AS sd_events_after,
    STDDEV(gp_3m_prior * 26.91) AS sd_cost_prior,
    STDDEV(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(gp_3m_after * 26.91) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_gp AS gp USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'GP appointments' AS pod,
    imd_decile,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(gp_3m_prior) AS events_prior,
    SUM(gp_during) AS events_during,
    SUM(gp_3m_after) AS events_after,
    SUM(gp_3m_prior * 26.91) AS cost_prior,
    SUM(gp_during / 26.91) AS cost_during,
    SUM(gp_3m_after * 26.91) AS cost_after,
    AVG(gp_3m_prior) AS mean_events_prior,
    AVG(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(gp_3m_after) AS mean_events_after,
    AVG(gp_3m_prior * 26.91) AS mean_cost_prior,
    AVG(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(gp_3m_after * 26.91) AS mean_cost_after,
    MEDIAN(gp_3m_prior) AS median_events_prior,
    MEDIAN(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(gp_3m_after) AS median_events_after,
    MEDIAN(gp_3m_prior * 26.91) AS median_cost_prior,
    MEDIAN(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(gp_3m_after * 26.91) AS median_cost_after,
    STDDEV(gp_3m_prior) AS sd_events_prior,
    STDDEV(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(gp_3m_after) AS sd_events_after,
    STDDEV(gp_3m_prior * 26.91) AS sd_cost_prior,
    STDDEV(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(gp_3m_after * 26.91) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_gp AS gp USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    'GP appointments' AS pod,
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(gp_3m_prior) AS events_prior,
    SUM(gp_during) AS events_during,
    SUM(gp_3m_after) AS events_after,
    SUM(gp_3m_prior * 26.91) AS cost_prior,
    SUM(gp_during / 26.91) AS cost_during,
    SUM(gp_3m_after * 26.91) AS cost_after,
    AVG(gp_3m_prior) AS mean_events_prior,
    AVG(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(gp_3m_after) AS mean_events_after,
    AVG(gp_3m_prior * 26.91) AS mean_cost_prior,
    AVG(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(gp_3m_after * 26.91) AS mean_cost_after,
    MEDIAN(gp_3m_prior) AS median_events_prior,
    MEDIAN(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(gp_3m_after) AS median_events_after,
    MEDIAN(gp_3m_prior * 26.91) AS median_cost_prior,
    MEDIAN(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(gp_3m_after * 26.91) AS median_cost_after,
    STDDEV(gp_3m_prior) AS sd_events_prior,
    STDDEV(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(gp_3m_after) AS sd_events_after,
    STDDEV(gp_3m_prior * 26.91) AS sd_cost_prior,
    STDDEV(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(gp_3m_after * 26.91) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_gp AS gp USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'GP appointments' AS pod,
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(gp_3m_prior) AS events_prior,
    SUM(gp_during) AS events_during,
    SUM(gp_3m_after) AS events_after,
    SUM(gp_3m_prior * 26.91) AS cost_prior,
    SUM(gp_during / 26.91) AS cost_during,
    SUM(gp_3m_after * 26.91) AS cost_after,
    AVG(gp_3m_prior) AS mean_events_prior,
    AVG(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(gp_3m_after) AS mean_events_after,
    AVG(gp_3m_prior * 26.91) AS mean_cost_prior,
    AVG(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(gp_3m_after * 26.91) AS mean_cost_after,
    MEDIAN(gp_3m_prior) AS median_events_prior,
    MEDIAN(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(gp_3m_after) AS median_events_after,
    MEDIAN(gp_3m_prior * 26.91) AS median_cost_prior,
    MEDIAN(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(gp_3m_after * 26.91) AS median_cost_after,
    STDDEV(gp_3m_prior) AS sd_events_prior,
    STDDEV(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(gp_3m_after) AS sd_events_after,
    STDDEV(gp_3m_prior * 26.91) AS sd_cost_prior,
    STDDEV(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(gp_3m_after * 26.91) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_gp AS gp USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    'GP appointments' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(gp_3m_prior) AS events_prior,
    SUM(gp_during) AS events_during,
    SUM(gp_3m_after) AS events_after,
    SUM(gp_3m_prior * 26.91) AS cost_prior,
    SUM(gp_during / 26.91) AS cost_during,
    SUM(gp_3m_after * 26.91) AS cost_after,
    AVG(gp_3m_prior) AS mean_events_prior,
    AVG(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(gp_3m_after) AS mean_events_after,
    AVG(gp_3m_prior * 26.91) AS mean_cost_prior,
    AVG(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_cost_during,
    AVG(gp_3m_after * 26.91) AS mean_cost_after,
    MEDIAN(gp_3m_prior) AS median_events_prior,
    MEDIAN(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(gp_3m_after) AS median_events_after,
    MEDIAN(gp_3m_prior * 26.91) AS median_cost_prior,
    MEDIAN(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_cost_during,
    MEDIAN(gp_3m_after * 26.91) AS median_cost_after,
    STDDEV(gp_3m_prior) AS sd_events_prior,
    STDDEV(gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(gp_3m_after) AS sd_events_after,
    STDDEV(gp_3m_prior * 26.91) AS sd_cost_prior,
    STDDEV(gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_cost_during,
    STDDEV(gp_3m_after * 26.91) AS sd_cost_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after) AS iqr_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_prior * 26.91) AS iqr_cost_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_during / 26.91 * NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_cost_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY gp_3m_after * 26.91) AS iqr_cost_after
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_gp AS gp USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
SELECT
    'Unique prescriptions' AS pod,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(pres_3m_prior) AS events_prior,
    SUM(pres_during) AS events_during,
    SUM(pres_3m_after) AS events_after,
    AVG(pres_3m_prior) AS mean_events_prior,
    AVG(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(pres_3m_after) AS mean_events_after,
    MEDIAN(pres_3m_prior) AS median_events_prior,
    MEDIAN(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(pres_3m_after) AS median_events_after,
    STDDEV(pres_3m_prior) AS sd_events_prior,
    STDDEV(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(pres_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_presc AS pr USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
;
SELECT
    'Unique prescriptions' AS pod,
    s.specialty,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(pres_3m_prior) AS events_prior,
    SUM(pres_during) AS events_during,
    SUM(pres_3m_after) AS events_after,
    AVG(pres_3m_prior) AS mean_events_prior,
    AVG(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(pres_3m_after) AS mean_events_after,
    MEDIAN(pres_3m_prior) AS median_events_prior,
    MEDIAN(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(pres_3m_after) AS median_events_after,
    STDDEV(pres_3m_prior) AS sd_events_prior,
    STDDEV(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(pres_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_presc AS pr USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
    LEFT JOIN did_sandbox_ndl.ndl.t5_ref_tfc AS s ON w.wlmds_tfc = TO_VARCHAR(s.treatment_function_code)
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    s.specialty
ORDER BY
    specialty
;
SELECT
    'Unique prescriptions' AS pod,
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(pres_3m_prior) AS events_prior,
    SUM(pres_during) AS events_during,
    SUM(pres_3m_after) AS events_after,
    AVG(pres_3m_prior) AS mean_events_prior,
    AVG(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(pres_3m_after) AS mean_events_after,
    MEDIAN(pres_3m_prior) AS median_events_prior,
    MEDIAN(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(pres_3m_after) AS median_events_after,
    STDDEV(pres_3m_prior) AS sd_events_prior,
    STDDEV(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(pres_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_presc AS pr USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Unique prescriptions' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(pres_3m_prior) AS events_prior,
    SUM(pres_during) AS events_during,
    SUM(pres_3m_after) AS events_after,
    AVG(pres_3m_prior) AS mean_events_prior,
    AVG(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(pres_3m_after) AS mean_events_after,
    MEDIAN(pres_3m_prior) AS median_events_prior,
    MEDIAN(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(pres_3m_after) AS median_events_after,
    STDDEV(pres_3m_prior) AS sd_events_prior,
    STDDEV(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(pres_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_presc AS pr USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Unique prescriptions' AS pod,
    imd_decile,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(pres_3m_prior) AS events_prior,
    SUM(pres_during) AS events_during,
    SUM(pres_3m_after) AS events_after,
    AVG(pres_3m_prior) AS mean_events_prior,
    AVG(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(pres_3m_after) AS mean_events_after,
    MEDIAN(pres_3m_prior) AS median_events_prior,
    MEDIAN(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(pres_3m_after) AS median_events_after,
    STDDEV(pres_3m_prior) AS sd_events_prior,
    STDDEV(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(pres_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_presc AS pr USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    'Unique prescriptions' AS pod,
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(pres_3m_prior) AS events_prior,
    SUM(pres_during) AS events_during,
    SUM(pres_3m_after) AS events_after,
    AVG(pres_3m_prior) AS mean_events_prior,
    AVG(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(pres_3m_after) AS mean_events_after,
    MEDIAN(pres_3m_prior) AS median_events_prior,
    MEDIAN(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(pres_3m_after) AS median_events_after,
    STDDEV(pres_3m_prior) AS sd_events_prior,
    STDDEV(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(pres_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_presc AS pr USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Unique prescriptions' AS pod,
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(pres_3m_prior) AS events_prior,
    SUM(pres_during) AS events_during,
    SUM(pres_3m_after) AS events_after,
    AVG(pres_3m_prior) AS mean_events_prior,
    AVG(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(pres_3m_after) AS mean_events_after,
    MEDIAN(pres_3m_prior) AS median_events_prior,
    MEDIAN(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(pres_3m_after) AS median_events_after,
    STDDEV(pres_3m_prior) AS sd_events_prior,
    STDDEV(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(pres_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_presc AS pr USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    'Unique prescriptions' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(pres_3m_prior) AS events_prior,
    SUM(pres_during) AS events_during,
    SUM(pres_3m_after) AS events_after,
    AVG(pres_3m_prior) AS mean_events_prior,
    AVG(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(pres_3m_after) AS mean_events_after,
    MEDIAN(pres_3m_prior) AS median_events_prior,
    MEDIAN(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(pres_3m_after) AS median_events_after,
    STDDEV(pres_3m_prior) AS sd_events_prior,
    STDDEV(pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(pres_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY pres_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY pres_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_presc AS pr USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
SELECT
    'Sick notes' AS pod,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(med3_3m_prior) AS events_prior,
    SUM(med3_during) AS events_during,
    SUM(med3_3m_after) AS events_after,
    AVG(med3_3m_prior) AS mean_events_prior,
    AVG(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(med3_3m_after) AS mean_events_after,
    MEDIAN(med3_3m_prior) AS median_events_prior,
    MEDIAN(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(med3_3m_after) AS median_events_after,
    STDDEV(med3_3m_prior) AS sd_events_prior,
    STDDEV(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(med3_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_med3 AS m3 USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
;
SELECT
    'Sick notes' AS pod,
    s.specialty,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(med3_3m_prior) AS events_prior,
    SUM(med3_during) AS events_during,
    SUM(med3_3m_after) AS events_after,
    AVG(med3_3m_prior) AS mean_events_prior,
    AVG(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(med3_3m_after) AS mean_events_after,
    MEDIAN(med3_3m_prior) AS median_events_prior,
    MEDIAN(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(med3_3m_after) AS median_events_after,
    STDDEV(med3_3m_prior) AS sd_events_prior,
    STDDEV(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(med3_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_med3 AS m3 USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
    LEFT JOIN did_sandbox_ndl.ndl.t5_ref_tfc AS s ON w.wlmds_tfc = TO_VARCHAR(s.treatment_function_code)
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    s.specialty
ORDER BY
    specialty
;
SELECT
    'Sick notes' AS pod,
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(med3_3m_prior) AS events_prior,
    SUM(med3_during) AS events_during,
    SUM(med3_3m_after) AS events_after,
    AVG(med3_3m_prior) AS mean_events_prior,
    AVG(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(med3_3m_after) AS mean_events_after,
    MEDIAN(med3_3m_prior) AS median_events_prior,
    MEDIAN(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(med3_3m_after) AS median_events_after,
    STDDEV(med3_3m_prior) AS sd_events_prior,
    STDDEV(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(med3_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_med3 AS m3 USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Sick notes' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(med3_3m_prior) AS events_prior,
    SUM(med3_during) AS events_during,
    SUM(med3_3m_after) AS events_after,
    AVG(med3_3m_prior) AS mean_events_prior,
    AVG(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(med3_3m_after) AS mean_events_after,
    MEDIAN(med3_3m_prior) AS median_events_prior,
    MEDIAN(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(med3_3m_after) AS median_events_after,
    STDDEV(med3_3m_prior) AS sd_events_prior,
    STDDEV(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(med3_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_med3 AS m3 USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Sick notes' AS pod,
    imd_decile,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(med3_3m_prior) AS events_prior,
    SUM(med3_during) AS events_during,
    SUM(med3_3m_after) AS events_after,
    AVG(med3_3m_prior) AS mean_events_prior,
    AVG(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(med3_3m_after) AS mean_events_after,
    MEDIAN(med3_3m_prior) AS median_events_prior,
    MEDIAN(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(med3_3m_after) AS median_events_after,
    STDDEV(med3_3m_prior) AS sd_events_prior,
    STDDEV(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(med3_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_med3 AS m3 USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    'Sick notes' AS pod,
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(med3_3m_prior) AS events_prior,
    SUM(med3_during) AS events_during,
    SUM(med3_3m_after) AS events_after,
    AVG(med3_3m_prior) AS mean_events_prior,
    AVG(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(med3_3m_after) AS mean_events_after,
    MEDIAN(med3_3m_prior) AS median_events_prior,
    MEDIAN(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(med3_3m_after) AS median_events_after,
    STDDEV(med3_3m_prior) AS sd_events_prior,
    STDDEV(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(med3_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_med3 AS m3 USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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
    'Sick notes' AS pod,
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(med3_3m_prior) AS events_prior,
    SUM(med3_during) AS events_during,
    SUM(med3_3m_after) AS events_after,
    AVG(med3_3m_prior) AS mean_events_prior,
    AVG(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(med3_3m_after) AS mean_events_after,
    MEDIAN(med3_3m_prior) AS median_events_prior,
    MEDIAN(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(med3_3m_after) AS median_events_after,
    STDDEV(med3_3m_prior) AS sd_events_prior,
    STDDEV(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(med3_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_med3 AS m3 USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    'Sick notes' AS pod,
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
    SUM(1) AS pathways,
    COUNT(DISTINCT patient_key) AS unique_patients,
    SUM(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0) AS patient_weeks,
    SUM(med3_3m_prior) AS events_prior,
    SUM(med3_during) AS events_during,
    SUM(med3_3m_after) AS events_after,
    AVG(med3_3m_prior) AS mean_events_prior,
    AVG(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS mean_events_during,
    AVG(med3_3m_after) AS mean_events_after,
    MEDIAN(med3_3m_prior) AS median_events_prior,
    MEDIAN(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS median_events_during,
    MEDIAN(med3_3m_after) AS median_events_after,
    STDDEV(med3_3m_prior) AS sd_events_prior,
    STDDEV(med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS sd_events_during,
    STDDEV(med3_3m_after) AS sd_events_after,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_prior) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_prior) AS iqr_events_prior,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_during / NULLIFZERO(DATEDIFF(DAY, rtt_start_date, rtt_end_date) / 7.0)) AS iqr_events_during,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY med3_3m_after) - PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY med3_3m_after) AS iqr_events_after,
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_hcru_med3 AS m3 USING (patient_key, rtt_start_date, rtt_end_date)
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
WHERE d.rtt_end_date IS NOT NULL
    AND w.wlmds_priority = 30
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_prod.did.patientindex AS p
        WHERE
            p.patientkey = d.patient_key
            AND (
                p.registerstatus = 'R'
                OR (
                    p.registerstatus = 'L'
                    AND p.deregisterdate > DATEADD(MONTH, 3, d.rtt_end_date)
                )
                OR (
                    p.registerstatus = 'D'
                    AND p.monthofdeath > DATEADD(MONTH, 3, d.rtt_end_date)
                )
            )
    )
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