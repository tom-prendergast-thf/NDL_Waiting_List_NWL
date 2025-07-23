CREATE OR REPLACE TABLE did_sandbox_ndl.ndl.t5_pt_list_causal_final (
    patient_key NUMBER,
    rtt_start_date DATE,
    rtt_end_date DATE,
    procedure VARCHAR
)
;
INSERT INTO did_sandbox_ndl.ndl.t5_pt_list_causal_final
SELECT DISTINCT
    c.wlmds_patient_id,
    c.wlmds_rtt_start_date,
    c.wlmds_end_date,
    'cardiothoracic' AS procedure
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
    AND DATEDIFF(DAY, c.wlmds_rtt_start_date, l.wlmds_end_date) / 7.0 >= 6
    AND l.exclude IS NULL
    AND c.wlmds_end_date IS NOT NULL
    -- AND c.wlmds_priority = 30
UNION
SELECT DISTINCT
    c.wlmds_patient_id,
    c.wlmds_rtt_start_date,
    c.wlmds_end_date,
    'hip_replacement'
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
    AND DATEDIFF(DAY, c.wlmds_rtt_start_date, l.wlmds_end_date) / 7.0 >= 6
    AND l.exclude IS NULL
    AND c.wlmds_end_date IS NOT NULL
    -- AND c.wlmds_priority = 30
;
DELETE
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
WHERE
    EXISTS (
        SELECT
            NULL
        FROM
            (
                SELECT
                    patient_key,
                    rtt_start_date,
                    rtt_end_date,
                    ROW_NUMBER() OVER(
                        PARTITION BY
                            patient_key,
                            rtt_start_date
                        ORDER BY
                            rtt_end_date DESC
                    ) - 1 AS duplicate
                FROM
                    did_sandbox_ndl.ndl.t5_pt_list_causal_final
            ) AS dup
        WHERE
            c.patient_key = dup.patient_key
            AND c.rtt_start_date = dup.rtt_start_date
            AND c.rtt_end_date = dup.rtt_end_date
            AND dup.duplicate > 0
    )
;