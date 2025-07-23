SELECT
    CASE
        WHEN
            c.wlmds_end_date IS NULL
            OR c.wlmds_end_date < c.wlmds_rtt_start_date
            THEN 'Missing end date'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, l.wlmds_end_date) < 6 * 7
            THEN 'Short waiter'
        WHEN
            l.exclude IS NOT NULL
            THEN 'Incomplete follow-up'
        ELSE 'Include'
        END AS exclude,
    SUM(1) AS pathways
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_detail AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_list_causal AS l USING (wlmds_patient_id, wlmds_rtt_start_date, wlmds_end_date)
WHERE
    EXISTS (
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
            c.wlmds_end_date IS NULL
            OR c.wlmds_end_date < c.wlmds_rtt_start_date
            THEN 'Missing end date'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, l.wlmds_end_date) < 6 * 7
            THEN 'Short waiter'
        WHEN
            l.exclude IS NOT NULL
            THEN 'Incomplete follow-up'
        ELSE 'Include'
        END
;
SELECT
    CASE
        WHEN
            c.wlmds_end_date IS NULL
            OR c.wlmds_end_date < c.wlmds_rtt_start_date
            THEN 'Missing end date'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, l.wlmds_end_date) < 6 * 7
            THEN 'Short waiter'
        WHEN
            l.exclude IS NOT NULL
            THEN 'Incomplete follow-up'
        ELSE 'Include'
        END AS exclude,
    SUM(1) AS pathways
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_detail AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_list_causal AS l USING (wlmds_patient_id, wlmds_rtt_start_date, wlmds_end_date)
WHERE
    EXISTS (
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
            c.wlmds_end_date IS NULL
            OR c.wlmds_end_date < c.wlmds_rtt_start_date
            THEN 'Missing end date'
        WHEN
            DATEDIFF(DAY, c.wlmds_rtt_start_date, l.wlmds_end_date) < 6 * 7
            THEN 'Short waiter'
        WHEN
            l.exclude IS NOT NULL
            THEN 'Incomplete follow-up'
        ELSE 'Include'
        END
;