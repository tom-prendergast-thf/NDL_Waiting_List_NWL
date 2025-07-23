SELECT
    CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 3
            THEN '0-3 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 3 AND 6
            THEN '4-6 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 6 AND 9
            THEN '7-9 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 9 AND 12
            THEN '10-12 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 12 AND 15
            THEN '13-15 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 15 AND 18
            THEN '16-18 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 18 AND 21
            THEN '19-21 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 21 AND 24
            THEN '22-24 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 24 AND 27
            THEN '25-27 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 27 AND 30
            THEN '28-30 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 30 AND 33
            THEN '31-33 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 33 AND 36
            THEN '34-36 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 36 AND 39
            THEN '37-39 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 39 AND 42
            THEN '40-42 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 42 AND 45
            THEN '43-45 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 45 AND 48
            THEN '46-48 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 48 AND 51
            THEN '49-51 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 51
            THEN '52+ weeks'
        END AS weeks_waiting,
    SUM(1) AS total
FROM
    did_sandbox_ndl.ndl.t5_pt_demographics AS d
    LEFT JOIN did_sandbox_ndl.ndl.t5_waiting_list AS w ON d.patient_key = w.wlmds_patient_id
        AND d.rtt_start_date = w.wlmds_rtt_start_date
        AND d.rtt_end_date = w.wlmds_end_date_fil
GROUP BY
    CASE
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 0 AND 3
            THEN '0-3 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 3 AND 6
            THEN '4-6 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 6 AND 9
            THEN '7-9 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 9 AND 12
            THEN '10-12 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 12 AND 15
            THEN '13-15 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 15 AND 18
            THEN '16-18 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 18 AND 21
            THEN '19-21 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 21 AND 24
            THEN '22-24 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 24 AND 27
            THEN '25-27 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 27 AND 30
            THEN '28-30 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 30 AND 33
            THEN '31-33 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 33 AND 36
            THEN '34-36 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 36 AND 39
            THEN '37-39 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 39 AND 42
            THEN '40-42 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 42 AND 45
            THEN '43-45 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 45 AND 48
            THEN '46-48 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 BETWEEN 48 AND 51
            THEN '49-51 weeks'
        WHEN DATEDIFF(DAY, d.rtt_start_date, d.rtt_end_date) / 7.0 > 51
            THEN '52+ weeks'
        END
ORDER BY
    weeks_waiting
;