SELECT
    CASE
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 0 AND 3
            THEN '00-03'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 3 AND 6
            THEN '03-06'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 6 AND 9
            THEN '06-09'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 9 AND 12
            THEN '09-12'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 12 AND 15
            THEN '12-15'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 15 AND 18
            THEN '15-18'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 18 AND 21
            THEN '18-21'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 21 AND 24
            THEN '21-24'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 24 AND 27
            THEN '24-27'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 27 AND 30
            THEN '27-30'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 30 AND 33
            THEN '30-33'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 33 AND 36
            THEN '33-36'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 36 AND 39
            THEN '36-39'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 39 AND 42
            THEN '39-42'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 42 AND 45
            THEN '42-45'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 45 AND 48
            THEN '45-48'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 48 AND 52
            THEN '48-52'
        ELSE '52+'
        END AS wait_period,
    SUM(1) AS pathways
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_detail AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_list_causal AS l USING (wlmds_patient_id, wlmds_rtt_start_date)
WHERE
    c.wlmds_end_date >= c.wlmds_rtt_start_date
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_sandbox_ndl.ndl.t5_opcs AS p
        WHERE
            p.procedure = 'hip_replacement'
            AND (
                c.wlmds_opcs LIKE CONCAT('%', p.code, '%')
                OR c.wlmds_proposed_opcs LIKE CONCAT('%', p.code, '%')
                OR c.sus_domint_procedure LIKE CONCAT('%', p.code, '%')
                OR c.sus_primary_procedure LIKE CONCAT('%', p.code, '%')
            )
    )
GROUP BY
    CASE
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 0 AND 3
            THEN '00-03'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 3 AND 6
            THEN '03-06'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 6 AND 9
            THEN '06-09'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 9 AND 12
            THEN '09-12'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 12 AND 15
            THEN '12-15'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 15 AND 18
            THEN '15-18'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 18 AND 21
            THEN '18-21'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 21 AND 24
            THEN '21-24'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 24 AND 27
            THEN '24-27'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 27 AND 30
            THEN '27-30'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 30 AND 33
            THEN '30-33'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 33 AND 36
            THEN '33-36'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 36 AND 39
            THEN '36-39'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 39 AND 42
            THEN '39-42'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 42 AND 45
            THEN '42-45'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 45 AND 48
            THEN '45-48'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 48 AND 52
            THEN '48-52'
        ELSE '52+'
        END
ORDER BY
    wait_period
;
SELECT
    CASE
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 0 AND 3
            THEN '00-03'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 3 AND 6
            THEN '03-06'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 6 AND 9
            THEN '06-09'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 9 AND 12
            THEN '09-12'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 12 AND 15
            THEN '12-15'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 15 AND 18
            THEN '15-18'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 18 AND 21
            THEN '18-21'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 21 AND 24
            THEN '21-24'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 24 AND 27
            THEN '24-27'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 27 AND 30
            THEN '27-30'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 30 AND 33
            THEN '30-33'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 33 AND 36
            THEN '33-36'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 36 AND 39
            THEN '36-39'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 39 AND 42
            THEN '39-42'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 42 AND 45
            THEN '42-45'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 45 AND 48
            THEN '45-48'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 48 AND 52
            THEN '48-52'
        ELSE '52+'
        END AS wait_period,
    SUM(1) AS pathways
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_detail AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_list_causal AS l USING (wlmds_patient_id, wlmds_rtt_start_date)
WHERE
    c.wlmds_end_date >= c.wlmds_rtt_start_date
    AND EXISTS (
        SELECT
            NULL
        FROM
            did_sandbox_ndl.ndl.t5_opcs AS p
        WHERE
            p.procedure = 'cadiothoracic'
            AND (
                c.wlmds_opcs LIKE CONCAT('%', p.code, '%')
                OR c.wlmds_proposed_opcs LIKE CONCAT('%', p.code, '%')
                OR c.sus_domint_procedure LIKE CONCAT('%', p.code, '%')
                OR c.sus_primary_procedure LIKE CONCAT('%', p.code, '%')
            )
    )
GROUP BY
    CASE
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 0 AND 3
            THEN '00-03'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 3 AND 6
            THEN '03-06'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 6 AND 9
            THEN '06-09'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 9 AND 12
            THEN '09-12'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 12 AND 15
            THEN '12-15'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 15 AND 18
            THEN '15-18'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 18 AND 21
            THEN '18-21'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 21 AND 24
            THEN '21-24'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 24 AND 27
            THEN '24-27'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 27 AND 30
            THEN '27-30'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 30 AND 33
            THEN '30-33'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 33 AND 36
            THEN '33-36'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 36 AND 39
            THEN '36-39'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 39 AND 42
            THEN '39-42'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 42 AND 45
            THEN '42-45'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 45 AND 48
            THEN '45-48'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, c.wlmds_end_date) / 7.0 BETWEEN 48 AND 52
            THEN '48-52'
        ELSE '52+'
        END
ORDER BY
    wait_period
;